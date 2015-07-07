//
//  PreferencesView.h
//  ITin
//
//  Created by Mac on 7/2/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesView : UIViewController
@property (nonatomic,strong) NSMutableDictionary *myPrefs;// *userPrefs;
@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;
@property (nonatomic,strong) NSString *userName, *userAge , *userGender;
@property (nonatomic,strong)NSMutableArray  *userData;
@property (nonatomic,strong)NSMutableArray *userPrefs;
@property(nonatomic,strong) UIView *imgView;
@end
