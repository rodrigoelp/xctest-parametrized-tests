//
//  ExampleTests.m
//  KNMParametrizedTests-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KNMParametrizedTests/KNMParametrizedTests.h>


@interface ExampleTests : XCTestCase @end
@implementation ExampleTests

// Default tests still work the same

- (void)testExample
{
    XCTAssertEqual(1, 1, @"Should be the same");
}


// You can provide parameters by overriding +parametersForTestCaseWithSelector:

+ (NSArray *)parametersForTestCaseWithSelector:(SEL)selector
{
    if (selector == @selector(testWithParameters_V1:)) {
        return @[ @10, @20, @30, @40 ];
    }
    else {
        return [super parametersForTestCaseWithSelector:selector];
    }
}

- (void)testWithParameters_V1:(NSNumber *)parameter
{
    XCTAssert([parameter unsignedIntegerValue] >= 10, @"Should be greater than 10");
}


// As a shorthand you can also override +parametersFor<YourTestName>

+ (NSArray *)parametersForTestWithParameters_V2
{
    return @[ @"Hello", @"World" ];
}

- (void)testWithParameters_V2:(NSString *)parameter
{
    XCTAssert([parameter length] < 10, @"Should be shorter than 10 chars");
}


// This is equivalent to above

KNMParametersFor(testWithParameters_V3, @[ @"Hello", @"World" ])
- (void)testWithParameters_V3:(NSString *)parameter
{
    XCTAssert([parameter length] < 10, @"Should be shorter than 10 chars");
}

@end
