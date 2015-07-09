//
//  ViewController.h
//  ITin
//
//  Created by Mac on 6/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

/*
 
    Welcome View:
 
    This view takes charges of figuring out if this is your first run and take to the first survey or if not
    prepares the app with your coordinates and the preferences that the user already gave.

 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserPreferences.h"

@interface WelcomeViewController : UIViewController
- (IBAction)nxtButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *errorLbl;

@end

