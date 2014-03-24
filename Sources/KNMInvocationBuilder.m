//
//  KNMInvocationBuilder.m
//  KNMParametrizedTests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMInvocationBuilder.h"
#import "KNMNilValue.h"


@implementation KNMInvocationBuilder

#pragma mark - Initialization

+ (instancetype)builder
{
    static KNMInvocationBuilder *builder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        builder = [[KNMInvocationBuilder alloc] init];
    });
    return builder;
}


#pragma mark - Building Invocations

- (NSInvocation *)buildTestInvocationForSelector:(SEL)selector inClass:(Class)cls withParameter:(id)parameter
{
    NSMethodSignature *signature = [cls instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    
    if (parameter != [KNMNilValue nilValue]) {
        [invocation setArgument:(void *)&parameter atIndex:2];
    }
    
    return invocation;
}

@end
