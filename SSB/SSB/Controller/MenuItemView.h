//
//  MenuItemView.h
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuItemView : UIView

@property(nonatomic, strong)UIButton *iconBtn;
@property(nonatomic, strong)UILabel *textLabel;

-(void) initWith:(MenuItem*)item;

@end
