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
@property (strong, nonatomic) NSArray *someArray;




@end


UIScrollView *scrollView;
CGPoint firstTouchPoint;

//xd,yd destance between imge center and my touch center
float xd;
float yd;
int width = 125;
int height = 50;
CGFloat x = 0, y =0;
int xx=100, yy=200;


@implementation PreferencesView

- (IBAction)toMainMenu:(id)sender
{    //if user selects no preference set default list
   // if (_userPrefs.count == 0)
        
        
       if([_userPrefs objectForKey:@"1" ] == nil)
       {
        _someArray = [[NSArray alloc]initWithObjects:@"breakfast", nil];
        [_userPrefs  setValue:_someArray forKey:@"1"];
       }
    
    if([_userPrefs objectForKey:@"2" ] == nil)
    {
         _someArray = [[NSArray alloc]initWithObjects:@"jog", nil];
        [_userPrefs  setValue:_someArray forKey:@"2"];
    }
    
    if([_userPrefs objectForKey:@"3" ] == nil)
    {
        _someArray = [[NSArray alloc]initWithObjects:@"burger",nil];
        [_userPrefs  setValue:_someArray forKey:@"3"];
    }
    
    if([_userPrefs objectForKey:@"4" ] == nil)
    {

        _someArray = [[NSArray alloc]initWithObjects:@"bowling", nil];
        [_userPrefs  setValue:_someArray forKey:@"4"];
    }
    
    if([_userPrefs objectForKey:@"5" ] == nil)
    {
        _someArray = [[NSArray alloc]initWithObjects:@"steak", nil];
        [_userPrefs  setValue:_someArray forKey:@"5"];
    }
    
    if([_userPrefs objectForKey:@"6" ] == nil)

    {
        _someArray = [[NSArray alloc]initWithObjects:@"shows", nil];
        [_userPrefs  setValue:_someArray forKey:@"6"];
    }
    
    if([_userPrefs objectForKey:@"7" ] == nil)
    {
        _someArray = [[NSArray alloc]initWithObjects:@"cocktail", nil];
        [_userPrefs  setValue:_someArray forKey:@"7"];
    }
    
    
    if([_userPrefs objectForKey:@"8" ] == nil)
    {
       _someArray = [[NSArray alloc]initWithObjects:@"nightclub", nil];
        [_userPrefs  setValue:_someArray forKey:@"8"];
    }
    
    [self createPlist];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.gravity = [[UIGravityBehavior alloc]init];
    self.collision = [[UICollisionBehavior alloc] init];
    // [self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [self.collision setCollisionDelegate:self];

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
    
    [[self aButton]setUserInteractionEnabled:YES];
    
    [self setUpList];
    [self setUpScroll];
    
    
}

-(void)alertMe:(id)sender
{
    UIButton *bpressed = (UIButton*)sender;
    
//  [self.animator removeAllBehaviors];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_myScrollView];
    
    
   UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[bpressed]];
    dynamicItemBehavior.resistance = 50; // This makes the snapping SLOWER
    dynamicItemBehavior.allowsRotation = NO;
   
   
    [_collision addBoundaryWithIdentifier:@"bottom"
                                fromPoint:CGPointMake(0, _myScrollView.contentSize.height)
                                  toPoint:CGPointMake(_myScrollView.contentSize.width, _myScrollView.contentSize.height)];

    [_collision addBoundaryWithIdentifier:@"left"
                                fromPoint:CGPointMake(0, 0)
                                  toPoint:CGPointMake(0, _myScrollView.contentSize.height)];
    
    
    [_collision addBoundaryWithIdentifier:@"right"
                                fromPoint:CGPointMake(_myScrollView.contentSize.width, 0)
                                  toPoint:CGPointMake(_myScrollView.contentSize.width, _myScrollView.contentSize.height)];
    
    [_collision addBoundaryWithIdentifier:@"top"
                                fromPoint:CGPointMake(0, 0)
                                  toPoint:CGPointMake(_myScrollView.contentSize.width,0)];
    
    
    
    if ([_userPrefs  valueForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]] == nil)
    {
        NSMutableArray *firstarray = [NSMutableArray new];
        [firstarray addObject:bpressed.titleLabel.text];
        [_userPrefs  setValue:firstarray forKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
        [sender setBackgroundColor:[UIColor whiteColor]];
        NSLog(@"Added: %@,%ld", bpressed.titleLabel.text, (long)bpressed.tag );
    }
    else
    {
        //if tag exists and button is selected, unselect preference and remove from _userPrefs
        if ([[sender backgroundColor] isEqual:[UIColor whiteColor]])
        {
            [sender setBackgroundColor:[UIColor blackColor]];
            [_userPrefs removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
            NSLog(@"Removed: %@,%ld", bpressed.titleLabel.text, (long)bpressed.tag );
            
        }
        else
        {   //if tag exists and color is unselected, select preference and add to _userPrefs
            [sender setBackgroundColor:[UIColor whiteColor]];
            
            _tempArray = [_userPrefs valueForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
            [_tempArray addObject:bpressed.titleLabel.text];
            [_userPrefs  setValue:_tempArray forKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
            NSLog(@"Added: %@,%ld", bpressed.titleLabel.text, (long)bpressed.tag );
            
            
        }
    }
    

}



-(void)setUpScroll
{
   self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:_myScrollView];
   //[self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
    
    [_collision addBoundaryWithIdentifier:@"bottom"
                                fromPoint:CGPointMake(0, _myScrollView.contentSize.height)
                                  toPoint:CGPointMake(_myScrollView.contentSize.width, _myScrollView.contentSize.height)];
    
    [_collision addBoundaryWithIdentifier:@"left"
                                fromPoint:CGPointMake(0, 0)
                                  toPoint:CGPointMake(0, _myScrollView.contentSize.height)];

    
    [_collision addBoundaryWithIdentifier:@"right"
                                fromPoint:CGPointMake(_myScrollView.contentSize.width, 0)
                                  toPoint:CGPointMake(_myScrollView.contentSize.width, _myScrollView.contentSize.height)];
    
    
   [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    
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
            _aButton.layer.borderColor = [UIColor yellowColor].CGColor;
            [_aButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_aButton setBackgroundColor:[UIColor blackColor]];
            _aButton.titleLabel.font = [UIFont systemFontOfSize:16];
            
            
            [_myScrollView addSubview:_aButton];
            
            
            
           // self.gravity = [[UIGravityBehavior alloc]initWithItems:@[_aButton]];
           self.gravity.magnitude = .4;
          [self.gravity addItem:_aButton];
            
            
            //self.collision = [[UICollisionBehavior alloc]initWithItems:@[_aButton]];
            [self.collision addItem:_aButton];
            
            
            x += _aButton.frame.size.width;
            if ( x >= _myScrollView.contentSize.width - _aButton.frame.size.width)
            {
                x = 20;
               y -= _aButton.frame.size.height+30;
            
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
    
    
    [_myScrollView setContentSize:CGSizeMake(600, 800)];
    [self.view addSubview:scrollView];
    
    y = _myScrollView.contentSize.height;
    
    
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
        firstTouchPoint = [bTouch locationInView:[self aButton]];
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
