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

@interface AlarmlViewController ()<RadarViewDelegate>
{
    RadarView *radar;
    ASIHTTPRequest *ARequest;
}
@end

@implementation AlarmlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"GPS定位预警";
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
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding]);
    [radar drawPoint:CGPointMake(100, 100)];
    
//    10000|丹江口|0.4|5|1小时降雨量#10001|吕家河|0.4|5|1小时降雨量#10002|三官殿|0.5|2|3小时降雨量
//    ​（地区ID|地区名称|地区降雨量|地区水位|预警累计时间#）
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

@end
