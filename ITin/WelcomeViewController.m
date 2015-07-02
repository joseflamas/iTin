//
//  ViewController.m
//  ITin
//
//  Created by Mac on 6/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"


@interface WelcomeViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
//View Properties J.S.
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *agePickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderControl;
//CLLocation Properties J.S.
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;
//Delegate
@property ( nonatomic, strong ) AppDelegate *delegate;
//Paths
@property ( nonatomic, strong ) NSString *documentsDirectoryPath;       // ../Documents/
@property ( nonatomic, strong ) NSString *documentsPreferencesPath;     // ../Documents/preferences/
@property ( nonatomic, strong ) NSString *documentsPreferencesPlistPath;// ../Documents/preferences/userPreferences.plist
//Local Properties J.S.
@property (nonatomic,strong)NSMutableArray  *userData, *age;
@property (nonatomic,strong)NSNumber *ageNumber;
@property (nonatomic,strong) NSString *userName, *userAge , *userGender;
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
//    BOOL userHavePreferences             = [[NSFileManager defaultManager] fileExistsAtPath:self.documentsPreferencesPlistPath];
    
  
//get user location J.S.
  _locationManager = [CLLocationManager new];
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
{
    [_locationManager requestWhenInUseAuthorization];
}
_locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
_locationManager.delegate = self;
[_locationManager startUpdatingLocation];

    
    
    
    
    
    
    //set default age to 18 J.S.
    _ageNumber = [NSNumber numberWithInt:18];
    _age = [[NSMutableArray alloc] init];
    for (int i=18; i<=100; i++)
    {
        [_age addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    [_agePickerView reloadAllComponents];

 NSString *path = [[NSBundle mainBundle] pathForResource:@"userPreferences" ofType:@"plist"];
    
    // Load the file content and read the data into arrays J.S.
 //   NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    
   // Save the User Data in /Documents/preferences/userPreferences.plist if the file doesn't exist create it.
    // ...

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}






//Prepares user for next view by storing values J.S.

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _userName = _nameTextField.text;
    _userAge =[NSString stringWithFormat:@"%@",_ageNumber];
    
    NSInteger selectedIndex = (NSInteger)_genderControl.selectedSegmentIndex;
    if (selectedIndex == 0)
        _userGender = @"Male";
    else
        _userGender =@"Female";
    
    
    

    NSLog(@"User Name: %@, Age: %@ Gender: %@ Lat: %@ Long: %@",_userName,_userAge,_userGender,_userLattitude, _userLongitude);
}
//Dismisses keyboard J.S.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    self.userLattitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.latitude];
    self.userLongitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
   
}








#pragma mark - Picker View Methods J.S.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_age count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return [_age objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _ageNumber  = [_age objectAtIndex:row];
    
}
@end
