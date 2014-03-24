//
//  KNMParametrizedTestsMacros.h
//  KNMParametrizedTests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


#define KNMParametersFor(TEST, PARAMS, ...)\
    + (NSArray *)parametersFor_ ## TEST { return PARAMS, ##__VA_ARGS__ ; }


#define KNMParametrizedTest(...) _KNMParametrizedTest(__VA_ARGS__)
#define knm_withParameter(PARAM) , PARAM
#define knm_fromList(...)        , (@[ __VA_ARGS__ ])

#ifndef KNM_PARAM_NO_SHORTHAND
    #define withParameter(PARAM) knm_withParameter(PARAM)
    #define fromList(...)        knm_fromList(__VA_ARGS__)
#endif

#define _KNMParametrizedTest(TEST, PARAM, PARAMS)\
    KNMParametersFor(TEST, PARAMS)\
    static void TEST ## _knm_executor(id self, SEL _cmd, PARAM);\
    - (void)TEST:(id)_knm_param { TEST ## _knm_executor(self, _cmd, _knm_param); }\
    static void TEST ## _knm_executor(id self, SEL _cmd, PARAM)
