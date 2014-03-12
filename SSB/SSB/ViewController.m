//
//  ViewController.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated
{
    MainViewController *main = [[MainViewController alloc] init];
//    [self presentViewController:main animated:YES completion:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
