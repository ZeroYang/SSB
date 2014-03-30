//
//  CaculateDistance.cpp
//  SSB
//
//  Created by YTB on 14-3-26.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CaculateDistance.h"

@implementation CPoint

@synthesize x,y;

-(id)initWithX:(CGFloat)dx Y:(CGFloat)dy
{
    self = [super init];
    if (self) {
        x = dx;
        y = dy;
    }
    return self;
}

@end


@implementation Location
@synthesize latitude,longitude,locationId;

-(id)initWithLatitude:(double)lat Longitude:(double)longt
{
    self = [super init];
    if (self) {
        longitude = longt;
        latitude = lat;
    }
    return self;
}

@end

#define EARTH_RADIUS 6378.137

float getCircleRadius(CGRect viewRect, float x, float y) {
    if ((x - viewRect.origin.x) > (y - viewRect.origin.y))
        return (y - viewRect.origin.y) * 0.95f;
    return (x - viewRect.origin.x) * 0.95f;
}

double rad(double d) {
    return d * M_PI / 180.0;
}

double getSin(double sWeidu, double sJingdu, double dWeidu,
              double dJingdu) {
    return abs(sWeidu - dWeidu) / pow(pow(sWeidu - dWeidu, 2)+pow(sJingdu - dJingdu, 2), 0.5);
}


double getCos(double sWeidu, double sJingdu, double dWeidu,
              double dJingdu) {
    return abs(sJingdu - dJingdu) / pow( pow(sWeidu - dWeidu, 2)+pow(sJingdu - dJingdu, 2), 0.5);
}

double getDistance(double sWeidu, double sJingdu,
                   double dWeidu, double dJingdu) {
    double radLat1 = rad(sWeidu);
    double radLat2 = rad(dWeidu);
    double a = radLat1 - radLat2;
    double b = rad(sJingdu) - rad(dJingdu);
    
    double s = 2 * asin(pow(pow(sin(a / 2), 2) + cos(radLat1)
                            * cos(radLat2) * pow(sin(b / 2), 2),
                            0.5));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    return s;
}

CGPoint caculate(double sWeidu, double sJingdu, double dWeidu,
                             double dJingdu, CGRect viewRect) {
    
    float x = (float) (viewRect.origin.x + viewRect.origin.x+viewRect.size.width) / 2.0f;
    float y = (float) (viewRect.origin.y+viewRect.size.height * 0.5f);
    float radius = getCircleRadius(viewRect, x, y);
    if (getDistance(sWeidu, sJingdu, dWeidu, dJingdu) <= 50) {
        CGPoint p = CGPointZero;
        double pDistance = (getDistance(sWeidu, sJingdu, dWeidu, dJingdu) / 50)
        * radius;
        int px, py;
        if (dJingdu >= sJingdu)
            px = (int) (x + (pDistance)
						* getCos(sWeidu, sJingdu, dWeidu, dJingdu));
        else
            px = (int) (x - (pDistance)
						* getCos(sWeidu, sJingdu, dWeidu, dJingdu));
        if (dWeidu >= sWeidu)
            py = (int) (y - (pDistance)
						* getSin(sWeidu, sJingdu, dWeidu, dJingdu));
        else
            py = (int) (y + (pDistance)
						* getSin(sWeidu, sJingdu, dWeidu, dJingdu));
        CGPointMake(px, py);
        return p;
    }
    return CGPointZero;
}

double du2Decimal(NSString* line) {
    double du = 0;
    NSArray *splits = [line componentsSeparatedByString:@"\\."];
    if ([splits count]>0) {
       du =  [splits[0] doubleValue] + [splits[1] doubleValue]/60 + [splits[2] doubleValue]/3600;
    }
    
    return du;
}



@implementation CaculateDistance

+(CGPoint)caculatePointwith:(double)sWeidu sJingdu:(double)sJingdu dWeidu:(double)dWeidu
dJingdu:(double)dJingdu rect:(CGRect)viewRect
{
    return caculate(sWeidu, sJingdu, dWeidu,
                    dJingdu, viewRect);
}

+(NSArray*)shuikuLocations
{
    NSMutableArray * locations = [[NSMutableArray alloc] init];
    Location *loc1 = [[Location alloc] initWithLatitude:du2Decimal(@"32.32.13") Longitude:du2Decimal(@"111.30.40")];
    loc1.locationId = @"61940205";
    [locations addObject:loc1];

    Location *loc2 = [[Location alloc] initWithLatitude:du2Decimal(@"32.21.38")
                                     Longitude:du2Decimal(@"110.53.18")];
    loc2.locationId = @"61907600";
    [locations addObject:loc2];
    
    Location *loc3 = [[Location alloc] initWithLatitude:du2Decimal(@"32.44.34")
                                     Longitude:du2Decimal(@"111.22.56")];
    loc3.locationId = @"62039130";
    [locations addObject:loc3];

    Location *loc4 = [[Location alloc] initWithLatitude:du2Decimal(@"32.22.54")
                                     Longitude:du2Decimal(@"111.09.39")];
    loc4.locationId = @"61907900";
    [locations addObject:loc4];
    
    Location *loc5 = [[Location alloc] initWithLatitude:du2Decimal(@"32.33.17")
                                     Longitude:du2Decimal(@"111.32.16")];
    loc5.locationId = @"61940210";
    [locations addObject:loc5];
    
    Location *loc6 = [[Location alloc] initWithLatitude:du2Decimal(@"32.48.29")
                                     Longitude:du2Decimal(@"111.11.22")];
    loc6.locationId = @"61907300";
    [locations addObject:loc6];
    
    Location *loc7 = [[Location alloc] initWithLatitude:du2Decimal(@"32.19.06")
                                     Longitude:du2Decimal(@"110.59.07")];
    loc7.locationId = @"61907810";
    [locations addObject:loc7];
    
    Location *loc8 = [[Location alloc] initWithLatitude:du2Decimal(@"32.37.59")
                                     Longitude:du2Decimal(@"110.58.44")];
    loc8.locationId = @"61906860";
    [locations addObject:loc8];
    
    Location *loc9 = [[Location alloc] initWithLatitude:du2Decimal(@"32.28.26")
                                     Longitude:du2Decimal(@"111.26.17")];
    loc9.locationId = @"61908110";
    [locations addObject:loc9];
    
    Location *loc10 = [[Location alloc] initWithLatitude:du2Decimal(@"")
                                                                  Longitude:du2Decimal(@"")];
    loc10.locationId = @"61907800";
    [locations addObject:loc10];
    
    Location *loc11 = [[Location alloc] initWithLatitude:du2Decimal(@"32.38.40")
                                     Longitude:du2Decimal(@"111.02.42")];
    loc11.locationId = @"61906870";
    [locations addObject:loc11];
    
    Location *loc12 = [[Location alloc] initWithLatitude:du2Decimal(@"32.47.14")
                                     Longitude:du2Decimal(@"111.16.16")];
    loc12.locationId = @"61907200";
    [locations addObject:loc12];
    
    Location *loc13 = [[Location alloc] initWithLatitude:du2Decimal(@"32.45.22")
                                     Longitude:du2Decimal(@"111.22.59")];
    loc13.locationId = @"62010401";
    [locations addObject:loc13];
    
    Location *loc14 = [[Location alloc] initWithLatitude:du2Decimal(@"32.25.24")
                                     Longitude:du2Decimal(@"111.21.37")];
    loc14.locationId = @"61940060";
    [locations addObject:loc14];
    
    Location *loc15 = [[Location alloc] initWithLatitude:du2Decimal(@"32.26.15")
                                     Longitude:du2Decimal(@"110.54.42")];
    loc15.locationId = @"61938900";
    [locations addObject:loc15];
    
    Location *loc16 = [[Location alloc] initWithLatitude:du2Decimal(@"32.27.00")
                                     Longitude:du2Decimal(@"111.13.24")];
    loc16.locationId = @"61939740";
    [locations addObject:loc16];
    
    Location *loc17 = [[Location alloc] initWithLatitude:du2Decimal(@"32.21.32")
                                     Longitude:du2Decimal(@"111.09.39")];
    loc17.locationId = @"61939860";
    [locations addObject:loc17];
    
    Location *loc18 = [[Location alloc] initWithLatitude:du2Decimal(@"32.51.41")
                                     Longitude:du2Decimal(@"111.10.06")];
    loc18.locationId = @"61937750";
    [locations addObject:loc18];
    
    Location *loc19 = [[Location alloc] initWithLatitude:du2Decimal(@"32.45.01")
                                     Longitude:du2Decimal(@"111.10.57")];
    loc19.locationId = @"61937245";
    [locations addObject:loc19];
    
    Location *loc20 = [[Location alloc] initWithLatitude:du2Decimal(@"32.40.02")
                                     Longitude:du2Decimal(@"111.17.38")];
    loc20.locationId = @"61939720";
    [locations addObject:loc20];
    
    Location *loc21 = [[Location alloc] initWithLatitude:du2Decimal(@"32.45.43")
                                     Longitude:du2Decimal(@"111.15.29")];
    loc21.locationId = @"61938350";
    [locations addObject:loc21];
    
    Location *loc22 = [[Location alloc] initWithLatitude:du2Decimal(@"32.32.53")
                                     Longitude:du2Decimal(@"110.56.42")];
    loc22.locationId = @"61939240";
    [locations addObject:loc22];
    
    Location *loc23 = [[Location alloc] initWithLatitude:du2Decimal(@"32.34.15")
                                     Longitude:du2Decimal(@"111.00.48")];
    loc23.locationId = @"61937700";
    [locations addObject:loc23];
    
    Location *loc24 = [[Location alloc] initWithLatitude:du2Decimal(@"32.35.16")
                                     Longitude:du2Decimal(@"111.15.23")];
    loc24.locationId = @"61939730";
    [locations addObject:loc24];
    
    Location *loc25 = [[Location alloc] initWithLatitude:du2Decimal(@"32.30.15")
                                     Longitude:du2Decimal(@"111.28.48")];
    loc25.locationId = @"61940260";
    [locations addObject:loc25];
    
    Location *loc26 = [[Location alloc] initWithLatitude:du2Decimal(@"32.31.57")
                                     Longitude:du2Decimal(@"111.19.19")];
    loc26.locationId = @"61940100";
    [locations addObject:loc26];
    
    Location *loc27 =[[Location alloc] initWithLatitude:du2Decimal(@"32.38.55")
                                     Longitude:du2Decimal(@"111.23.34")];
    loc27.locationId = @"61940110";
    [locations addObject:loc27];
    
    Location *loc28 =  [[Location alloc] initWithLatitude:du2Decimal(@"32.39.28")
                                     Longitude:du2Decimal(@"111.06.02")];
    loc28.locationId = @"61938250";
    [locations addObject:loc28];
    
    Location *loc29 = [[Location alloc] initWithLatitude:du2Decimal(@"32.47.10")
                                     Longitude:du2Decimal(@"111.11.07")];
    loc29.locationId = @"61937760";
    [locations addObject:loc29];
    

    return locations;
}

+(Location*)getLocationByLocationId:(NSString*)locationId
{
    NSArray *locations = [self shuikuLocations];
    
    for (Location *location in locations) {
        if ([location.locationId isEqualToString:locationId]) {
            return location;
        }
    }
    
    return nil;
}

@end
