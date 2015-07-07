//
//  UserPreferences.h
//  ITin
//
//  Created by Mac on 7/6/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject {
    NSString *someProperty;
}

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;

@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;
@property (nonatomic,strong) NSString *userName, *userAge , *userGender;
@property (nonatomic,strong)NSMutableArray  *userData;
@property (nonatomic,strong) NSMutableArray *userPrefs;
@end
