//
//  LocationHelper.m
//  SSB
//
//  Created by YTB on 14-3-30.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "LocationHelper.h"

@interface LocationHelper ()<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager* locationManager;

@end

@implementation LocationHelper
@synthesize delegate;

-(void)startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    [self.delegate didLocation:newLocation];
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"State"]);
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    NSLog(@"定位 失败");
    [self.delegate didFailLocation:error];
}

@end
