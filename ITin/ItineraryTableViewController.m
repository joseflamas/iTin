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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *commitDay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(commitDayNow)];
    self.navigationItem.rightBarButtonItem = commitDay;
    
    
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
    return [[self.dictPartsofDay allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dictOrderofParts objectForKey:[NSNumber  numberWithInt:(int)section+1]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITCell" forIndexPath:indexPath];
    
    NSNumber *numActivity = [NSNumber numberWithInteger:indexPath.section+1];
    NSString *namePart = [self.dictOrderofParts objectForKey:numActivity];
    NSArray  *activitiesPart = [self.dictActivitiesSuggestions objectForKey:namePart];
    NSUInteger numActivitiesinPart = [activitiesPart count];
    
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
        
        [etiquetaPagina setText: anActivity.strActivityName];
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
    
    NSLog(@"tag : %ld", (long)sView.tag);
    
    if (sView.tag >= 1)// && sView.tag < self.arrUserSelectedActivities.count)
        [ssView setContentOffset:CGPointMake(self.view.frame.size.width * sView.tag,0)];

    
}

-(void)moveLeft:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"MoveLeft");
    
    UIView *sView = sender.view;
    UIScrollView *ssView = (UIScrollView*)sView.superview;

     NSLog(@"tag : %ld", (long)sView.tag);
    
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
