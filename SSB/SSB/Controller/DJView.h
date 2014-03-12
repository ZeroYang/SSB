//
//  DJView.h
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpringBoard.h"

@interface DJView : UIView

@property (nonatomic,weak) UIViewController *viewControl;
@property (nonatomic,strong) SpringBoard *spboard;

- (void)initSpringBoard;

@end
