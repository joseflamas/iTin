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

double lat = 0.0;
double lon = 0.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.arrDayActivities.count > 0)
    {
        [self prepareMap];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.arrDayActivities = nil;
}




#pragma mark - Map Methods
-(void)prepareMap
{

    if (self.mapView.annotations.count <= 0)
    {
        
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
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat,lon), MKCoordinateSpanMake(.08,.08)) animated:YES];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(zoom)
                                   userInfo:nil
                                    repeats:NO];
    

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.animatesDrop = true;
    pin.canShowCallout = YES;
    return pin;
}


-(void)zoom
{
     [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat,lon), MKCoordinateSpanMake(.055,.055)) animated:YES];
}


#pragma mark - collection Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrDayActivities.count > 0)
    {
        return self.arrDayActivities.count;
        
    } else {
        
        return 0;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayTrackCollectionViewCell *MCCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DCell" forIndexPath:indexPath];
    
    DayActivity *dayAct = self.arrDayActivities[indexPath.row];
    
    MCCell.lblName.text = dayAct.strActivityName;
    MCCell.btnSave.tag = indexPath.row;
    MCCell.btnShare.tag = indexPath.row;
    
    
    return MCCell;
}





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

    if(dayAct.strActivityName != nil )
    {
        UIActivityViewController *actVC = [[UIActivityViewController alloc] initWithActivityItems:@[dayAct.strActivityName] applicationActivities:nil];
        [self presentViewController:actVC animated:YES completion:nil];
    
    } else {
        
        UIActivityViewController *actVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Having fun! XD."] applicationActivities:nil];
        [self presentViewController:actVC animated:YES completion:nil];
    }
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
