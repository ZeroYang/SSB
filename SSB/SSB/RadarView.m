//
//  RadarView.m
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "RadarView.h"

@implementation RadarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float rectWidth = rect.size.width;
    float rectHeight = rect.size.height;
    
    //画线
    CGPoint center = CGPointMake(rectWidth/2, rectHeight/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextMoveToPoint(context, rectWidth/2, center.y - rectWidth/2 - 10);
    CGContextAddLineToPoint(context, rectWidth/2, center.y + rectWidth/2 + 10);
    CGContextMoveToPoint(context, 0, rectHeight/2);
    CGContextAddLineToPoint(context, rectWidth, rectHeight/2);
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    CGContextFillPath(context);
    
    //画圆
    float PI = 3.14;
    CGContextRef con = UIGraphicsGetCurrentContext();

    /*画圆*/

    //边框圆
    CGContextSetRGBStrokeColor(con,1,1,1,1.0);//画笔线的颜色
    float radius = (rectWidth/12)-2;
    CGContextSetLineWidth(con, 1.0);//线的宽度
    for (int i =0; i<6; i++) {
        CGContextAddArc(con, center.x, center.y, (i+1)*radius, 0, 2*PI, 0); //添加一个圆
    }

    CGContextStrokePath(con);
    UIColor*aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetBlendMode(con,kCGBlendModeScreen);
    //填充圆，无边框
    CGContextAddArc(con, center.x, center.y, 6*radius, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(con, kCGPathEOFillStroke);//绘制边框加填充
    CGContextStrokePath(con);
    CGContextFillPath(con);

//    先用CGContextStrokePath来描线,即形状
//    后用CGContextFillPath来填充形状内的颜色.

}


@end
