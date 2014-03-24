//
//  XCTestCase+KNMParametrizedTests.m
//  konoma-parametrized-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "XCTestCase+KNMParametrizedTests.h"
#import "KNMParametrizedTestCaseScanner.h"

#import <objc/runtime.h>


#define SWIZZLE_INSTANCE_METHODS(CLS, S1, S2) method_exchangeImplementations(\
    class_getInstanceMethod((CLS), (S1)),\
    class_getInstanceMethod((CLS), (S2))\
)

#define SWIZZLE_CLASS_METHODS(CLS, S1, S2) method_exchangeImplementations(\
    class_getClassMethod((CLS), (S1)),\
    class_getClassMethod((CLS), (S2))\
)


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
    
    NSArray *selectors = [[KNMParametrizedTestCaseScanner scanner] selectorsForParametrizedTestCasesInClass:self];
    for (NSString *selectorName in selectors) {
        SEL selector = NSSelectorFromString(selectorName);
        [parametrizedInvocations addObjectsFromArray:[self knm_invocationsForParametrizedTestCaseWithSelector:selector]];
    }
    
    return parametrizedInvocations;
}

+ (BOOL)knm_isParametrizedTestMethod:(Method)method
{
    NSString *methodName = NSStringFromSelector(method_getName(method));
    NSUInteger argCount = method_getNumberOfArguments(method);
    
    return ([methodName hasPrefix:@"test"] && argCount == 1);
}

+ (NSArray *)knm_invocationsForParametrizedTestCaseWithSelector:(SEL)selector
{
    NSArray *parameters = [self parametersForTestCaseWithSelector:selector];
    NSMutableArray *invocations = [NSMutableArray array];
    
    for (id parameter in parameters) {
        NSMethodSignature *signature = [self instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;
        [invocation setArgument:(void *)&parameter atIndex:2];
        [invocations addObject:invocation];
    }
    
    return invocations;
}


#pragma mark - Configuration

- (NSString *)knm_name
{
    // make sure the name does not have the : in it, otherwise Xcode won't display errors for this test
    NSString *name = [self knm_name];
    return ([name hasSuffix:@":]"]
            ? [[name substringToIndex:(name.length - 2)] stringByAppendingString:@"]"]
            : name);
}


#pragma mark - Getting Parameters

+ (NSArray *)parametersForTestCaseWithSelector:(SEL)selector
{
    return nil;
}

@end


@interface KNMParametrizedTestCase : NSObject
@end

@implementation KNMParametrizedTestCase
@end
