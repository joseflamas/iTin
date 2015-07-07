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



@interface ItineraryTableViewController () <UITableViewDataSource, UITableViewDelegate >


@property (nonatomic, strong) NSMutableArray *arrCells;
@property (nonatomic, strong) NSMutableDictionary *userSelections;
@property (nonatomic, strong) NSDictionary *dictPartsofDaySchedule;

@end


@implementation ItineraryTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrCells = [NSMutableArray new];

    self.userSelections = [NSMutableDictionary new];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"1"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"2"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"3"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"4"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"5"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"6"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"7"];
    [self.userSelections setObject:[NSNumber numberWithInt:0] forKey:@"8"];
    
    self.dictPartsofDaySchedule  = @{ [NSNumber numberWithInt:1] : @"8:00 - 10:00",
                                      [NSNumber numberWithInt:2] : @"10:00 - 12:00",
                                      [NSNumber numberWithInt:3] : @"12:00 - 14:00",
                                      [NSNumber numberWithInt:4] : @"14:00 - 16:00",
                                      [NSNumber numberWithInt:5] : @"16:00 - 18:00",
                                      [NSNumber numberWithInt:6] : @"18:00 - 20:00",
                                      [NSNumber numberWithInt:7] : @"20:00 - 22:00",
                                      [NSNumber numberWithInt:8] : @"22:00 - 24:00",
                                      };


}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.dictPartsofDay allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"%@ : %@",[self.dictOrderofParts objectForKey:[NSNumber  numberWithInt:(int)section+1]], self.dictDaySuggestions[[self.dictOrderofParts objectForKey:[NSNumber  numberWithInt:(int)section+1]]] ];
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITCell" forIndexPath:indexPath];
    
    
    cell.partOftheDay = [NSNumber numberWithLong:indexPath.section+1];
    
    //NSLog(@"%@", cell.partOftheDay);
    
    NSNumber *numActivity = [NSNumber numberWithInteger:indexPath.section+1];
    NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
    NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
    NSUInteger numActivitiesinPart = [activitiesPart count];
    
    for(int a = 0; a < numActivitiesinPart; a++)
    {
        
        int Y = 0;
        int W = self.view.frame.size.width;
        int vH = 180;
        
        UIFont *pier  = [UIFont fontWithName:@"Pier Sans" size:10];
        UIFont *pierB = [UIFont fontWithName:@"Pier Sans" size:12];
        UIFont *pierC = [UIFont fontWithName:@"Pier Sans" size:14];
        UIFont *pierD = [UIFont fontWithName:@"Pier Sans" size:16];
        
        DayActivity *anActivity = activitiesPart[a];
        UIView *pagina = [[UIView alloc] initWithFrame:CGRectMake(W*a, Y, W, vH)];
        pagina.tag = a+1;
        [pagina setBackgroundColor:[UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0]];
        
        
        UILabel *etiquetaPagina = [[UILabel alloc] initWithFrame:CGRectMake(10, Y, W,250)];
        [etiquetaPagina setText: anActivity.strActivityName];
        [etiquetaPagina setFont:pierC];
        [pagina addSubview:etiquetaPagina];
        
        
        UILabel *etiquetaDistance = [[UILabel alloc] initWithFrame:CGRectMake(W-105, Y,W,70)];
        [etiquetaDistance setText:[NSString stringWithFormat:@"%@ meters", anActivity.numActivityDistance.description
                                   ]];
        [etiquetaDistance setFont:pier];
        [pagina addSubview:etiquetaDistance];
        
        
        UILabel *etiquetaAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, Y+5,W,70)];
        [etiquetaAddress setText: anActivity.strActivityAddress];
        [etiquetaAddress setFont:pierB];
        [pagina addSubview:etiquetaAddress];
        UILabel *etiquetaAddress1 = [[UILabel alloc] initWithFrame:CGRectMake(10, Y+25,W,70)];
        [etiquetaAddress1 setText: anActivity.strActivityCity];
        [etiquetaAddress1 setFont:pierB];
        [pagina addSubview:etiquetaAddress1];
        UILabel *etiquetaAddress2 = [[UILabel alloc] initWithFrame:CGRectMake(10, Y+45,W,70)];
        [etiquetaAddress2 setText: anActivity.strActivityState];
        [etiquetaAddress2 setFont:pierB];
        [pagina addSubview:etiquetaAddress2];
        
        UILabel *etiquetaCategory = [[UILabel alloc] initWithFrame:CGRectMake(10, Y-20,W,70)];
        [etiquetaCategory setText: anActivity.strActivityCategoryName];
        [etiquetaCategory setFont:pierD];
        [pagina addSubview:etiquetaCategory];
        
        
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
    
    if (sView.tag >= 1 && sView.tag < 10)
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






#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.arrUserSelectedActivities = [NSMutableArray new];
    
    dispatch_sync(dispatch_queue_create("setOpcions", nil),
    ^{
        for (int i = 1; i<= [[self.dictPartsofDay allKeys]count]; i++)
        {
            NSNumber *numActivity = [NSNumber numberWithInteger:i];
            NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
            NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
            NSNumber *userSelection = [self.userSelections objectForKey:[NSString stringWithFormat:@"%d",i]];
            
            [self.arrUserSelectedActivities addObject:activitiesPart[[userSelection intValue]]];
        }
    });
    
    DayTrackViewController *dtvc = [segue destinationViewController];
    [dtvc setArrDayActivities:self.arrUserSelectedActivities];
}




















#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
