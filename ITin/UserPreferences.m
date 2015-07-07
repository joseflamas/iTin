//
//  UserPreferences.m
//  ITin
//
//  Created by Mac on 7/6/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "UserPreferences.h"
//static UserPreferences *single;
@implementation UserPreferences
//-(instancetype) init{
//    if(!single)
//        single = [UserPreferences new];
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        single = [UserPreferences new];
//    });
//    return single;
//}
//@end
+ (id)sharedManager {
    static UserPreferences *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

@end