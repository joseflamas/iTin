//
//  DayTrackViewController.h
//  ITin
//
//  Created by Mac on 7/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DayTrackViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property (strong, nonatomic) NSArray *arrDayActivities;


@end
