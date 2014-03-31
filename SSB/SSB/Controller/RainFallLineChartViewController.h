//
//  RainFallLineChartViewController.h
//  SSB
//
//  Created by YTB on 14-3-24.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINavigationMenuView.h"
#import "ASIHTTPRequest.h"

@interface RainFallLineChartViewController : UIViewController<SINavigationMenuDelegate,ASIHTTPRequestDelegate>

@property(nonatomic,strong) NSString *locationId;
@property(nonatomic,strong) NSString *locationName;

@end
