//
//  MenuViewController.m
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"

@interface MenuViewController()

@property ( nonatomic, strong ) AppDelegate *delegate;
@property ( nonatomic, strong ) NSArray *arrTypesofDay;
@property ( nonatomic, strong ) UICollectionView *cvTypeofDayMenu;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //get the delegate SharedInstance for retrieving paths
    self.delegate = [[UIApplication sharedApplication] delegate];

    //from the preferences or another plist file
    self.arrTypesofDay = @[@"Balanced Day", @"Active Day", @"One Activity", @"Extreme Day", @"More ..."];
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
