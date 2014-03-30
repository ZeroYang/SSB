//
//  LocationHelper.h
//  SSB
//
//  Created by YTB on 14-3-30.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationHelperDelegate <NSObject>

@required
-(void)didLocation:(CLLocation *)location;

@optional
-(void)didFailLocation:(NSError *)error;

@end

@interface LocationHelper : NSObject

@property (nonatomic, assign) id<LocationHelperDelegate> delegate;

@end
