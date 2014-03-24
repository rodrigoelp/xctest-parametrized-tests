//
//  KNMParametrizedTestCase.h
//  konoma-parametrized-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCTestCase+KNMParametrizedTests.h"

#define KNMParametersFor(TEST, PARAMS, ...)\
    + (NSArray *)parametersFor_ ## TEST { return PARAMS, ##__VA_ARGS__ ; }
