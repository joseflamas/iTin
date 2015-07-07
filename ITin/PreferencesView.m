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
        
        
    }
    else
    {
        
        _tempArray = [_userPrefs valueForKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
        [_tempArray addObject:bpressed.titleLabel.text];
        [_userPrefs  setValue:_tempArray forKey:[NSString stringWithFormat:@"%ld",(long)bpressed.tag]];
    }
    NSLog(@" %@,%ld", bpressed.titleLabel.text, (long)bpressed.tag );
    
}



-(void)setUpScroll
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:_myScrollView];
    for(NSString *myKeyName in [_myPrefs allKeys])
    {
        for (NSArray *myPrefValues in _myPrefs[myKeyName])
        {

            UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(arc4random()%700, arc4random()%500, 150, 50)];

    [aButton addTarget:self action:@selector(alertMe:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setTitle:[NSString stringWithFormat:@"%@",myPrefValues] forState:UIControlStateNormal];
    [aButton setTag:[myKeyName intValue]];

    
    [aButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor blackColor]];
    aButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_myScrollView addSubview:aButton];
            
            
  self.imgView = [[UIImageView alloc] initWithFrame:aButton.frame];
            // [_imgView setAlpha:0];
            
            
            [aButton addSubview:self.imgView];
            
            
            
            self.gravity = [[UIGravityBehavior alloc]initWithItems:@[aButton]];
            self.gravity.magnitude =  .009;
        
            
            self.collision = [[UICollisionBehavior alloc]initWithItems:@[aButton]];
            [self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
            [self.collision setCollisionDelegate:self];
            
            
            
            //[self.animator addBehavior:self.gravity];
            [self.animator addBehavior:self.collision];
       
        }
        
        

    }

    
    }


    

//
//         UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(arc4random()%800,arc4random()%600,150,50)];
//           
//        [aButton addTarget:self action:@selector(alertMe:) forControlEvents:UIControlEventTouchUpInside];
//        [aButton setTitle:[NSString stringWithFormat:@"%@",myPrefValues] forState:UIControlStateNormal];
//        [aButton setTag:[myKeyName intValue]];
//        [aButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
//          [aButton setBackgroundColor:[UIColor blackColor]];
//         aButton.titleLabel.font = [UIFont systemFontOfSize:14];
//           
//           [_myScrollView addSubview:aButton];
//           
//           _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//           _gravity = [[UIGravityBehavior alloc]initWithItems:@[aButton]];
//           
//              
//        }
//        
//    }
    
    
//}

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

-(void)createPlist
{
   
    
//    NSMutableDictionary *data;
//    
//    if ([_fileManager fileExistsAtPath: _path]) {
//        
//        data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
//    }
//    else {
//        // If the file doesn’t exist, create an empty dictionary
//        data = [[NSMutableDictionary alloc] init];
//    }
    
    
    UserPreferences *up = [UserPreferences sharedManager];
    up.userPrefs = _userPrefs;
    
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


@end
