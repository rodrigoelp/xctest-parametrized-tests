//
//  KNMNilValue.h
//  KNMParametrizedTests
//
//  Created by Markus Gasser on 24.03.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNMNilValue : NSObject

+ (instancetype)nilValue;

@end


#define knm_NIL [KNMNilValue nilValue]
    #ifndef KNM_PARAM_NO_SHORTHAND
    #define NIL knm_NIL
#endif
