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


@end


@implementation ItineraryTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrUserSelectedActivities = [NSMutableArray new];
    
    for (int i = 1; i<= [[self.dictPartsofDay allKeys]count]; i++)
    {
        NSNumber *numActivity = [NSNumber numberWithInteger:i];
        NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
        NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
        
        [self.arrUserSelectedActivities addObject:activitiesPart[0]];
    }
    
    
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
    return title;//[self.dictOrderofParts objectForKey:[NSNumber  numberWithInt:(int)section+1]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITCell" forIndexPath:indexPath];
    cell.tag = indexPath.section+1;
    
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
        
        
        UILabel *etiquetaLat = [[UILabel alloc] initWithFrame:CGRectMake(W-105, Y-20,W,70)];
        [etiquetaLat setText: anActivity.numActivityLatitude.description];
        [pagina addSubview:etiquetaLat];
        [etiquetaLat setFont:pier];
        UILabel *etiquetaLng = [[UILabel alloc] initWithFrame:CGRectMake(W-105, Y-10,W,70)];
        [etiquetaLng setText: anActivity.numActivityLongitude.description];
        [pagina addSubview:etiquetaLng];
        [etiquetaLng setFont:pier];
        UILabel *etiquetaDistance = [[UILabel alloc] initWithFrame:CGRectMake(W-105, Y,W,70)];
        [etiquetaDistance setText:[NSString stringWithFormat:@"%@ km", anActivity.numActivityDistance.description
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
        
        UILabel *etiquetaCategory = [[UILabel alloc] initWithFrame:CGRectMake(10,Y-20,W,70)];
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
    
    cell.pageControl.tag = indexPath.section+1;
    cell.pageControl.numberOfPages = numActivitiesinPart;
    
    return cell;
}





#pragma mark - Swipes Methods
-(void)moveRight:(UISwipeGestureRecognizer *)sender
{
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;

    
    if (sView.tag >= 1 && sView.tag < 10)
        [UIView animateWithDuration:.5 animations:
         ^{
            [ssView setContentOffset:CGPointMake(self.view.frame.size.width * sView.tag,0)];
        }];
    
}

-(void)moveLeft:(UISwipeGestureRecognizer *)sender
{
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;
    
    
    if (sView.tag >= 2)
        [UIView animateWithDuration:.5 animations:
         ^{
             [ssView setContentOffset:CGPointMake(self.view.frame.size.width * (sView.tag-2),0)];
         }];
    
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DayTrackViewController *dtvc = [segue destinationViewController];
    [dtvc setArrDayActivities:self.arrUserSelectedActivities];
}




















#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
