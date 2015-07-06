//
//  PreferencesView.m
//  ITin
//
//  Created by Mac on 7/2/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "PreferencesView.h"
#import "WelcomeViewController.h"

@interface PreferencesView () <UIScrollViewDelegate,UICollisionBehaviorDelegate>
@property (nonatomic,strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic,strong) UIGravityBehavior *gravity, *gravity2;
@property (nonatomic,strong) UICollisionBehavior *collision;
@property (nonatomic,strong)  UISnapBehavior *snap;

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UIImageView *imgView2, *imgView3;

@property (strong, nonatomic) IBOutlet UIButton *myButton;
@property (nonatomic,strong) NSMutableArray *arrStuff, *tempArray;
//@property (nonatomic,strong) NSMutableDictionary *userPrefs;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property ( nonatomic, strong ) NSString *documentsPreferencesPath; 
@end

UIScrollView *scrollView;

@implementation PreferencesView
- (IBAction)toMainMenu:(id)sender
{

    WelcomeViewController *wv = [WelcomeViewController new];
   // [wv createPlist];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self setUpList];
    [self setUpScroll];

    
}

-(void)alertMe:(id)sender
{
    UIButton *bpressed = (UIButton*)sender;

    if ([_userPrefs objectForKey:[NSNumber numberWithLong:bpressed.tag]] == nil)
    {
        NSMutableArray *firstarray = [NSMutableArray new];
        [firstarray addObject:bpressed.titleLabel.text];
        [_userPrefs setObject:firstarray forKey:[NSNumber numberWithLong:bpressed.tag]];
    }
    else
    {
        
        _tempArray = [_userPrefs objectForKey:[NSNumber numberWithLong:bpressed.tag]];
        [_tempArray addObject:bpressed.titleLabel.text];
        [_userPrefs setObject:_tempArray forKey:[NSNumber numberWithLong:bpressed.tag]];
        
    }
        NSLog(@" %@,%ld", bpressed.titleLabel.text, (long)bpressed.tag );

}

-(void)setUpScroll
{
    
    
for(NSString *myKeyName in [_myPrefs allKeys])
    {
        for (NSArray *myPrefValues in _myPrefs[myKeyName])
       {

           
         UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(arc4random()%800,arc4random()%600,150,50)];
           
        [aButton addTarget:self action:@selector(alertMe:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTitle:[NSString stringWithFormat:@"%@",myPrefValues] forState:UIControlStateNormal];
        [aButton setTag:[myKeyName intValue]];
        [aButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
          [aButton setBackgroundColor:[UIColor blackColor]];
         aButton.titleLabel.font = [UIFont systemFontOfSize:14];
           
           [_myScrollView addSubview:aButton];
//           
//           self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//           
//           self.gravity = [[UIGravityBehavior alloc]initWithItems:@[aButton]];
//           self.gravity.magnitude =  1;
//           
//           self.collision = [[UICollisionBehavior alloc]initWithItems:@[aButton]];
//           [self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
//           [self.collision setCollisionDelegate:self];
//           
//           
//           
//          // [self.dynamicAnimator addBehavior:self.gravity];
//           [self.dynamicAnimator addBehavior:self.collision];

           
              
        }
    }
    
}

-(void)setUpList
{
    _arrStuff = [NSMutableArray new];
    _myPrefs = [NSMutableDictionary new];
    _userPrefs = [NSMutableDictionary new];
    _tempArray = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestList" ofType:@"plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *tempArray = [dict objectForKey:@"Breakfast"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:1]];
    
    tempArray = [dict objectForKey:@"Morning Activity"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:2]];
    
    
    tempArray = [dict objectForKey:@"Lunch"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:3]];
    
    tempArray = [dict objectForKey:@"Afternoon Activity"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:4]];
    
    tempArray = [dict objectForKey:@"Dinner"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:5]];
    
    
    tempArray = [dict objectForKey:@"Night Activity"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:6]];
    
    tempArray = [dict objectForKey:@"Snack"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:7]];
    
    tempArray = [dict objectForKey:@"Late Night Activity"];
    [_arrStuff addObjectsFromArray:tempArray];
    [_myPrefs setObject:tempArray forKey:[NSNumber numberWithInt:8]];
    
    
    [_myScrollView setContentSize:CGSizeMake(800, 1000)];
    [self.view addSubview:scrollView];
    

    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    UIGravityBehavior *theRightGravity = item == self.imgView ? self.gravity :self.gravity2;
    
    float ySign =self.gravity.gravityDirection.dy < 0 == 0 ? -1 : 1;
    float yMod = ySign * (arc4random()%100)/100;
    
    float xSign =self.gravity.gravityDirection.dy < 0 == 0 ? -1 : 1;
    float xMod = xSign * (arc4random()%100)/100;
    
    
    theRightGravity.gravityDirection = CGVectorMake(xMod, yMod);
}


@end
