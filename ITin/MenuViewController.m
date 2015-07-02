//
//  MenuViewController.m
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//


#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MenuCollectionCell.h"
#import "ItineraryTableViewController.h"


@interface MenuViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

@property ( nonatomic, strong ) AppDelegate *delegate;
@property ( nonatomic, strong ) NSArray *arrTypesofDay;
@property ( nonatomic, weak ) IBOutlet UICollectionView *cvTypeofDayMenu;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self getandSetTypesofActivities];
    



}


-(void)getandSetTypesofActivities
{
    //get the delegate SharedInstance for retrieving paths.
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    //...
    
    //from the preferences or another plist file get the types of days and add them to a cell.
    self.arrTypesofDay = @[@"Balanced Day", @"Active Day", @"One Activity", @"Extreme Day", @"Relaxed Day", @"Funny Day",@"More ..."];
    
}


#pragma mark <UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrTypesofDay.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionCell *MCCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCCell" forIndexPath:indexPath];
    
    
    
    [MCCell.btnMCCell setFrame:CGRectMake(0,
                                          0,
                                          self.view.frame.size.width,
                                          200)];
    [MCCell.btnMCCell setTitle:self.arrTypesofDay[indexPath.row]
                      forState:UIControlStateNormal];
    [MCCell.btnMCCell setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256 / 256.0)
                                                         green:(arc4random() % 256 / 256.0)
                                                          blue:(arc4random() % 256 / 256.0)
                                                         alpha:1]];
    
    
    return MCCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
}




#pragma mark - Prepare Segue Method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    ItineraryTableViewController *itvc = [segue destinationViewController];
    [itvc setStrTypeofDay:senderButton.titleLabel.text];
}




#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
