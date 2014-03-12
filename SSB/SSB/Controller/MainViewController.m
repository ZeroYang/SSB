//
//  MainViewController.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "MainViewController.h"
#import "SVTopScrollView.h"
#import "SVRootScrollView.h"
#import "SVGloble.h"
#import "DJView.h"
#import "GSView.h"
#import "LHView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"丹江口市防汛";
    }
    return self;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    //[self.navigationController setNavigationBarHidden:YES];
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
//        
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [SVGloble shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
    [SVGloble shareInstance].globleHeight = screenRect.size.height-20;  //屏幕高度（有顶栏）
    [SVGloble shareInstance].globleAllHeight = screenRect.size.height;  //屏幕高度（无顶栏）
    
    SVTopScrollView *topScrollView = [SVTopScrollView shareInstance];
    SVRootScrollView *rootScrollView = [SVRootScrollView shareInstance];
    
    topScrollView.nameArray = @[@"全市山洪灾害监测平台",@"官山水库大坝监测平台",@"浪河水库大坝监测平台"];
    rootScrollView.viewNameArray = @[@"全市山洪灾害监测平台",@"官山水库大坝监测平台",@"浪河水库大坝监测平台"];
    
    [self.view addSubview:topScrollView];
    [self.view addSubview:rootScrollView];
    
    [topScrollView initWithNameButtons];
    NSMutableArray *views = [[NSMutableArray alloc] init];
    UIView *djView = [[DJView alloc] initWithFrame:CGRectMake(0, 0, 320, screenRect.size.height-20)];
    [views addObject:djView];
    UIView *gsView = [[GSView alloc] initWithFrame:CGRectMake(0, 0, 320, screenRect.size.height-20)];
    [views addObject:gsView];
    UIView *lhView = [[LHView alloc] initWithFrame:CGRectMake(0, 0, 320, screenRect.size.height-20)];
    [views addObject:lhView];
    
    [rootScrollView initWithViews:views];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
