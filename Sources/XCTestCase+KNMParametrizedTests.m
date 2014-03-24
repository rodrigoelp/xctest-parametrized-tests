//
//  XCTestCase+KNMParametrizedTests.m
//  konoma-parametrized-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "XCTestCase+KNMParametrizedTests.h"
#import "KNMParametrizedTestCaseScanner.h"
#import "KNMNilValue.h"

#import <objc/runtime.h>


#define SWIZZLE_INSTANCE_METHODS(CLS, S1, S2) method_exchangeImplementations(\
    class_getInstanceMethod((CLS), (S1)),\
    class_getInstanceMethod((CLS), (S2))\
)

#define SWIZZLE_CLASS_METHODS(CLS, S1, S2) method_exchangeImplementations(\
    class_getClassMethod((CLS), (S1)),\
    class_getClassMethod((CLS), (S2))\
)

static NSUInteger KNMInvocationIndexKey;


@implementation XCTestCase (KNMParametrizedTests)

#pragma mark - Initialization

+ (void)load
{
    SWIZZLE_INSTANCE_METHODS(self, @selector(name), @selector(knm_name));
    SWIZZLE_CLASS_METHODS(self, @selector(testInvocations), @selector(knm_default_testInvocations));
    SWIZZLE_CLASS_METHODS(self, @selector(testInvocations), @selector(knm_all_testInvocations));
}

#pragma mark - Adding Test Cases

+ (NSArray *)knm_all_testInvocations
{
    NSMutableArray *invocations = [NSMutableArray array];
    [invocations addObjectsFromArray:[self knm_default_testInvocations]];
    [invocations addObjectsFromArray:[self knm_parametrizedTestInvocations]];
    return invocations;
}

+ (NSArray *)knm_default_testInvocations
{
    return nil; // will be replaced by original implementation
}

+ (NSArray *)knm_parametrizedTestInvocations
{
    NSMutableArray *parametrizedInvocations = [NSMutableArray array];
    
    NSArray *selectors = [[KNMParametrizedTestCaseScanner scanner] selectorsForParametrizedTestsInClass:self];
    for (NSString *selectorName in selectors) {
        SEL selector = NSSelectorFromString(selectorName);
        [parametrizedInvocations addObjectsFromArray:[self knm_invocationsForParametrizedTestWithSelector:selector]];
    }
    
    return parametrizedInvocations;
}

+ (BOOL)knm_isParametrizedTestMethod:(Method)method
{
    NSString *methodName = NSStringFromSelector(method_getName(method));
    NSUInteger argCount = method_getNumberOfArguments(method);
    
    return ([methodName hasPrefix:@"test"] && argCount == 1);
}

+ (NSArray *)knm_invocationsForParametrizedTestWithSelector:(SEL)selector
{
    NSArray *parameters = [self parametersForTestWithSelector:selector];
    NSMutableArray *invocations = [NSMutableArray array];
    
    [parameters enumerateObjectsUsingBlock:^(id parameter, NSUInteger idx, BOOL *stop) {
        NSMethodSignature *signature = [self instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;
        if (parameter != [KNMNilValue nilValue]) {
            [invocation setArgument:(void *)&parameter atIndex:2];
        }
        objc_setAssociatedObject(invocation, &KNMInvocationIndexKey, @(idx), OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        [invocations addObject:invocation];
    }];
    
    return invocations;
}


#pragma mark - Configuration

- (NSString *)knm_name
{
    NSInvocation *invocation = [self invocation];
    if (![NSStringFromSelector(invocation.selector) hasSuffix:@":"]) {
        return [self knm_name]; // original name
    }
    
    // make sure the name does not have the : in it, otherwise Xcode won't display errors for this test
    // also add the test index to make the name unique
    NSString *name = [self knm_name];
    NSUInteger idx = [objc_getAssociatedObject(invocation, &KNMInvocationIndexKey) unsignedIntegerValue];
    NSString *identifier = [NSString stringWithFormat:@"_%lu", (unsigned long)idx];
    return [name stringByReplacingCharactersInRange:NSMakeRange((name.length - 2), 1) withString:identifier];
}


#pragma mark - Getting Parameters

+ (NSArray *)parametersForTestWithSelector:(SEL)selector
{
    SEL providerSelector = [[KNMParametrizedTestCaseScanner scanner] parameterProviderForTestWithSelector:selector inClass:self];
    if (providerSelector == NULL) {
        return @[];
    }
    
    IMP provider = [self methodForSelector:providerSelector];
    return ((id (*)(id, SEL))provider)(self, providerSelector);
}

@end


@interface KNMParametrizedTestCase : NSObject
@end

@implementation KNMParametrizedTestCase
@end
