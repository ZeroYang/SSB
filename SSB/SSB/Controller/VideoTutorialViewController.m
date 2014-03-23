//
//  VideoTutorialViewController.m
//  SSB
//
//  Created by YTB on 14-3-14.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "VideoTutorialViewController.h"

#define STATUS_BAR      20
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define NAV_BAR         44

#define SHANHONG_TOTAL_PAGE                 (12)
#define SHANHONG_DEFENSE_TOTAL_PAGE         (3)
#define SHANHONG_DEFENSE_NOTE_TOTAL_PAGE    (5)

@interface VideoTutorialViewController ()
{
    UIScrollView *containerScrollView;
}
@end

@implementation VideoTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"视频教程";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAV_BAR);
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"山洪灾害宣传"];
    [menu displayMenuInView:self.view];
    menu.items = @[@"山洪灾害宣传", @"山洪灾害防御常识", @"防洪抢险注意事项", @"视频宣传"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
    
    [self createContainerScrollView];

    [self shanHongPropaganda];
}

-(void) createContainerScrollView
{
    [containerScrollView removeFromSuperview];
    containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR - NAV_BAR)];
    containerScrollView.bounces = NO;
    [containerScrollView setPagingEnabled:YES];
    containerScrollView.showsHorizontalScrollIndicator = NO;
    containerScrollView.showsVerticalScrollIndicator = NO;
    containerScrollView.delegate = self;
    [self.view addSubview:containerScrollView];
}

//山洪灾害宣传
-(void)shanHongPropaganda
{
    [self createContainerScrollView];
    for (int i = 0; i < SHANHONG_TOTAL_PAGE; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"s1_%d.png", i + 1]]];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, containerScrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [containerScrollView addSubview:imageView];
    }
    [containerScrollView setContentSize:CGSizeMake(SHANHONG_TOTAL_PAGE * SCREEN_WIDTH,
                                                   SCREEN_HEIGHT)];
}
//山洪灾害防御常识
-(void)shanHongDefense
{
    [self createContainerScrollView];
    for (int i = 0; i < SHANHONG_DEFENSE_TOTAL_PAGE; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"s2_%d.png", i + 1]]];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, containerScrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [containerScrollView addSubview:imageView];
    }
    [containerScrollView setContentSize:CGSizeMake(SHANHONG_DEFENSE_TOTAL_PAGE * SCREEN_WIDTH,
                                                   SCREEN_HEIGHT)];
}

//山洪灾害防御常识
-(void)shanHongDefenseNote
{
    [self createContainerScrollView];
    for (int i = 0; i < SHANHONG_DEFENSE_NOTE_TOTAL_PAGE; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"s3_%d.png", i + 1]]];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, containerScrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [containerScrollView addSubview:imageView];
    }
    [containerScrollView setContentSize:CGSizeMake(SHANHONG_DEFENSE_NOTE_TOTAL_PAGE * SCREEN_WIDTH,
                                                   SCREEN_HEIGHT)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    SINavigationMenuView *menu = ((SINavigationMenuView*)self.navigationItem.titleView);
    menu.menuButton.title.text = [menu.items objectAtIndex:index];
    
    if (0 == index) {
        [self shanHongPropaganda];
    }
    
    if (1 == index) {
        [self shanHongDefense];
    }
    
    if (2 == index) {
        [self shanHongDefenseNote];
    }
    NSLog(@"did selected item at index %d", index);
}

@end
