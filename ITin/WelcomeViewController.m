//
//  ViewController.m
//  ITin
//
//  Created by Mac on 6/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *agePickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderControl;

//Delegate
@property ( nonatomic, strong ) AppDelegate *delegate;
//Paths
@property ( nonatomic, strong ) NSString *documentsDirectoryPath;       // ../Documents/
@property ( nonatomic, strong ) NSString *documentsPreferencesPath;     // ../Documents/preferences/
@property ( nonatomic, strong ) NSString *documentsPreferencesPlistPath;// ../Documents/preferences/userPreferences.plist

@property (nonatomic,strong)NSMutableArray  *userData;
@end



@implementation WelcomeViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //get the delegate SharedInstance for retrieving paths
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    //paths for convenience
    self.documentsDirectoryPath         = self.delegate.documentsDirectoryPath;
    self.documentsPreferencesPath       = self.delegate.documentsPreferencesPath;
    self.documentsPreferencesPlistPath  = self.delegate.documentsPreferencesPlistPath;
    BOOL userHasPreferences             = [[NSFileManager defaultManager] fileExistsAtPath:self.documentsPreferencesPlistPath];
    
    
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"userPreferences" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _userData = [dict objectForKey:@"RecipeName"];
    
    
    // TO DO
    // Say hello nicely while in the background search for the phone location ( firstPointofUse ).
    // Ask for his or her name   ( userName )
    // Ask for his or her age    ( userAge  )
    // Ask for his or her gender ( userGender )
    // Save the User Data in /Documents/preferences/userPreferences.plist if the file doesn't exist create it.
    // ...
    
   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
