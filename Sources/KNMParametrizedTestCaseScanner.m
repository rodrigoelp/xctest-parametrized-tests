//
//  KNMParametrizedTestCaseScanner.m
//  konoma-parametrized-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMParametrizedTestCaseScanner.h"

#import <objc/runtime.h>


@implementation KNMParametrizedTestCaseScanner

#pragma mark - Initialization

+ (instancetype)scanner
{
    static KNMParametrizedTestCaseScanner *scanner;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanner = [[KNMParametrizedTestCaseScanner alloc] init];
    });
    return scanner;
}


#pragma mark - Scanning

- (NSArray *)selectorsForParametrizedTestCasesInClass:(Class)cls
{
    NSMutableArray *selectors = [NSMutableArray array];
    
    unsigned int methodCount;
    Method *methods = class_copyMethodList(cls, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        if ([self isParametrizedTestMethod:methods[i]]) {
            [selectors addObject:NSStringFromSelector(method_getName(methods[i]))];
        }
    }
    free(methods);
    
    return selectors;
}

- (BOOL)isParametrizedTestMethod:(Method)method
{
    NSString *methodName = NSStringFromSelector(method_getName(method));
    NSUInteger argCount = method_getNumberOfArguments(method);
    
    return ([methodName hasPrefix:@"test"] && argCount == 3);
}

@end
