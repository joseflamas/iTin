//
//  DayTrackViewController.m
//  ITin
//
//  Created by Mac on 7/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "DayTrackViewController.h"

@interface DayTrackViewController () <MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation DayTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *MCCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DCell" forIndexPath:indexPath];
    return MCCell;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
