//
//  SUIActivityIndicatorView.m
//  smartya
//
//  Created by YTB on 14-3-25.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "SUIActivityIndicatorView.h"

@interface SUIActivityIndicatorView()
{
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation SUIActivityIndicatorView

-(void)showWaitingInViewController:(UIViewController*)vc
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:vc.view.center];
    activityIndicator.backgroundColor = [UIColor grayColor];
    [activityIndicator setActivityIndicatorViewStyle:SUIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    [vc.view addSubview:activityIndicator];
}

-(void)hideWaiting
{
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

@end
