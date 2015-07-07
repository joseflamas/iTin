//
//  DayTrackViewController.m
//  ITin
//
//  Created by Mac on 7/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "DayTrackViewController.h"
#import "DayActivity.h"
#import "DayTrackPin.h"
#import "DayTrackCollectionViewCell.h"

@interface DayTrackViewController () <MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation DayTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"%@",self.arrDayActivities);
    [self prepareMap];
    
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    [self.collection setCollectionViewLayout:flowLayout];
}





#pragma mark - Map Methods
-(void)prepareMap
{
    if (self.mapView.annotations.count <= 0)
    {
        double lat = 0.0;
        double lon = 0.0;
        for(DayActivity *activity in self.arrDayActivities)
        {
            DayTrackPin *pin = [DayTrackPin new];
            pin.coordinate = CLLocationCoordinate2DMake([activity.numActivityLatitude doubleValue], [activity.numActivityLongitude doubleValue]);
            pin.title = activity.strActivityName;
            pin.subtitle = activity.strActivityCategoryName;
            
            [self.mapView addAnnotation:pin];
            
        }
        
        DayActivity *act = self.arrDayActivities[0];
        lat = [act.numActivityLatitude doubleValue];
        lon = [act.numActivityLongitude doubleValue];
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat,lon), MKCoordinateSpanMake(.02,.02)) animated:YES];
    }
    
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.animatesDrop = true;
    pin.canShowCallout = YES;
    return pin;
}




#pragma mark - collection Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrDayActivities.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayTrackCollectionViewCell *MCCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DCell" forIndexPath:indexPath];
    
    DayActivity *dayAct = self.arrDayActivities[indexPath.row];
    
    MCCell.lblName.text = dayAct.strActivityName;
    MCCell.imgLocation.image = [UIImage imageNamed:@"Thumb"];
    MCCell.btnSave.tag = indexPath.row;
    MCCell.btnShare.tag = indexPath.row;
    
    
    return MCCell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
//    return CGSizeMake(180, 215);
//}




#pragma mark - share Methods
- (IBAction)btnSave:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Activity Saved" message:@"Your activity has been added to your favorites" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)btnShare:(id)sender
{

    
    UIBarButtonItem *bbi = (UIBarButtonItem*)sender;
    DayActivity *dayAct = self.arrDayActivities[bbi.tag];

    UIActivityViewController *actVC = [[UIActivityViewController alloc] initWithActivityItems:@[dayAct.strActivityName] applicationActivities:nil];
    [self presentViewController:actVC animated:YES completion:nil];
    
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
