//
//  CaculateDistance.cpp
//  SSB
//
//  Created by YTB on 14-3-26.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

//#import <math.h>
#import "CaculateDistance.h"

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
@end
