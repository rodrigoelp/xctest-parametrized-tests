# KNMParametrizedTest

KNMParametrizedTest adds support for parametrized test cases using the XCTest framework.

    KNMParametersFor(testExample, @[ @"Hello", @"World" ])
    - (void)testExample:(NSString *)word
    {
    	NSString *result = [myUppercaser uppercaseString:word];
        XCTAssertEqualObjects(result, [word uppercaseString], @"Uppercaser failed for word %@", word);
    }