//
//  WaterLevelViewController.m
//  SSB
//
//  Created by YTB on 14-3-14.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "WaterLevelViewController.h"
#import "WebServiceHelper.h"

@interface WaterLevelViewController ()

@end

@implementation WaterLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"水位";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    ASIHTTPRequest *request = [WebServiceHelper getASISOAP11Request:@"http://61.184.84.212:10000/" webServiceFile:@"webService.asmx" xmlNameSpace:@" http://tempuri.org/" Action:@"getDataApp_Shuiwenzhantable"];
    
    request.delegate = self;
    [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"requestFailed error:%@", error);
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding]);
}

//<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><getDataApp_ShuiwenzhantableResponse xmlns="http://tempuri.org/"><getDataApp_ShuiwenzhantableResult>62009600|296.6|数据缺失|296.6|白石河|2|2014/3/16 10:04:25#61906870|261.7|261.7|261.7|寨河|3|2014/3/17 22:01:24#61907200|394.6|394.6|394.6|程家沟|3|2014/3/17 22:01:45#61906860|252.6|252.6|252.6|堰湾|3|2014/3/17 22:01:46#61907300|196.12|196.12|196.12|大柏河|3|2014/3/17 22:00:55#61907600|344.58|344.58|344.58|吕家河|3|2014/3/17 22:01:22#61907810|481.06|481.04|481.06|三岔河|3|2014/3/17 22:01:45#61907900|250.43|250.43|250.43|白杨坪|3|2014/3/17 22:01:25#</getDataApp_ShuiwenzhantableResult></getDataApp_ShuiwenzhantableResponse></soap:Body></soap:Envelope>

@end
