//
//  FourSquareVenueParser.h
//  IlistTableViewTest
//
//  Created by Mac on 6/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayActivity.h"

@interface FourSquareVenueParser : NSObject

+(void)parsearInformaciondelosItems:(NSData *)dataItems alCompletar:( void(^)(NSArray* arrayItems))accionCompletar;

@end
