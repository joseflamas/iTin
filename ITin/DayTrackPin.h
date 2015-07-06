//
//  DayTrackPin.h
//  ITin
//
//  Created by Mac on 7/5/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface DayTrackPin : NSObject <MKAnnotation>

@property (nonatomic ) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
