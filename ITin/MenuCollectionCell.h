//
//  MenuCollectionCell.h
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCollectionCell : UICollectionViewCell


//The collection view only holds a button.
@property (weak, nonatomic) IBOutlet UIImageView *imgMCCell;
@property ( nonatomic, weak ) IBOutlet UIButton *btnMCCell;


@end
