//
//  CaculateDistance.h
//  SSB
//
//  Created by YTB on 14-3-26.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property(nonatomic,strong)NSString* locationId;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;

-(id)initWithLatitude:(double)latitude Longitude:(double)longitude;

@end

@interface CaculateDistance : NSObject

+(CGPoint)caculatePointwith:(double)sWeidu sJingdu:(double)sJingdu dWeidu:(double)dWeidu
                     dJingdu:(double)dJingdu rect:(CGRect)viewRect;

+(NSArray*)shuikuLocations;

@end
