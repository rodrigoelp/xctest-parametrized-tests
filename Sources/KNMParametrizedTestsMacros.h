//
//  KNMParametrizedTestsMacros.h
//  KNMParametrizedTests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


#define KNMParametersFor(TEST, PARAMS, ...)\
    + (NSArray *)parametersFor_ ## TEST { return (@selector(TEST :), PARAMS, ##__VA_ARGS__); }


#define KNMParametrizedTest(...) _KNMParametrizedTest(__VA_ARGS__))
#define knm_withParameter(TYPE, PARAM) , TYPE, PARAM
#define knm_fromList                   , (

#ifndef KNM_PARAM_NO_SHORTHAND
    #define withParameter(TYPE, PARAM) knm_withParameter(TYPE, PARAM)
    #define fromList                   knm_fromList
#endif

#define _KNMParametrizedTest(TEST, TYPE, PARAM, PARAMS)\
    KNMParametersFor(TEST, PARAMS)\
    - (void)TEST:(TYPE)PARAM
