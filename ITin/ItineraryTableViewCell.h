//
//  ItineraryTableViewCell.h
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) NSNumber *partOftheDay;
@property (weak, nonatomic) NSNumber *currentSelection;


@end
