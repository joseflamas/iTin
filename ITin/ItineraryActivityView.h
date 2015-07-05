//
//  ItineraryActivityView.h
//  ITin
//
//  Created by Mac on 7/5/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryActivityView : UIView


@property (nonatomic, strong) NSString *strActivityId;
@property (nonatomic, strong) NSString *strActivityName;
@property (nonatomic, strong) NSString *strActivityReferralId;
@property (nonatomic, strong) NSString *strActivityPhone;
@property (nonatomic, strong) NSString *strActivityFormattedPhone;
@property (nonatomic, strong) NSNumber *numActivityLatitude;
@property (nonatomic, strong) NSNumber *numActivityLongitude;
@property (nonatomic, strong) NSNumber *numActivityDistance;
@property (nonatomic, strong) NSNumber *numActivityPostalCode;
@property (nonatomic, strong) NSString *strActivityAddress;
@property (nonatomic, strong) NSString *strActivityAddresscrossStreet;
@property (nonatomic, strong) NSString *strActivityCc;
@property (nonatomic, strong) NSString *strActivityCity;
@property (nonatomic, strong) NSString *strActivityState;
@property (nonatomic, strong) NSString *strActivityCountry;
@property (nonatomic, strong) NSArray  *arrActivityFormattedAddress;
@property (nonatomic, strong) NSString *strActivityCategoryId;
@property (nonatomic, strong) NSString *strActivityCategoryName;
@property (nonatomic, strong) NSString *strActivityCategoryPluralName;
@property (nonatomic, strong) NSString *strActivityCategoryShortName;


@end
