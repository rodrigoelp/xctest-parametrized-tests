//
//  KNMNilValue.m
//  KNMParametrizedTests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMNilValue.h"

@implementation KNMNilValue

+ (instancetype)nilValue
{
    static KNMNilValue *nilValue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nilValue = [[KNMNilValue alloc] init];
    });
    return nilValue;
}

@end
