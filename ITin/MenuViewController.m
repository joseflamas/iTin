//
//  MenuViewController.m
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MenuCollectionCell.h"
#import "ItineraryTableViewController.h"
#import "FourSquareVenueHandler.h"
#import "FourSquareVenueParser.h"
#import "DayActivity.h"
#import "DayTrackViewController.h"


@interface MenuViewController() <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>

//plist and persistent data
@property ( nonatomic, strong ) AppDelegate *delegate;
//UI
@property (nonatomic, strong) NSArray *butonColors;
@property (nonatomic, strong) UIColor *red;
@property (nonatomic, strong) UIColor *purple;
@property (nonatomic, strong) UIColor *blue;
@property (nonatomic, strong) UIColor *yellow;
@property (nonatomic, weak) IBOutlet UICollectionView *cvTypeofDayMenu;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

//logic
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;

@property (nonatomic, strong) NSArray *arrTypesofDay;
@property (nonatomic, strong) NSString *strTypeofDay;
@property (nonatomic, strong) NSDictionary *dictTypeofDay;
@property (nonatomic, strong) NSMutableDictionary *dictPartsofDay;
@property (nonatomic, strong) NSDictionary *dictOrderofParts;
@property (nonatomic, strong) NSString *part;
@property (nonatomic, strong) NSString *selectedPref;
@property (nonatomic, strong) NSMutableDictionary *dictDaySuggestions;
@property (nonatomic, strong) NSMutableDictionary *dictActivitiesSuggestions;





@end


@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIColors
    self.red    = [UIColor colorWithRed:(193/255.0f) green:(45/255.0f)  blue:(47/255.0f) alpha:1];
    self.purple = [UIColor colorWithRed:(67/255.0f)  green:(76/255.0f)  blue:(115/255.0f)alpha:1];
    self.blue   = [UIColor colorWithRed:(37/255.0f)  green:(56/255.0f)  blue:(83/255.0f) alpha:1];
    self.yellow = [UIColor colorWithRed:(207/255.0f) green:(178/255.0f) blue:(0/255.0f)  alpha:1];
    self.butonColors = @[self.red,self.purple,self.blue,self.yellow];
    
    //Get all the data of the preferences
    [self getandSetTypesofActivities];
    
    //Get coordinates
    [self startTrackingPosition];

    //Notification for the completion of th data Query
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopWaiting) name:@"dataReceived" object:nil];
    
    
}



#pragma mark - Helper Methods
-(void)getandSetTypesofActivities
{
    //get the delegate SharedInstance for retrieving paths.
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    //...
    
    //from the preferences or another plist file get the types of days and add them to a cell.
    self.arrTypesofDay = @[@"Balanced Day", @"Active Day", @"One Activity", @"Extreme Day", @"Relaxed Day", @"Funny Day",@"More ..."];
    
    self.dictOrderofParts  = @{ [NSNumber numberWithInt:1] : @"Breakfast",
                                [NSNumber numberWithInt:2] : @"Morning Activity",
                                [NSNumber numberWithInt:3] : @"Lunch",
                                [NSNumber numberWithInt:4] : @"Afternoon Activity",
                                [NSNumber numberWithInt:5] : @"Dinner",
                                [NSNumber numberWithInt:6] : @"Night Activity",
                                [NSNumber numberWithInt:7] : @"Snack",
                                [NSNumber numberWithInt:8] : @"Late Night Activity",
                                };
    
    self.dictTypeofDay = @{ @"Balanced Day" : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 },
                            @"Active Day"   : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 },
                            @"One Activity" : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 },
                            @"Extreme Day"  : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 },
                            @"Relaxed Day"  : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 },
                            @"Funny Day"    : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 },
                            @"More ..."     : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Yoga"  , @"Exercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"Sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                                 }
                            
                            };
    
    
    //after user pick
    self.dictPartsofDay = [NSMutableDictionary new];
    self.dictDaySuggestions = [NSMutableDictionary new];
    self.dictActivitiesSuggestions = [NSMutableDictionary new];
    
}

-(void)stopWaiting
{
    NSLog(@"Tenemos info ...");

   
}





#pragma mark <UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrTypesofDay.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionCell *MCCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCCell" forIndexPath:indexPath];
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
    self.locationManager = [CLLocationManager new];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
{
    //    NSLog(@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    self.userLattitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.latitude];
    self.userLongitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.longitude];
    //[self.locationManager stopUpdatingLocation];
    
}





#pragma mark - Prepare Segue Method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    self.dictPartsofDay = [ self.dictTypeofDay objectForKey:senderButton.titleLabel.text];
    if(self.userLattitude == 0 || self.userLongitude == 0)[self startTrackingPosition];
    

    
    //[self startSearchingSuggestionsWithLatitude:self.userLattitude andLongitude:self.userLongitude];
    NSArray *keys                     = [self.dictPartsofDay allKeys];
    NSUInteger numofDayParts          = keys.count;
    
//    NSLog(@"%lu",(unsigned long)numofDayParts);
    
    for (int i = 1; i <= numofDayParts ; i ++ )
    {
        self.part = [self.dictOrderofParts objectForKey:[NSNumber numberWithInt:i]];
//        NSLog(@"%@", self.part);
        self.selectedPref = [[self.dictPartsofDay objectForKey:self.part] objectAtIndex:(arc4random()%[[self.dictPartsofDay objectForKey:self.part]count])];
//        NSLog(@"%@", self.selectedPref);
        [self.dictDaySuggestions setObject:self.selectedPref forKey:self.part];
        NSLog(@"%@",self.dictDaySuggestions);
        
        [FourSquareVenueHandler getDataforLatitude:self.userLattitude andLongitude:self.userLongitude andQuery:self.selectedPref andReturn:^(NSData *data)
         {
             [FourSquareVenueParser parsearInformaciondelosItems:data alCompletar:^(NSArray *arrayItems)
              {
                  [self.dictActivitiesSuggestions setObject:arrayItems forKey:self.dictOrderofParts[[NSNumber numberWithInt:i]]];
              }];
             
         }];
    }
    
    
//    NSLog(@"%@", self.dictActivitiesSuggestions);
    
    ItineraryTableViewController *itvc = [segue destinationViewController];
    [itvc setStrTypeofDay:self.strTypeofDay];
    [itvc setDictTypeofDay:self.dictTypeofDay];
    [itvc setDictPartsofDay:self.dictPartsofDay];
    [itvc setDictOrderofParts:self.dictOrderofParts];
    [itvc setDictDaySuggestions:self.dictDaySuggestions];
    [itvc setDictActivitiesSuggestions:self.dictActivitiesSuggestions];
    
}







#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
