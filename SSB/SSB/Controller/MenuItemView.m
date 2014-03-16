//
//  MenuItemView.m
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "MenuItemView.h"
#import "AlarmlViewController.h"
#import "ReferenceViewController.h"
#import "VideoTutorialViewController.h"
#import "RainFallViewController.h"
#import "WaterLevelViewController.h"
#import "WeatherViewController.h"
#import "PhotoViewController.h"

#define  FONT_SIZE          14.0f

@interface MenuItemView ()

@property(nonatomic, strong)MenuItem *item;

@end

@implementation MenuItemView
@synthesize item;
@synthesize iconBtn;
@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) initWith:(MenuItem*)menuitem
{
    self.item = menuitem;
    int MaxWidth = self.frame.size.width;
    UIImage *icon = [UIImage  imageNamed:item.icon];
    iconBtn = [[UIButton alloc] init];
    [iconBtn setFrame:CGRectMake((MaxWidth - icon.size.width)/2, 5, icon.size.width, icon.size.height)];
    [iconBtn setImage:icon forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(clickIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconBtn];
    iconBtn.backgroundColor = [UIColor clearColor];
    
    int MaxLabelWidth = 150;
    int labelHeight = 30;
    
    float labelWidth =  [item.name sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
      constrainedToSize:CGSizeMake(MaxLabelWidth, labelHeight)
          lineBreakMode:NSLineBreakByClipping].width;
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake((MaxWidth - labelWidth)/2, icon.size.height, labelWidth, labelHeight)];
    [self addSubview:textLabel];
    textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = item.name;
    textLabel.backgroundColor = [UIColor clearColor];
}

-(void)clickIconBtn:(id)sender
{
    if ([item.name isEqualToString:@"预警雷达"]) {
        AlarmlViewController *alarm = [[AlarmlViewController alloc] init];
        [item.viewControl.navigationController pushViewController:alarm animated:NO];
    }
    if ([item.name isEqualToString:@"相关链接"]) {
        ReferenceViewController *reference = [[ReferenceViewController alloc] init];
        [item.viewControl.navigationController pushViewController:reference animated:NO];
    }
    if ([item.name isEqualToString:@"视频教程"]) {
        VideoTutorialViewController *tutorial = [[VideoTutorialViewController alloc] init];
        [item.viewControl.navigationController pushViewController:tutorial animated:NO];
    }
    if ([item.name isEqualToString:@"降雨量"]) {
        RainFallViewController *rainfall = [[RainFallViewController alloc] init];
        [item.viewControl.navigationController pushViewController:rainfall animated:NO];
    }
    if ([item.name isEqualToString:@"水位"]) {
        WaterLevelViewController *warterlevel = [[WaterLevelViewController alloc] init];
        [item.viewControl.navigationController pushViewController:warterlevel animated:NO];
    }
    if ([item.name isEqualToString:@"天气预报"]) {
        WeatherViewController *weather= [[WeatherViewController alloc] init];
        [item.viewControl.navigationController pushViewController:weather animated:NO];
    }
    if ([item.name isEqualToString:@"照片"]) {
        PhotoViewController *photo= [[PhotoViewController alloc] init];
        [item.viewControl.navigationController pushViewController:photo animated:NO];
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
