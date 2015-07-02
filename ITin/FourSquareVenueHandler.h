//
//  FourSquareVenueHandler.h
//  IlistTableViewTest
//
//  Created by Mac on 6/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareVenueHandler : NSObject


+(void)getDataforLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andReturn:( void(^)(NSData * data) )complete;
+(void)getDataforLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andQuery:(NSString *)query andReturn:( void(^)(NSData * data) )complete;
+(void)getDataforLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andQuery:(NSString *)query andSection:(NSString *)section andReturn:( void(^)(NSData * data) )complete;


@end
