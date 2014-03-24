//
//  XCTestCase+KNMParametrizedTests.h
//  konoma-parametrized-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>


@interface XCTestCase (KNMParametrizedTests)

+ (NSArray *)parametersForTestCaseWithSelector:(SEL)selector;

@end
