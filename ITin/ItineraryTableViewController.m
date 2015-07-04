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
#import "DayTrackViewController.h"


@interface ItineraryTableViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *userLattitude;
@property (nonatomic, strong) NSString *userLongitude;

@property (nonatomic, strong) NSDictionary *dictTypeofDay;
@property (nonatomic, strong) NSDictionary *dictPartsofDay;
@property (nonatomic, strong) NSDictionary *dictOrderofParts;
@property (nonatomic, strong) NSString *part;
@property (nonatomic, strong) NSString *selectedPref;
@property (nonatomic, strong) NSMutableDictionary *dictDaySuggestions;
@property (nonatomic, strong) NSMutableDictionary *dictActivitiesSuggestions;

@property (nonatomic, strong) NSMutableArray *arrUserSelectedActivities;





@end


@implementation ItineraryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *commitDay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(commitDayNow)];
    self.navigationItem.rightBarButtonItem = commitDay;
    
    //NSLog(@"%@", self.strTypeofDay);
    [self startTrackingPosition];
    
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
                                                 @"Morning Activity"   : @[@"Run"   , @"Meditate"  , @"Excercise"],
                                                 @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"sandwiches"],
                                                 @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"],
                                                 @"Dinner"             : @[@"Pasta" , @"Sea", @"Turkey"],
                                                 @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"],
                                                 @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"],
                                                 @"Late Night Activity": @[@"Bars"  , @"Clubs"     , @"Entertainment"]
                                               },
                            @"Active Day"   : @{ @"Morning Activity"   : @[@"Run"   , @"Meditate"  , @"Excercise"]  },
                            @"One Activity" : @{ @"Lunch"              : @[@"Wraps" , @"Muffins"   , @"sandwiches"] },
                            @"Extreme Day"  : @{ @"Afternoon Activity" : @[@"Picnic", @"Museums"   , @"Sports"] },
                            @"Relaxed Day"  : @{ @"Dinner"             : @[@"Pasta" , @"Sea"       , @"Turkey"] },
                            @"Funny Day"    : @{ @"Night Activity"     : @[@"Movies", @"Camping"   , @"Bowling"]},
                            @"More ..."     : @{ @"Snack"              : @[@"Chocolate"    , @"Hummus", @"Yogurt"]}
                            
                            };
    
    
    self.dictPartsofDay = [ self.dictTypeofDay objectForKey:self.strTypeofDay ];
    self.dictDaySuggestions = [NSMutableDictionary new];
    self.dictActivitiesSuggestions = [NSMutableDictionary new];
    
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
    [self.locationManager stopUpdatingLocation];
    [self startSearchingSuggestionsWithLatitude:self.userLattitude andLongitude:self.userLongitude];
}



#pragma mark - Helper Methods
-(void)startSearchingSuggestionsWithLatitude:(NSString *)lat andLongitude:(NSString *)log
{
    NSArray *keys                     = [self.dictPartsofDay allKeys];
    NSUInteger numofDayParts          = keys.count;
    
    for (int i = 1; i <= numofDayParts ; i ++ )
    {
        self.part = [self.dictOrderofParts objectForKey:[NSNumber numberWithInt:i]];
        self.selectedPref = [[self.dictPartsofDay objectForKey:self.part] objectAtIndex:(arc4random()%[[self.dictPartsofDay objectForKey:self.part]count])];
        [self.dictDaySuggestions setObject:self.selectedPref forKey:self.part];
//        NSLog(@"%@",self.dictDaySuggestions);
        
        [FourSquareVenueHandler getDataforLatitude:lat andLongitude:log andQuery:self.selectedPref andReturn:^(NSData *data)
         {
             [FourSquareVenueParser parsearInformaciondelosItems:data alCompletar:^(NSArray *arrayItems)
              {
                  [self.dictActivitiesSuggestions setObject:arrayItems forKey:self.dictOrderofParts[[NSNumber numberWithInt:i]]];
                  [self.tableView reloadData];
              }];
             
         }];
    }
    [self.tableView reloadData];
}

-(void)commitDayNow
{
    DayTrackViewController *dtvc = [[DayTrackViewController alloc] init];
    [self.navigationController pushViewController:dtvc animated:YES];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITCell" forIndexPath:indexPath];
    
    NSNumber *numActivity = [NSNumber numberWithInteger:indexPath.row+1];
    NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
    NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
    NSUInteger numActivitiesinPart = [activitiesPart count];
    
    NSLog(@"%@",numActivity);
    NSLog(@"%@",namePart);
    NSLog(@"%@",activitiesPart);
    NSLog(@"%lu",(unsigned long)numActivitiesinPart);
    
    
    
    for(int a = 0; a < numActivitiesinPart; a++)
    {
        
        DayActivity *anActivity = activitiesPart[a];
        UIView *pagina = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*a,
                                                                  0,
                                                                  self.view.frame.size.width,
                                                                  180)];
        
        [pagina setBackgroundColor:[UIColor colorWithRed:drand48()
                                                   green:drand48()
                                                    blue:drand48()
                                                   alpha:1.0]];
        
        UILabel *etiquetaPagina = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                            10,
                                                                            self.view.frame.size.width,
                                                                            100)];
        
        [etiquetaPagina setText: anActivity.strActivityCategoryName];
        [pagina addSubview:etiquetaPagina];
        pagina.tag = a+1;
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveRight:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLeft:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
        
        [pagina addGestureRecognizer:swipeRight];
        [pagina addGestureRecognizer:swipeLeft];
        
        
        [cell.scrollView addSubview:pagina];
       
    }
    
    cell.pageControl.numberOfPages = numActivitiesinPart;
    
    return cell;
}



#pragma mark - Swipes Methods
-(void)moveRight:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"MoveRight");
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;
    
    if (sView.tag >= 1 && sView.tag < self.arrUserSelectedActivities.count)
        [ssView setContentOffset:CGPointMake(self.view.frame.size.width * sView.tag,0)];

    
}

-(void)moveLeft:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"MoveLeft");
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;

    if (sView.tag >= 2)
        [ssView setContentOffset:CGPointMake(self.view.frame.size.width * (sView.tag-2),0)];
    
    
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
