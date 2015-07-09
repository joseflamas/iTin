//
//  ViewController.m
//  ITin
//
//  Created by Mac on 6/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//
#import "PreferencesView.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"



@interface WelcomeViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *errTxT;
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _errTxT.text = @"";
}
- (void)viewDidLoad
{
    self.delegate = [[UIApplication sharedApplication] delegate];
    
   
    self.documentsPreferencesPath       = self.delegate.documentsPreferencesPath;
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [self.documentsPreferencesPath stringByAppendingPathComponent:@"userPreferences.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"userPreferences.plist"] ];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) {
        
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    
    [super viewDidLoad];

    
    [_genderControl addTarget:self
                         action:@selector(action)
               forControlEvents:UIControlEventValueChanged];
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
}

-(void)action
{
    _errorLbl.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//Prepares user for next view by storing values J.S.

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   // PreferencesView *pv = [PreferencesView new];
    
    
    UserPreferences *up =  [UserPreferences sharedManager];
    
    up.userName = _nameTextField.text;
    up.userAge =[NSString stringWithFormat:@"%@",_ageNumber];
    
    NSInteger selectedIndex = (NSInteger)_genderControl.selectedSegmentIndex;
    
        if (selectedIndex == 0)
        up.userGender = @"Male";
    else
        up.userGender =@"Female";
    
    up.userLattitude = _userLattitude;
    up.userLongitude = _userLongitude;
     // Pass any objects to the view controller here, like...
   // [wvc setUserAge:up.userName];

    

    NSLog(@"User Name: %@, Age: %@ Gender: %@ Lat: %@ Long: %@",up.userName, up.userAge,up.userGender,up.userLattitude, up.userLongitude);
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSInteger selectedIndex = (NSInteger)_genderControl.selectedSegmentIndex;
    if ([_nameTextField.text  isEqual: @""])
    {
        _errTxT.text = @"Please enter your name!";
    }
    
    if (selectedIndex != 0 && selectedIndex != 1)
    {
        _errorLbl.text = @"Please enter gender!";
        return NO;
    }
    return YES;
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
- (IBAction)nxtButton:(id)sender {
    
    

}
@end
