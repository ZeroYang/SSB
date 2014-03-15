//
//  RadarView.m
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "RadarView.h"

#define SWEEP_BTN_HEIGHT        (40)

//计算弧度
static inline float radians(double degrees) {
    return degrees * M_PI / 180;
    
}

@interface RadarView ()
{
    CAShapeLayer *shaplayer;
    UIButton *sweepBtn;
    BOOL isSweep;
}
@end


@implementation RadarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        sweepBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - SWEEP_BTN_HEIGHT, frame.size.width, SWEEP_BTN_HEIGHT)];
        [self addSubview:sweepBtn];
        
        [sweepBtn addTarget:self action:@selector(clicksweepBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sweepBtn setTitle:@"扫描" forState:UIControlStateNormal];
        sweepBtn.backgroundColor = [UIColor grayColor];
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
    CGContextRef con = UIGraphicsGetCurrentContext();

    /*画圆*/

    //边框圆
    CGContextSetRGBStrokeColor(con,1,1,1,1.0);//画笔线的颜色
    float radius = (rectWidth/12)-2;
    CGContextSetLineWidth(con, 1.0);//线的宽度
    for (int i =0; i<6; i++) {
        CGContextAddArc(con, center.x, center.y, (i+1)*radius, 0, 2*M_PI, 0); //添加一个圆
    }

    CGContextStrokePath(con);
    UIColor*aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetBlendMode(con,kCGBlendModeScreen);
    //填充圆，无边框
    CGContextAddArc(con, center.x, center.y, 6*radius, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(con, kCGPathEOFillStroke);//绘制边框加填充
    CGContextStrokePath(con);
    CGContextFillPath(con);

//    先用CGContextStrokePath来描线,即形状
//    后用CGContextFillPath来填充形状内的颜色.

}

-(void)clicksweepBtn:(id)sender
{
    isSweep = !isSweep;
    if (isSweep) {
        [self sweep];
        [sweepBtn setTitle:@"停止扫描" forState:UIControlStateNormal];
    }
    else
    {
        [self stopSweep];
        [sweepBtn setTitle:@"扫描" forState:UIControlStateNormal];
    }
}

-(void)sweep
{
    
    
    CGRect rect=self.frame;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    float radius = (rect.size.width/12 - 2);
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:center];
    [path1 addArcWithCenter:center radius:6*radius startAngle:radians(0) endAngle:radians(10) clockwise:YES];
    
    shaplayer = [CAShapeLayer layer];
    //UIBezierPath 画图的图形中心点为啥存在偏移
    [shaplayer setFrame:CGRectOffset(self.frame, -8, -4)];
    [shaplayer setPath:path1.CGPath];
    [shaplayer setFillColor:[UIColor yellowColor].CGColor];
    [shaplayer setZPosition:self.center.x];
    [self.layer addSublayer:shaplayer];
    [self drawLineAnimation:shaplayer];
    
//    UIBezierPath *path=[UIBezierPath bezierPath];
//    [path addArcWithCenter:CGPointMake(center.x,center.y) radius:100 startAngle:radians(0) endAngle:radians(30) clockwise:NO];
//    
//    arcLayer=[CAShapeLayer layer];
//    arcLayer.path=path.CGPath;//46,169,230
//    arcLayer.fillColor=[UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
//    arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:0.7].CGColor;
//    arcLayer.lineWidth=3;
//    arcLayer.frame=self.frame;
//    [self.layer addSublayer:arcLayer];
    //[self drawLineAnimation:arcLayer];
    
    
}
-(void)drawLineAnimation:(CALayer*)layer
{
//    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    bas.duration=1;
//    bas.delegate=self;
//    bas.fromValue=[NSNumber numberWithInteger:0];
//    bas.toValue=[NSNumber numberWithInteger:1];
//    bas.repeatCount = NSIntegerMax;
//    [layer addAnimation:bas forKey:@"key"];
    
    CABasicAnimation *a2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	a2.fromValue = [NSNumber numberWithFloat:0.0];
	a2.toValue = [NSNumber numberWithFloat:M_PI * 2];
	a2.repeatCount = NSUIntegerMax;
	a2.duration = 2.0;
	[layer addAnimation:a2 forKey:@"key"];

}

-(void)stopSweep
{
    [shaplayer removeAnimationForKey:@"key"];
}

@end
