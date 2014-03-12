//
//  DJView.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "DJView.h"

@implementation DJView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 50)];
        text.text = @"全市山洪灾害监测平台";
        [self addSubview:text];
    }
    return self;
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
