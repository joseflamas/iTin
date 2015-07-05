//
//  PreferencesView.m
//  ITin
//
//  Created by Mac on 7/2/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "PreferencesView.h"

@interface PreferencesView () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *myButton;
@property (nonatomic,strong) NSMutableArray *arrStuff;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@end

UIScrollView *scrollView;

@implementation PreferencesView

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrStuff = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestList" ofType:@"plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  
    NSArray *tempArray = [[dict objectForKey:@"Preferences"]objectForKey:@"Breakfast"];
  //  [_arrStuff addObject:tempArray];

    _arrStuff = [dict objectForKey:@"Preferences"];//objectForKey:@"Morning Activity"];
//   _arrStuff = [[dict objectForKey:@"Preferences"]objectForKey:@"Lunch"];
//    _arrStuff = [[dict objectForKey:@"Preferences"]objectForKey:@"Afternoon Activity"];
//    _arrStuff = [[dict objectForKey:@"Preferences"]objectForKey:@"Dinner"];
//    _arrStuff = [[dict objectForKey:@"Preferences"]objectForKey:@"Night Activity"];
//    _arrStuff = [[dict objectForKey:@"Preferences"]objectForKey:@"Snack"];
//    _arrStuff = [[dict objectForKey:@"Preferences"]objectForKey:@"Late Night Activity"];
    
    
//_arrStuff = @[@"Bike",@"Bed and Breakfast",@"Running",@"Beer",@"Nightclubs",@"Brunch",@"Fribee",@"Bars",@"Movies",@"Shopping"];
    
    
  //  _myScrollView.delegate = self;
    
   // scrollView.contentSize = CGSizeMake(800,800);
    [_myScrollView setContentSize:CGSizeMake(800, 1000)];
    [self.view addSubview:scrollView];
    
    
                         
    [self setUpScroll];

    
}

-(void)alertMe:(id)sender
{
    UIButton *bpressed = (UIButton*)sender;
    
    NSLog(@" %@", bpressed.titleLabel.text);
}

-(void)setUpScroll{
    
    
    bool atEnd = NO;
    int y = 0, x=0;
    
    for (int i=0; i < _arrStuff.count ; i++)
    {
        NSString *preferenceText = _arrStuff[i];
     
        UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 150, 50)];
        [aButton addTarget:self action:@selector(alertMe:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTitle:[NSString stringWithFormat:@"%@",preferenceText] forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        aButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_myScrollView addSubview:aButton];
        x += 100;
    
            if (x>=300)
            {
                atEnd = YES;
                x = 0;
                y += 30;
            }
            
    }
    
    [scrollView setContentOffset:CGPointMake(x, y) animated:YES];

}




@end
