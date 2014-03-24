//
//  WaterLevelLineChartViewController.h
//  SSB
//
//  Created by YTB on 14-3-24.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINavigationMenuView.h"
#import "ASIHTTPRequest.h"

@interface WaterLevelLineChartViewController : UIViewController<SINavigationMenuDelegate,ASIHTTPRequestDelegate>

@property(nonatomic,strong) NSString *locationId;

@end
