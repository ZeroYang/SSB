//
//  RadarView.h
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadarViewDelegate <NSObject>

@required
-(void)radarViewSweep;

-(void)radarViewStopSweep;

@end

@interface RadarView : UIView

@property (nonatomic, assign) id<RadarViewDelegate> delegate;

-(void)drawPoint:(CGPoint)point;

@end

