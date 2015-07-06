//
//  DayTrackCollectionViewCell.h
//  ITin
//
//  Created by Mac on 7/5/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayTrackCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShare;

@property (weak, nonatomic) NSString *strName;
@property (weak, nonatomic) NSString *strAddress;
@property (weak, nonatomic) UIImage *imgLoc;

@end
