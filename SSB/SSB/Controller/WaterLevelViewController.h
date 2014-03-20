//
//  WaterLevelViewController.h
//  SSB
//
//  Created by YTB on 14-3-14.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MDSpreadViewClasses.h"
@interface WaterLevelViewController : UIViewController <ASIHTTPRequestDelegate, MDSpreadViewDataSource, MDSpreadViewDelegate>
{
    MDSpreadView *spreadView;
}

@end
