//
//  SUIActivityIndicatorView.h
//  SSB
//
//  Created by YTB on 14-3-25.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUIActivityIndicatorView : NSObject

-(void)showWaitingInViewController:(UIViewController*)vc;
-(void)hideWaiting;

@end
