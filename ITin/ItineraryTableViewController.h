//
//  ItineraryTableViewController.h
//  ITin
//
//  Created by Mac on 7/1/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ItineraryTableViewControllerDelegate <NSObject>

@optional
-(void)suggestionsAdquired:(NSString*)key withObject:(NSArray *)arrSugestions;

@end


@interface ItineraryTableViewController : UITableViewController <ItineraryTableViewControllerDelegate>

@property (weak, nonatomic) id <ItineraryTableViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *strTypeofDay;


@end
