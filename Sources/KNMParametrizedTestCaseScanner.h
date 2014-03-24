//
//  KNMParametrizedTestCaseScanner.h
//  konoma-parametrized-tests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNMParametrizedTestCaseScanner : NSObject

+ (instancetype)scanner;

- (NSArray *)selectorsForParametrizedTestCasesInClass:(Class)cls;

@end
