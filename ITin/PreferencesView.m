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
@property (nonatomic,strong) NSArray *arrStuff;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@end

UIScrollView *scrollView;

@implementation PreferencesView

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestList" ofType:@"plist"]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestList" ofType:@"plist"];
    
    self.arrStuff = [NSArray arrayWithContentsOfFile:path];
    [NSArray arrayWithContentsOfFile:path];
    
    
    
    // Load the file content and read the data into arrays
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
  //  tableData = [dict objectForKey:@"RecipeName"];
    
    _arrStuff = @[@"Bike",@"Bed and Breakfast",@"Running",@"Beer",@"Nightclubs",@"Brunch",@"Fribee",@"Bars",@"Movies",@"Shopping"];
    
    
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
    
    for (int i=0; i < _arrStuff.count; i++)
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
