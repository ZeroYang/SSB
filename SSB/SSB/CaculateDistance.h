//
//  CaculateDistance.h
//  SSB
//
//  Created by YTB on 14-3-26.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculateDistance : NSObject

+(CGPoint)caculatePointwith:(double)sWeidu sJingdu:(double)sJingdu dWeidu:(double)dWeidu
                     dJingdu:(double)dJingdu rect:(CGRect)viewRect;
@end
