//
//  MenuViewController.m
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MenuCollectionCell.h"
#import "ItineraryTableViewController.h"
#import "FourSquareVenueHandler.h"
#import "FourSquareVenueParser.h"
#import "DayActivity.h"
#import "DayTrackViewController.h"
#import "EventKit/EventKit.h"
//#import "MBProgressHUD.h"



@interface MenuViewController() <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>



//plist and persistent data
@property (nonatomic, strong) AppDelegate  *delegate;
@property (nonatomic, strong) NSDictionary *dicPreferencesPlist;

//Check Internet
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

//Preferences
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userAge;
@property (nonatomic, strong) NSString *userGender;
@property (nonatomic, strong) NSDictionary *userPreferences;

//UI
@property (nonatomic, strong) NSArray *butonColors;
@property (nonatomic, strong) UIColor *red;
@property (nonatomic, strong) UIColor *purple;
@property (nonatomic, strong) UIColor *blue;
@property (nonatomic, strong) UIColor *yellow;
@property (nonatomic, weak) IBOutlet UICollectionView *cvTypeofDayMenu;
//@property (nonatomic, strong) MBProgressHUD *HUD;

//location
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;

//logic
@property (nonatomic, strong) NSString             *strTypeofDay;
@property (nonatomic, strong) NSString             *part;
@property (nonatomic, strong) NSString             *selectedPref;
@property (nonatomic, strong) NSArray              *arrTypesofDay;
@property (nonatomic, strong) NSDictionary         *dictOrderofParts;
@property (nonatomic, strong) NSMutableDictionary  *dictTypeofDay;
@property (nonatomic, strong) NSMutableDictionary  *dictPartsofDay;
@property (nonatomic, strong) NSMutableDictionary  *dictDaySuggestions;
@property (nonatomic, strong) NSMutableDictionary  *dictActivitiesSuggestions;



@end


@implementation MenuViewController



BOOL conexion = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get all the data of the preferences
    [self getandSetTypesofActivities];
    
    //Prepare Menu
    [self prepareMenu];
    
    //Check Internet Connectivity
    [self verificarlaConexionaInternet];
    
    //Notification for the completion of the data Query
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopWaiting) name:@"dataReceived" object:nil];
    
}



#pragma mark - Data and Preferences Methods
-(void)getandSetTypesofActivities
{
    
    //Call delegate SharedInstance for retrieving path to preference.list.
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    //Retreive plist as dictionary
    //
    //  Plist Structure:
    //
    //    UserAge     = 29;
    //    UserGender  = Male;
    //    UserLat     = "40.759211";
    //    UserLong    = "-73.984638";
    //    UserName    = Guilllermo;
    //    UserPrefs   = {
    //                    1 = (
    //                         eggs,
    //                         toast,
    //                         hashbrowns,
    //                         pancakes,
    //                         cereal
    //                         );
    //                  } ...
    NSDictionary *dicPreferencesPlist = [NSDictionary dictionaryWithContentsOfFile:self.delegate.documentsPreferencesPlistPath];
    
    //:: TODO :: Temporarily hardcoded. + Different kind of structures for the day.
    self.arrTypesofDay = @[@"Balanced Day", @"Active Day", @"One Activity", @"Extreme Day", @"Relaxed Day", @"Funny Day",@"More ..."];
    
    //:: TODO :: Temporarily hardcoded. + Ordered list with the different parts of each structure.
    self.dictOrderofParts  = @{ [NSNumber numberWithInt:1] : @"Breakfast",
                                [NSNumber numberWithInt:2] : @"Morning Activity",
                                [NSNumber numberWithInt:3] : @"Lunch",
                                [NSNumber numberWithInt:4] : @"Afternoon Activity",
                                [NSNumber numberWithInt:5] : @"Dinner",
                                [NSNumber numberWithInt:6] : @"Night Activity",
                                [NSNumber numberWithInt:7] : @"Snack",
                                [NSNumber numberWithInt:8] : @"Late Night Activity",
                                };
    
    //Extract preferences info
    self.userName        = dicPreferencesPlist[@"UserPrefs"];
    self.userAge         = dicPreferencesPlist[@"UserAge"];
    self.userGender      = dicPreferencesPlist[@"UserGender"];
    self.userLattitude   = dicPreferencesPlist[@"UserLat"];
    self.userLongitude   = dicPreferencesPlist[@"UserLong"];
    self.userPreferences = dicPreferencesPlist[@"UserPrefs"];
    
    //Construct Dictionary of the type of day acording to his preferences.
    //:: TODO :: Temporarily duplicade of structures + All days are going to be the same.
    NSMutableDictionary *dictPartandPrefs = [NSMutableDictionary new];
    for (NSNumber *preferencesofPart in self.userPreferences)
    {
        int pP = [preferencesofPart intValue];
        [dictPartandPrefs setValue:self.userPreferences[preferencesofPart] forKey:self.dictOrderofParts[[NSNumber numberWithInt:pP]]];
    }
    self.dictTypeofDay = [NSMutableDictionary new];
    for (NSString *typeOfDay in self.arrTypesofDay)
    {
        [self.dictTypeofDay setValue:[NSMutableDictionary dictionaryWithDictionary:dictPartandPrefs] forKey:typeOfDay];
    }
    
    //Prepare Dictionaries
    self.dictPartsofDay            = [NSMutableDictionary new];
    self.dictDaySuggestions        = [NSMutableDictionary new];
    self.dictActivitiesSuggestions = [NSMutableDictionary new];
    
}




#pragma mark - Menu Helpers
-(void)prepareMenu
{
    //Colors, buttons and stuff
    self.red    = [UIColor colorWithRed:(193/255.0f) green:(45/255.0f)  blue:(47/255.0f) alpha:1];
    self.purple = [UIColor colorWithRed:(67/255.0f)  green:(76/255.0f)  blue:(115/255.0f)alpha:1];
    self.blue   = [UIColor colorWithRed:(37/255.0f)  green:(56/255.0f)  blue:(83/255.0f) alpha:1];
    self.yellow = [UIColor colorWithRed:(207/255.0f) green:(178/255.0f) blue:(0/255.0f)  alpha:1];
    self.butonColors = @[self.red,self.purple,self.blue,self.yellow];
}




#pragma mark - Reachability
-(void)verificarlaConexionaInternet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cambioenConectividad:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:self.internetReachability];
}

-(void)cambioenConectividad:(NSNotification *)notification
{
    Reachability *reachability = [notification object];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            conexion = false;
            break;
        }
            
        case ReachableViaWWAN:
        {
            conexion = true;
            
            //Get current coordinates
            [self startTrackingPosition];
            break;
        }
        case ReachableViaWiFi:
        {
            conexion = true;
            
            //Get current coordinates
            [self startTrackingPosition];
            break;
        }
        default:
        {
            NSLog(@"NETWORK STATUS UNKNOWN");
        }
            break;
    }
    
}




#pragma mark - UICollectionView DataSource Method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrTypesofDay.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionCell *MCCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCCell" forIndexPath:indexPath];
    //[MCCell.btnMCCell addTarget:self action:@selector(startSearching:) forControlEvents:UIControlEventTouchUpInside];
    [MCCell.btnMCCell setTitle:self.arrTypesofDay[indexPath.row]forState:UIControlStateNormal];
    [MCCell.btnMCCell setBackgroundColor:self.butonColors[arc4random()%4]];
    return MCCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
}




#pragma mark - Core Location Methods
-(void)startTrackingPosition
{
    //Ask permition of user location while in use.
    self.locationManager = [CLLocationManager new];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //Accuracy 100 meters
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    
    //Start search.
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
{
    //Set coordinates
    self.userLattitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.latitude];
    self.userLongitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.longitude];
    
    if( self.userLattitude.length == 0 || self.userLongitude.length == 0  )
    {
        //Throw Alert if there is not location
        [[[UIAlertView alloc] initWithTitle:@"Position Alert" message:@"Looks like we can get your your current location, try a better connection or turn on location preferences in the location preferences panel" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        
        //Actual position of the computer where this app was developed.
        self.userLattitude  = @"33.924479";
        self.userLongitude  = @"-84.353967";
    }
    
    [self.locationManager stopUpdatingLocation];
}




-(void)startSearching:(id)sender
{
    
    //Search info for button pressed.
    UIButton *senderButton = (UIButton *)sender;
    self.dictPartsofDay = [self.dictTypeofDay objectForKey:senderButton.titleLabel.text];
    
    //:: TODO :: Reachability support + Check that we have coordinnates and resolve when not.
    if(self.userLattitude == 0 || self.userLongitude == 0)[self startTrackingPosition];
    
    //Search all the info for the user.
    NSArray *keys                     = [self.dictPartsofDay allKeys];
    NSUInteger numofDayParts          = keys.count;
    for (int i = 1; i <= numofDayParts ; i ++ )
    {
        //Search the part of the day that we are looking to program.
        self.part = [self.dictOrderofParts objectForKey:[NSNumber numberWithInt:i]];
        
        //Select one random preference from the user preferences for that part of the day.
        self.selectedPref = [[self.dictPartsofDay objectForKey:self.part] objectAtIndex:(arc4random()%[[self.dictPartsofDay objectForKey:self.part]count])];
        
        //Set the dictionary of activity suggestions.
        [self.dictDaySuggestions setObject:self.selectedPref forKey:self.part];
        
        //Prepare suggestion for html query and check for non nil suggestions.
        [FourSquareVenueHandler getDataforLatitude:self.userLattitude andLongitude:self.userLongitude andQuery:[self.selectedPref stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] andReturn:^(NSData *data)
         {
             //Parse information received.
             [FourSquareVenueParser parsearInformaciondelosItems:data alCompletar:^(NSArray *arrayItems)
              {
                  //Add Suggestions for each part of the day.
                  [self.dictActivitiesSuggestions setObject:arrayItems forKey:self.dictOrderofParts[[NSNumber numberWithInt:i]]];
              }];
             
         }];
    }
    
}

-(void)stopWaiting
{
    //NSLog(@"Tenemos info ...");
}



#pragma mark - Prepare Segue Method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if(conexion)
    {
        
        [self startSearching:sender];
        
        //Prepare the next view with the suggestions for the day.
        ItineraryTableViewController *itvc = [segue destinationViewController];
        [itvc setStrTypeofDay:self.strTypeofDay];
        [itvc setDictTypeofDay:self.dictTypeofDay];
        [itvc setDictPartsofDay:self.dictPartsofDay];
        [itvc setDictOrderofParts:self.dictOrderofParts];
        [itvc setDictDaySuggestions:self.dictDaySuggestions];
        [itvc setDictActivitiesSuggestions:self.dictActivitiesSuggestions];
        
    } else {
        
        //Throw Alert if there is not internet.
        [[[UIAlertView alloc] initWithTitle:@"No Internet, No Fun :(" message:@"Looks like your Internet connection is not working properly, Check it and try again!. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        
    }
    
    
}







#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
