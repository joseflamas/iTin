//
//  ViewController.m
//  ITin
//
//  Created by Mac on 6/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()


@property ( nonatomic, strong ) NSString *documentsDirectoryPath;
@property ( nonatomic, strong ) NSString *documentsPreferencesPath;
@property ( nonatomic, strong ) NSString *documentsPreferencesPlistPath;


@end



@implementation WelcomeViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    
    
    // Say hello nicely while in the background search for the phone location ( firstPointofUse ).
    // Ask for his or her name   ( userName )
    // Ask for his or her age    ( userAge  )
    // Ask for his or her gender ( userGender )
    // Save the User Data in /Documents/preferences/userPreferences.plist

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
