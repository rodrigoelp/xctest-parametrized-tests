//
//  konoma_parametrized_testsTests.m
//  konoma-parametrized-testsTests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KNMParametrizedTests/KNMParametrizedTests.h>


@interface ExampleTests : XCTestCase @end
@implementation ExampleTests

- (void)testExample
{
    XCTFail(@"Fail example");
}

+ (NSArray *)parametersForTestCaseWithSelector:(SEL)selector
{
    return @[ @"Foo", @"Bar", @"Baz" ];
}

- (void)testExampleWithParameters:(NSString *)param
{
    XCTFail(@"Fail for param %@", param);
}

@end
