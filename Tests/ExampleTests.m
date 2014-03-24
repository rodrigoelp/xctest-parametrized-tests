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

+ (NSArray *)parametersForTestWithSelector:(SEL)selector
{
    if (selector == @selector(testWithParameters_V1:)) {
        return @[ @"Hello", @"World" ];
    }
    else {
        return [super parametersForTestWithSelector:selector];
    }
}

- (void)testWithParameters_V1:(NSString *)parameter
{
    XCTAssert([parameter length] < 10, @"Should be shorter than 10 chars");
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


// There is a macro to provide the parameters

KNMParametersFor(testWithParameters_V3, @[ @"Hello", @"World" ])
- (void)testWithParameters_V3:(NSString *)parameter
{
    XCTAssert([parameter length] < 10, @"Should be shorter than 10 chars");
}


// you can also use the KNMParametrizedTest macro to shorten it even more

KNMParametrizedTest(testWithParameters_V4 withParameter (NSString*, parameter) fromList @[ @"Hello", @"World" ])
{
    XCTAssert([parameter length] < 10, @"Should be shorter than 10 chars");
}


// to pass nil as a parameter use the NIL macro

KNMParametersFor(testWithParameters_V5, @[ @"", NIL ])
- (void)testWithParameters_V5:(NSString *)parameter
{
    XCTAssert([parameter length] == 0, @"Should be exactly 0 chars");
}


// scalar and struct types are automatically coerced

KNMParametersFor(testWithParameters_V6, @[ @10, @20 ])
- (void)testWithParameters_V6:(NSUInteger)parameter
{
    XCTAssert(parameter >= 10, @"Should be bigger or equal 10 (was %lu)", (unsigned long)parameter);
}

KNMParametersFor(testWithParameters_V7, @[ VALUE(NSMakeRange(10, 10)), VALUE(NSMakeRange(20, 20)) ])
- (void)testWithParameters_V7:(NSRange)parameter
{
    XCTAssert(parameter.location >= 10, @"Should be bigger or equal 10 (was %lu)", (unsigned long)parameter.location);
}

@end
