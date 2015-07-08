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
//uicollision properties
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravity, *gravity2;
@property (nonatomic,strong) UICollisionBehavior *collision;
@property (nonatomic,strong)  UISnapBehavior *snap;

@property(nonatomic,strong) UIImageView *imgView2, *imgView3;
@property(nonatomic,strong) UIButton *aButton;

@property (nonatomic,strong) NSArray *paths;
@property (nonatomic,strong) NSString *path,*documentsDirectory;
 @property (nonatomic,strong)NSFileManager *fileManager;
@property (nonatomic,strong)NSMutableDictionary *aDictionary, *data;

@property (strong, nonatomic) IBOutlet UIButton *myButton;
@property (nonatomic,strong) NSMutableArray *arrStuff, *tempArray;
//@property (nonatomic,strong) NSMutableDictionary *userPrefs;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property ( nonatomic, strong ) NSString *documentsPreferencesPath;

    


@end


UIScrollView *scrollView;
CGPoint firstTouchPoint;

//xd,yd destance between imge center and my touch center
float xd;
float yd;
int width = 150;
int height = 50;
CGFloat x = 20, y =150;


@implementation PreferencesView

- (IBAction)toMainMenu:(id)sender
{
   [self createPlist];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _aDictionary = [NSMutableDictionary dictionary];
   

    _paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [_paths objectAtIndex:0];
    _path = [self.documentsPreferencesPath stringByAppendingPathComponent:@"userPreferences.plist"];
    _fileManager = [NSFileManager defaultManager];
    
    if (![_fileManager fileExistsAtPath: _path]) {
        
        _path = [_documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"userPreferences.plist"] ];
    }
    
    if ([_fileManager fileExistsAtPath: _path]) {
        
        _data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    }
    else {
        // If the file doesn’t exist, create an empty dictionary
        _data = [[NSMutableDictionary alloc] init];
    }
    
  //  [[self aButton]setUserInteractionEnabled:YES];
    
  [self setUpList];
[self setUpScroll];

    
}

-(void)alertMe:(id)sender
{
    UIButton *bpressed = (UIButton*)sender;
    
    if ([_userPrefs  valueForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]] == nil)
    {
        NSMutableArray *firstarray = [NSMutableArray new];
        [firstarray addObject:bpressed.titleLabel.text];
        [_userPrefs  setValue:firstarray forKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
        [sender setBackgroundColor:[UIColor whiteColor]];
        
        
        
        
    }
    else
    {
        
        
        if ([_aButton.backgroundColor isEqual:[UIColor whiteColor]])
        {
            [sender setBackgroundColor:[UIColor lightGrayColor]];
            [_userPrefs removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
        }
        else
        {
            [sender setBackgroundColor:[UIColor whiteColor]];
            
            _tempArray = [_userPrefs valueForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
            [_tempArray addObject:bpressed.titleLabel.text];
            [_userPrefs  setValue:_tempArray forKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
        }
    }
    NSLog(@" %@,%ld", bpressed.titleLabel.text, (long)bpressed.tag );
    
}



-(void)setUpScroll
{
    
    
   // self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:_myScrollView];
   // self.gravity = [[UIGravityBehavior alloc]init];
    //            self.gravity.magnitude =  .009;
    for(NSString *myKeyName in [_myPrefs allKeys])
    {
        for (NSArray *myPrefValues in _myPrefs[myKeyName])
        {

           _aButton = [[UIButton alloc] initWithFrame:CGRectMake(x,y,width, height)];

    [_aButton addTarget:self action:@selector(alertMe:) forControlEvents:UIControlEventTouchUpInside];
    [_aButton setTitle:[NSString stringWithFormat:@"%@",myPrefValues] forState:UIControlStateNormal];
    [_aButton setTag:[myKeyName intValue]];

    _aButton.layer.cornerRadius = 10;
    _aButton.layer.borderWidth = 1;
    _aButton.layer.borderColor = [UIColor blueColor].CGColor;
    [_aButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_aButton setBackgroundColor:[UIColor blackColor]];
    _aButton.titleLabel.font = [UIFont systemFontOfSize:14];

    
    [_myScrollView addSubview:_aButton];
            
//            CGPoint rightEdge = CGPointMake(_aButton.frame.origin.x +
//                                            _aButton.frame.size.width,_aButton.frame.origin.y);
//        [_collision addBoundaryWithIdentifier:@"aButton"
//                                       fromPoint:_aButton.frame.origin
//                                          toPoint:rightEdge];
//            
//            
//            self.gravity = [[UIGravityBehavior alloc]initWithItems:@[_aButton]];
//            self.gravity.magnitude =  0;
//
//            
//            self.collision = [[UICollisionBehavior alloc]initWithItems:@[_aButton]];
//            [self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
//            [self.collision setCollisionDelegate:self];
//            
            
            
      //  [self.animator addBehavior:self.gravity];
     //   [self.animator addBehavior:self.collision];
            x += _aButton.frame.size.width+30;
            if ( x >= _myScrollView.contentSize.width - _aButton.frame.size.width)
            {
                x = 20;
                y += _aButton.frame.size.height+30;
            }
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


-(void)createPlist
{
   UserPreferences *up = [UserPreferences sharedManager];
    up.userPrefs = [NSMutableDictionary dictionaryWithDictionary:_userPrefs];
    
    //To insert the data into the plist
    [_data setObject:up.userName forKey:@"UserName"];
    [_data writeToFile:_path atomically:YES];
    
    [_data setObject:up.userAge forKey:@"UserAge"];
    [_data writeToFile:_path atomically:YES];
    
    [_data setObject:up.userGender forKey:@"UserGender"];
    [_data writeToFile:_path atomically:YES];
    
    [_data setObject:up.userLattitude forKey:@"UserLat"];
    [_data writeToFile:_path atomically:YES];
    
    [_data setObject:up.userLongitude forKey:@"UserLong"];
    [_data writeToFile:_path atomically:YES];
    
    
    
    [_data setObject:up.userPrefs forKey:@"UserPrefs"];
    [_data writeToFile:_path atomically:YES];

    
    
    NSLog(@"User Name: %@, Age: %@ Gender: %@ Lat: %@ Long: %@",up.userName, up.userAge,up.userGender,up.userLattitude, up.userLongitude);
    NSLog(@"Preferences:%@", _userPrefs );
    
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* bTouch = [touches anyObject];
    if ([bTouch.view isEqual:[self aButton]]) {
        firstTouchPoint = [bTouch locationInView:[self myScrollView]];
        xd = firstTouchPoint.x - [[bTouch view]center].x;
        yd = firstTouchPoint.y - [[bTouch view]center].y;
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* mTouch = [touches anyObject];
    if (mTouch.view == [self aButton]) {
        CGPoint cp = [mTouch locationInView:[self myScrollView]];
        [[mTouch view]setCenter:CGPointMake(cp.x-xd, cp.y-yd)];
    }
}

@end
