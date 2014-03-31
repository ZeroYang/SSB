//
//  CaculateDistance.h
//  SSB
//
//  Created by YTB on 14-3-26.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPoint : NSObject

@property(nonatomic,assign)double x;
@property(nonatomic,assign)double y;
@property(nonatomic,assign)double distance;


-(id)initWithX:(CGFloat)dx Y:(CGFloat)dy distance:(CGFloat)ddistance;

@end

@interface Location : NSObject
@property(nonatomic,strong)NSString* locationId;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;

-(id)initWithLatitude:(double)latitude Longitude:(double)longitude;

@end

@interface CaculateDistance : NSObject
+(float)caculateDistancewith:(double)sWeidu sJingdu:(double)sJingdu dWeidu:(double)dWeidu
                     dJingdu:(double)dJingdu;

+(CGPoint)caculatePointwith:(double)sWeidu sJingdu:(double)sJingdu dWeidu:(double)dWeidu
                     dJingdu:(double)dJingdu rect:(CGRect)viewRect;

+(NSArray*)shuikuLocations;

+(Location*)getLocationByLocationId:(NSString*)locationId;

@end
