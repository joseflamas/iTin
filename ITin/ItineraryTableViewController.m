//
//  ItineraryTableViewController.m
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ItineraryTableViewController.h"
#import "ItineraryTableViewCell.h"
#import "FourSquareVenueHandler.h"
#import "FourSquareVenueParser.h"
#import "DayActivity.h"


@interface ItineraryTableViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;


@property (nonatomic, strong) NSDictionary *dictTypeofDay;
@property (nonatomic, strong) NSDictionary *dictPartsofDay;
@property (nonatomic, strong) NSMutableArray *arrUserSelectedActivities;


//Arrays for Balanced Day



@end


@implementation ItineraryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //NSLog(@"%@", self.strTypeofDay);
    [self startTrackingPosition];
    
    self.dictTypeofDay = @{ @"Balanced Day" : @{ @"Breakfast"          : @[@"Fruits", @"Juice"     , @"Eggs"],
                                                 @"Morning Activity"   : @[@"Run"   , @"Meditate"  , @"Excercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea%20food", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate%20Chips"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                               },
                            
                            @"Active Day"   : @{ @"Morning Activity"   : @[@"Run"   , @"Meditate"  , @"Excercise"]  },
                            @"One Activity" : @{ @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"sandwiches"] },
                            @"Extreme Day"  : @{ @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"] },
                            @"Relaxed Day"  : @{ @"Dinner"             : @[@"Pasta" , @"Sea%20food", @"Turkey"] },
                            @"Funny Day"    : @{ @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"]},
                            @"More ..."     : @{ @"Snack"              : @[@"Chocolate%20Chips"    , @"Hummus", @"Yogurt"]}
                            
                            };
    
    self.dictPartsofDay = [ self.dictTypeofDay objectForKey:self.strTypeofDay ];
    
    NSLog(@"%lu", (unsigned long)[[self.dictPartsofDay allKeys] count]);
    
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
    //NSLog(@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    self.userLattitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.latitude];
    self.userLongitude  = [[NSString alloc] initWithFormat:@"%6f", locationManager.location.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    [self startSearchingSuggestionsWithLatitude:self.userLattitude andLongitude:self.userLongitude];
}



#pragma mark - Helper Methods
-(void)startSearchingSuggestionsWithLatitude:(NSString *)lat andLongitude:(NSString *)log
{
    NSArray *keys                     = [self.dictPartsofDay allKeys];
    NSArray *preferences              = [self.dictPartsofDay objectForKey:[keys objectAtIndex:(arc4random() % keys.count)]];
    NSString *queryWithUserPreference = [preferences objectAtIndex:(arc4random() % preferences.count )];
    
    [FourSquareVenueHandler getDataforLatitude:lat andLongitude:log andQuery:queryWithUserPreference andReturn:^(NSData *data)
     {
         
         [FourSquareVenueParser parsearInformaciondelosItems:data alCompletar:^(NSArray *arrayItems)
          {
              dispatch_async(dispatch_get_main_queue(),
              ^{
                  self.arrUserSelectedActivities = [NSMutableArray arrayWithArray:arrayItems];
                  [self.tableView reloadData];
              });
              
          }];
         
         
     }];
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return (unsigned long)[[self.dictPartsofDay allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITCell" forIndexPath:indexPath];
    
    return cell;
}







/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
