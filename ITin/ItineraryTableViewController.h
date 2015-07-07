//
//  ItineraryTableViewController.h
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ItineraryTableViewController : UITableViewController


@property (nonatomic,strong) NSArray *userCalendarActivities;

@property (nonatomic, strong) NSString *strTypeofDay;
@property (nonatomic, strong) NSDictionary *dictTypeofDay;
@property (nonatomic, strong) NSDictionary *dictPartsofDay;
@property (nonatomic, strong) NSDictionary *dictOrderofParts;
@property (nonatomic, strong) NSMutableDictionary *dictDaySuggestions;
@property (nonatomic, strong) NSMutableDictionary *dictActivitiesSuggestions;

@property (nonatomic, strong) NSMutableArray *arrUserSelectedActivities;

@end
