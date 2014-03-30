//
//  AlarmlViewController.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "AlarmlViewController.h"
#import "RadarView.h"
#import "WebServiceHelper.h"
#import "iToast.h"
#import "CaculateDistance.h"
#import "AlarmlDetailViewController.h"
#import "LocationHelper.h"

@interface AlarmlViewController ()<RadarViewDelegate,LocationHelperDelegate>
{
    RadarView *radar;
    ASIHTTPRequest *ARequest;
    NSMutableArray *locationIds;
    LocationHelper *locationHelper;
    BOOL isAlarm;
    NSString * alarmInfo;
}
@end

@implementation AlarmlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"GPS定位预警";
        locationHelper = [[LocationHelper alloc] init];
        locationHelper.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    radar = [[RadarView alloc] initWithFrame:CGRectMake(10, 5, 300, 400)];
    [self.view addSubview:radar];
    radar.backgroundColor = [UIColor blackColor];
    radar.delegate = self;
    
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]
//                                     initWithTarget:self
//                                     action:@selector(viewTapped:)];
//    tapGr.cancelsTouchesInView = NO;
//    [radar addGestureRecognizer:tapGr];
    
    locationIds = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getRadarData
{
    ARequest = [WebServiceHelper getASISOAP11Request:@"http://61.184.84.212:10000/" webServiceFile:@"webService.asmx" xmlNameSpace:@" http://tempuri.org/" Action:@"getRadarData"];
    
    ARequest.delegate = self;
    [ARequest startAsynchronous];
    
}

#pragma ASIHTTPRequest

-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"requestFailed error:%@", error);
    [[iToast makeText:@"获取雷达预警数据失败!"] show];
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
//    isAlarm = YES;
    NSString *xmlResult = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xmlResult);
    NSDictionary *dic =[WebServiceHelper getWebServiceXMLResult:xmlResult xpath:@"getDataApp_YuliangtableResult"];
    
    NSString *result = [dic objectForKey:@"text"];
    alarmInfo = result;
    result = @"61940205|许家畈|0.4|5|1小时降雨量#62039130|太极峡|0.4|5|1小时降雨量#61939240|岗河|0.5|2|3小时降雨量";
    NSArray *skArray = [result componentsSeparatedByString:@"#"];
    if(0 == [skArray count]) //报文格式错误
    {
        [[iToast makeText:@"在您身边50公里内未发现山洪灾害预警！"] show];
        return;
    }
    for (int i= 0; i<[skArray count]; i++) {
        NSString *skString = [skArray objectAtIndex:i];
        NSArray *components = [skString componentsSeparatedByString:@"|"];
        if ([components count] < 1) {
            return;
        }
        //locationId
        [locationIds addObject:[components objectAtIndex:0]];
        
    }
//    isAlarm = YES;
    [locationHelper startLocation];
    
//    1.根据返回结果 地区坐标和当前坐标计算在雷达界面 距离在50以内的描点
//    2.有返回结果 可以进入 详情界面
}

-(NSArray*)drawSAlarmsitePoint:(CLLocation*)myLocation
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (NSString *locationId in locationIds) {
        Location *location = [CaculateDistance getLocationByLocationId:locationId];
        CGPoint point = [CaculateDistance caculatePointwith:location.latitude sJingdu:location.longitude dWeidu:myLocation.coordinate.latitude dJingdu:myLocation.coordinate.longitude rect:radar.frame];
        
        
        if ( !CGPointEqualToPoint(CGPointZero, point) ) {
            [points addObject:[[CPoint alloc] initWithX:point.x Y:point.y]];
        }
    }
    return points;
//    if ([points count] >0) {
//        [radar drawPoint:points];
//    }

}

#pragma mark RadarViewDelegate
-(void)radarViewSweep
{
    [self getRadarData];
}

-(void)radarViewStopSweep
{
    [ARequest cancel];
}

#pragma mark LocationHelperDelegate
-(void)didLocation:(CLLocation *)location
{
    AlarmlDetailViewController *detail = [[AlarmlDetailViewController alloc] init];
    //test
    //detail.alarmData = @"61940205|许家畈|0.4|5|1小时降雨量#62039130|太极峡|0.4|5|1小时降雨量#61939240|岗河|0.5|2|3小时降雨量";
    detail.alarmData = alarmInfo;
    detail.alarmPoints = [self drawSAlarmsitePoint:location];
    [self.navigationController pushViewController:detail animated:NO];
    return;
}

-(void)didFailLocation:(NSError *)error
{
    NSLog(@"定位失败！");
    [[iToast makeText:@"获取当前位置失败!"] show];
    
    AlarmlDetailViewController *detail = [[AlarmlDetailViewController alloc] init];
    //test
    //detail.alarmData = @"61940205|许家畈|0.4|5|1小时降雨量#62039130|太极峡|0.4|5|1小时降雨量#61939240|岗河|0.5|2|3小时降雨量";
    detail.alarmData = alarmInfo;
    detail.alarmPoints = nil;
    [self.navigationController pushViewController:detail animated:NO];
    return;
}

//- (void)viewTapped:(UITapGestureRecognizer*)tapGr
//{
//    if (isAlarm) {
//        AlarmlDetailViewController *detail = [[AlarmlDetailViewController alloc] init];
//        //test
//        detail.alarmData = @"61940205|许家畈|0.4|5|1小时降雨量#62039130|太极峡|0.4|5|1小时降雨量#61939240|岗河|0.5|2|3小时降雨量";
//        //detail.alarmData = alarmInfo;
//        [self.navigationController pushViewController:detail animated:NO];
//        return;
//    }
//}
@end
