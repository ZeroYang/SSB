//
//  AlarmlDetailViewController.h
//  SSB
//
//  Created by YTB on 14-3-29.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSpreadViewClasses.h"
@interface AlarmlDetailViewController : UIViewController<MDSpreadViewDataSource, MDSpreadViewDelegate>
{
    MDSpreadView *spreadView;
}

@property(nonatomic,strong)NSString *alarmData;
@property(nonatomic,strong)NSArray *alarmPoints;

@end
