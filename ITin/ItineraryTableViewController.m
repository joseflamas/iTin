//
//  ItineraryTableViewController.m
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "ItineraryTableViewCell.h"
#import "DayActivity.h"
#import "DayTrackViewController.h"
#import "EventKit/EventKit.h"



@interface ItineraryTableViewController () <UITableViewDataSource, UITableViewDelegate >


@end


@implementation ItineraryTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Prepare the array of cells.
    self.arrCells = [NSMutableArray new];

    //Set the first state.
    [self setFirstState];
    
    //Check if the user has already activities in the IOS calendar.
    [self matchUserActivities];
    

}


#pragma mark - Helper Methods
-(void)setFirstState
{
    //First state of the cells
    self.userSelections = [NSMutableDictionary new];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"1"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"2"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"3"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"4"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"5"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"6"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"7"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"8"];
    
    //Time intervals for the current structured day.
    self.dictPartsofDaySchedule  = [self todayIntervalsforPartsofTheDay:[self.dictOrderofParts allKeys]];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dictPartsofDay allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *partOD = [[self.dictOrderofParts objectForKey:[NSNumber  numberWithInt:(int)section+1]] uppercaseString];
    NSString *activity = [self.dictDaySuggestions[[self.dictOrderofParts objectForKey:[NSNumber  numberWithInt:(int)section+1]]] capitalizedString];
    
    
    NSString *title = [NSString stringWithFormat:@"%@ :: %@ ", partOD, activity];
    return title;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor blackColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITCell" forIndexPath:indexPath];

    
    cell.partOftheDay = [NSNumber numberWithLong:indexPath.section+1];
    NSNumber *numActivity = [NSNumber numberWithInteger:indexPath.section+1];
    NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
    NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
    NSUInteger numActivitiesinPart = [activitiesPart count];
    
    for(int a = 0; a < numActivitiesinPart; a++)
    {
        
        int Y = 0;
        int W = self.view.frame.size.width;
        int vH = 180;
        
        UIFont *pierName      = [UIFont fontWithName:@"Pier Sans" size:20];
        UIFont *pierCategory  = [UIFont italicSystemFontOfSize:10];//fontWithName:@"Pier Sans" size:10];
        UIFont *pierDistance  = [UIFont fontWithName:@"Pier Sans" size:10];
        UIFont *pierTime      = [UIFont fontWithName:@"Pier Sans" size:40];
        UIFont *pierDirection = [UIFont fontWithName:@"Pier Sans" size:14];
        
        DayActivity *anActivity = activitiesPart[a];
        
        anActivity.arrTimeDateIntervals = [self.dictPartsofDaySchedule objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithLong:indexPath.section+1]]];
        
        UIView *pagina = [[UIView alloc] initWithFrame:CGRectMake(W*a, Y, W, vH)];
        pagina.tag = a+1;
        
        if(anActivity.isFromUserCalendar)
        {
            [pagina setBackgroundColor:[UIColor colorWithRed:0.631 green:0.094 blue:0.271 alpha:1]];
            pierName = [UIFont fontWithName:@"Pier Sans" size:24];
            //[UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0]
        } else {
            
            [pagina setBackgroundColor:[UIColor whiteColor]];
        }
        
        //NAME
        UILabel *etiquetaPagina = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, W, 25)];
        [etiquetaPagina setText: anActivity.strActivityName];
        [etiquetaPagina setFont:pierName];
        [pagina addSubview:etiquetaPagina];
        
        //CATEGORY
        UILabel *etiquetaCategory = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, W,20)];
        [etiquetaCategory setText: anActivity.strActivityCategoryName];
        [etiquetaCategory setFont:pierCategory];
        if(anActivity.isFromUserCalendar)
        {
            [etiquetaCategory setTextColor:[UIColor blackColor]];
        }else{
            [etiquetaCategory setTextColor:[UIColor colorWithRed:0.631 green:0.094 blue:0.271 alpha:1]];
        }
        
        [pagina addSubview:etiquetaCategory];
        
        
        //TIME
        UILabel *etiquetaHora = [[UILabel alloc] initWithFrame:CGRectMake(W-190, 45, 190,100)];
        NSDate *dtAct = anActivity.arrTimeDateIntervals[0];
        NSArray *hours = [[dtAct.description componentsSeparatedByString:@" "][1] componentsSeparatedByString:@":"];
        [etiquetaHora setText:[NSString stringWithFormat:@"%@:%@", hours[0],hours[1]]];
        etiquetaHora.textAlignment = NSTextAlignmentRight;
        [etiquetaHora setFont:pierTime];
        [etiquetaHora setTextColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1]];
        [pagina addSubview:etiquetaHora];
        
        //DISTANCE
        UILabel *etiquetaDistance = [[UILabel alloc] initWithFrame:CGRectMake(W-125, 95, 120,70)];
        [etiquetaDistance setText:[NSString stringWithFormat:@"Distance: %@ mts", anActivity.numActivityDistance.description]];
        etiquetaDistance.textAlignment = NSTextAlignmentRight;
        [etiquetaDistance setFont:pierDistance];
        [pagina addSubview:etiquetaDistance];
        
        //ADDRESS
        UILabel *etiquetaAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, W-125,20)];
        [etiquetaAddress setText: anActivity.strActivityAddress];
        [etiquetaAddress setFont:pierDirection];
        [etiquetaAddress setTextColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1]];
        [pagina addSubview:etiquetaAddress];
        UILabel *etiquetaAddress1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, W-125,20)];
        [etiquetaAddress1 setText: anActivity.strActivityCity];
        [etiquetaAddress1 setFont:pierDirection];
        [etiquetaAddress1 setTextColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1]];
        [pagina addSubview:etiquetaAddress1];
        UILabel *etiquetaAddress2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, W-125,20)];
        [etiquetaAddress2 setText: anActivity.strActivityState];
        [etiquetaAddress2 setTextColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1]];
        [etiquetaAddress2 setFont:pierDirection];
        [pagina addSubview:etiquetaAddress2];
        

        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveRight:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLeft:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
        [pagina addGestureRecognizer:swipeRight];
        [pagina addGestureRecognizer:swipeLeft];
        
        [cell.scrollView addSubview:pagina];
    }
    
    cell.pageControl.numberOfPages = numActivitiesinPart;
    
    if([self.userSelections objectForKey:[NSString stringWithFormat:@"%@",cell.partOftheDay]] != nil)
    {
        NSNumber *selection = [self.userSelections objectForKey:[NSString stringWithFormat:@"%@",cell.partOftheDay]];
        [cell.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * [selection intValue],0)];
        cell.pageControl.currentPage = [selection intValue];
    }
    
    return cell;
}





#pragma mark - Swipes Methods
-(void)moveRight:(UISwipeGestureRecognizer *)sender
{
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;
    UIPageControl *pC = [[[ssView superview] subviews] objectAtIndex:1];
    ItineraryTableViewCell *itvc = (ItineraryTableViewCell*)[[ssView superview] superview];
    NSString *namePart = [self.dictOrderofParts objectForKey:itvc.partOftheDay];
    NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
    NSUInteger numActivitiesinPart = [activitiesPart count];
    
    if (sView.tag >= 1 && sView.tag < numActivitiesinPart)
        [UIView animateWithDuration:.3 animations:
         ^{
            [ssView setContentOffset:CGPointMake(self.view.frame.size.width * sView.tag,0)];
             
        } completion:^(BOOL finished) {
            
            itvc.currentSelection = [NSNumber numberWithLong:sView.tag];
            pC.currentPage = sView.tag;
            [self.userSelections setValue:[NSNumber numberWithLong: sView.tag] forKey:[NSString stringWithFormat:@"%@",itvc.partOftheDay]];
        }];
    
    
}

-(void)moveLeft:(UISwipeGestureRecognizer *)sender
{
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;
    UIPageControl *pC = [[[ssView superview] subviews] objectAtIndex:1];
    ItineraryTableViewCell *itvc = (ItineraryTableViewCell*)[[ssView superview] superview];
    
    if (sView.tag >= 2)
        [UIView animateWithDuration:.3 animations:
         ^{
             [ssView setContentOffset:CGPointMake(self.view.frame.size.width * (sView.tag-2),0)];
             
         } completion:^(BOOL finished) {
             
             itvc.currentSelection = [NSNumber numberWithLong:sView.tag];
             pC.currentPage = sView.tag-2;
 
             [self.userSelections setValue:[NSNumber numberWithLong: sView.tag-2] forKey:[NSString stringWithFormat:@"%@",itvc.partOftheDay]];
         }];
    

    
}


-(IBAction)prepareActivityList:(id)sender
{
    self.arrUserSelectedActivities = [NSMutableArray new];
    dispatch_sync(dispatch_queue_create("setOptions", nil),
      ^{

          for (int i = 1; i<= [[self.dictPartsofDay allKeys]count]; i++)
          {
              NSNumber *numActivity = [NSNumber numberWithInteger:i];
              NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
              NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
              NSNumber *userSelection = [self.userSelections objectForKey:[NSString stringWithFormat:@"%d",i]];
              
              if(userSelection != nil && userSelection != 0 && activitiesPart != nil && activitiesPart != 0)
              {
                  [self.arrUserSelectedActivities addObject:activitiesPart[[userSelection intValue]]];
              }

          }

      });
    
    [self performSegueWithIdentifier:@"gotoDetail" sender:sender];
}




#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    DayTrackViewController *dtvc = [segue destinationViewController];
    [dtvc setArrDayActivities:self.arrUserSelectedActivities];
}





#pragma mark - Dates Intervals 
-(NSDictionary *)todayIntervalsforPartsofTheDay:(NSArray *)partsoftheDay
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *todaymidnightUTC = [calendar dateFromComponents:dateComponents];
    
    NSDictionary *ranges = [NSMutableDictionary new];
    int rfrom = 8;
    int rto = 10;
    for (int r = 1; r <= partsoftheDay.count; r++)
    {
        NSDateComponents *dateComponentsFrom = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:todaymidnightUTC];
        [dateComponentsFrom setHour:rfrom];
        [dateComponentsFrom setMinute:0];
        [dateComponentsFrom setSecond:0];
        
        NSDateComponents *dateComponentsTo = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:todaymidnightUTC];
        [dateComponentsTo setHour:rto];
        [dateComponentsTo setMinute:0];
        [dateComponentsTo setSecond:0];
        
        NSDate *todayFrom = [calendar dateFromComponents:dateComponentsFrom];
        NSDate *todayTo   = [calendar dateFromComponents:dateComponentsTo];
        
        rfrom+=2;
        rto+=2;
 
        [ranges setValue:@[todayFrom,todayTo] forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:r]]];
    }
    
    return ranges;
}


-(void)matchUserActivities
{
    //Ask permition for calendar
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         // Get the appropriate calendar
         NSCalendar *calendar = [NSCalendar currentCalendar];
         
         // Create the start date components
         NSDateComponents *today = [[NSDateComponents alloc] init];
         today.day = 0;
         NSDate *fromToday = [calendar dateByAddingComponents:today
                                                       toDate:[NSDate date]
                                                      options:0];
         
         // Create the end date components
         NSDateComponents *tomorrow = [[NSDateComponents alloc] init];
         tomorrow.day = 1;
         NSDate *toTomorrow = [calendar dateByAddingComponents:tomorrow
                                                        toDate:[NSDate date]
                                                       options:0];
         
         // Create the predicate from the event store's instance method
         NSPredicate *predicate = [store predicateForEventsWithStartDate:fromToday
                                                                 endDate:toTomorrow
                                                               calendars:nil];
         
         // Fetch all events that match the predicate
         self.userCalendarActivities = [store eventsMatchingPredicate:predicate];
         for (EKEvent *event in self.userCalendarActivities)
         {

             
             for(int k = 1; k<=[[self.dictPartsofDay allKeys]count]; k++ )
             {
                 
                 NSString *key = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:k]];
                 NSArray *eventRange = [self.dictPartsofDaySchedule objectForKey:key];
                 
                 //Fix hour to the user calendar
                 NSDate *fromDeviceFixed = [NSDate dateWithTimeInterval:[[NSTimeZone defaultTimeZone] secondsFromGMTForDate:event.startDate] sinceDate:event.startDate];
                 
                 if( fromDeviceFixed >= eventRange[0] && fromDeviceFixed < eventRange[1] )
                 {
                     DayActivity *da = [DayActivity new];

                     da.strActivityName = event.title;
                     da.strActivityCategoryName = @"Already something in the calendar";
                     da.isFromUserCalendar = TRUE;
                     da.numActivityDistance = [NSNumber numberWithInt:0];
                     EKStructuredLocation *location = (EKStructuredLocation *)[event valueForKey:@"structuredLocation"];
  
                     //NSLog(@"%@",location);

                     da.strActivityAddress = [location valueForKey:@"address"];
                     
                     //NSLog(@"%@",[location valueForKey:@"geo"]);
                     
                     NSString *part = [self.dictOrderofParts objectForKey:[NSNumber numberWithInt:[key intValue]]];
                     [self.dictActivitiesSuggestions setObject:@[da] forKey:part];
                     
                 }
                 
             }
             
             
         }
         
     }];
    
    [self.tableView reloadData];
}











#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
