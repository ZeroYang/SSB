//
//  MenuItemView.h
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@class MenuItemView;
@protocol MenuItemViewDelegate <NSObject>

-(void)didClickMenu:(MenuItemView*)menu;

@end

@interface MenuItemView : UIView

@property (nonatomic, assign) id<MenuItemViewDelegate> delegate;

@property(nonatomic, strong)MenuItem *item;
@property(nonatomic, strong)UIButton *iconBtn;
@property(nonatomic, strong)UILabel *textLabel;

-(void) initWith:(MenuItem*)menuitem;

@end
