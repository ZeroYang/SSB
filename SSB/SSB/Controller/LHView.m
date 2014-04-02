//
//  LHView.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "LHView.h"
#import "MenuItem.h"
#import "MenuItemView.h"

#define MENUITEMVIEW_WIDTH      90
#define MENUITEMVIEW_HEIGHT     90
#define SPACE_WIDTH             30/4//间距

@interface LHView()<MenuItemViewDelegate>
{
    NSMutableArray *items;
    UIView* contentView;
}
@end

@implementation LHView

@synthesize viewControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, frame.size.height)];
        contentView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:contentView];
        
        items = [[NSMutableArray alloc] init];
        //降雨量
        MenuItem *item1 = [[MenuItem alloc] init];
        item1.icon = @"rainfall";
        item1.name = @"降雨量";
        [items addObject:item1];
        //水位
        MenuItem *item2 = [[MenuItem alloc] init];
        item2.icon = @"waterlevel";
        item2.name = @"水位";
        [items addObject:item2];
        //视频教程
        MenuItem *item3 = [[MenuItem alloc] init];
        item3.icon = @"movie";
        item3.name = @"视频教程";
        [items addObject:item3];
    }
    return self;
}

- (void)initSpringBoard
{
    
    for (int i = 0; i < [items count]; i++) {
        
        MenuItemView *view =  [[MenuItemView alloc] initWithFrame:CGRectMake(i%3*(MENUITEMVIEW_WIDTH+SPACE_WIDTH)+SPACE_WIDTH, i/3*(MENUITEMVIEW_HEIGHT+2*SPACE_WIDTH), MENUITEMVIEW_WIDTH, MENUITEMVIEW_HEIGHT)];
        [contentView addSubview:view];
        view.delegate = self;

        MenuItem *item = [items objectAtIndex:i];
        item.viewControl = viewControl;
        [view initWith:item];
    }
    
    
}

-(void)didClickMenu:(MenuItemView*)menu
{
    MenuItem *item = menu.item;
    //@"http://61.184.80.242:8081/
    if ([item.name isEqualToString:@"视频教程"]) {
        
    }
    if ([item.name isEqualToString:@"降雨量"]) {
        
    }
    if ([item.name isEqualToString:@"水位"]) {
        
    }
    
    NSURL *url = [NSURL URLWithString:@"http://61.184.80.242:8081/"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
