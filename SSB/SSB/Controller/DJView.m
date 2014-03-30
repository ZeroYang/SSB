//
//  DJView.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "DJView.h"
#import "MenuItem.h"
#import "MenuItemView.h"

#define MENUITEMVIEW_WIDTH      90
#define MENUITEMVIEW_HEIGHT     90
#define SPACE_WIDTH             50/4//间距

@interface DJView()
{
    NSMutableArray *items;
}
@end

@implementation DJView

@synthesize viewControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
        //照片
        MenuItem *item3 = [[MenuItem alloc] init];
        item3.icon = @"picture";
        item3.name = @"照片";
        [items addObject:item3];
        //预警雷达
        MenuItem *item4 = [[MenuItem alloc] init];
        item4.icon = @"radar";
        item4.name = @"预警雷达";
        [items addObject:item4];
        //天气预报
        MenuItem *item5 = [[MenuItem alloc] init];
        item5.icon = @"weather";
        item5.name = @"天气预报";
        [items addObject:item5];
        //视频教程
        MenuItem *item6 = [[MenuItem alloc] init];
        item6.icon = @"movie";
        item6.name = @"视频教程";
        [items addObject:item6];
        //相关链接
        MenuItem *item7 = [[MenuItem alloc] init];
        item7.icon = @"tabel";
        item7.name = @"相关链接";
        [items addObject:item7];
        
    }
    return self;
}

- (void)initSpringBoard
{

    for (int i = 0; i < [items count]; i++) {

        MenuItemView *view =  [[MenuItemView alloc] initWithFrame:CGRectMake(i%3*(MENUITEMVIEW_WIDTH+SPACE_WIDTH)+SPACE_WIDTH, i/3*(MENUITEMVIEW_HEIGHT+SPACE_WIDTH), MENUITEMVIEW_WIDTH, MENUITEMVIEW_HEIGHT)];
        [self addSubview:view];
        
        MenuItem *item = [items objectAtIndex:i];
        item.viewControl = viewControl;
        [view initWith:item];
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
