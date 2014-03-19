//
//  RainFallViewController.m
//  SSB
//
//  Created by YTB on 14-3-14.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "RainFallViewController.h"
#import "WebServiceHelper.h"

#define CELL_HEIGHT             (40)

@interface RainFallViewController ()
{
    NSMutableArray *dataList;
}
@end

@implementation RainFallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"降雨量";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *view = [[UITableView alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    view.dataSource = self;
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor whiteColor];
    view.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    ASIHTTPRequest *request = [WebServiceHelper getASISOAP11Request:@"http://61.184.84.212:10000/" webServiceFile:@"webService.asmx" xmlNameSpace:@" http://tempuri.org/" Action:@"getDataApp_Yuliangtable"];
    
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

//<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><getDataApp_YuliangtableResponse xmlns="http://tempuri.org/"><getDataApp_YuliangtableResult>61939860|2014/3/17 22:01:30|0|0|0|0|0|簸箩岩#61907900|2014/3/17 22:01:25|0|0|0|0|0|白杨坪#62039130|2014/3/17 22:29:27|0|0|0|0|0|太极峡#61907200|2014/3/17 22:01:45|0|0|0|0|0|程家沟#61939740|2014/3/17 22:01:31|0|0|0|0|0|洞子沟#61939730|2014/3/17 22:01:28|0|0|0|0|0|土台#61939720|2014/3/17 22:01:27|0|0|0|0|0|核桃园#61940060|2014/3/17 22:01:28|0|0|0|0|0|红山石#61938250|2014/3/17 22:01:26|0|0|0|0|0|双庙河#61939240|2014/3/17 22:01:24|0|0|0|0|0|岗河#61907300|2014/3/17 22:00:55|0|0|0|0|0|大柏河#61937700|2014/3/17 22:01:29|0|0|0|0|0|后湾一库#61940205|2014/3/17 22:01:33|0|0|0|0|0|许家畈#61937760|2014/3/17 22:01:34|0|0|0|0|0|小柏营#61907600|2014/3/17 22:01:22|0|0|0|0|0|吕家河#61937750|2014/3/17 22:01:32|0|0|0|0|0|十条沟#62009600|2014/3/16 10:04:25|0|0|0|0|0|白石河#61938900|2014/3/17 22:01:26|0|0|0|0|0|官亭#61907810|2014/3/17 22:01:45|0|0|0|0|0|三岔河#61938350|2014/3/17 22:01:31|0|0|0|0|0|黑垭#61906870|2014/3/17 22:01:24|0|0|0|0|0|寨河#61940260|2014/3/17 22:01:25|0|0|0|0|0|黑石沟#61906860|2014/3/17 22:01:46|0|0|0|0|0|堰湾#61940210|2014/3/17 22:13:02|0|0|0|0|0|金岗#61940110|2014/3/17 22:01:24|0|0|0|0|0|八里寨#61937245|2014/3/17 22:01:27|0|0|0|0|0|左绞河#61940100|2014/3/17 22:01:33|0|0|0|0|0|凤凰山#</getDataApp_YuliangtableResult></getDataApp_YuliangtableResponse></soap:Body></soap:Envelope>

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [dataList count];
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [cell.contentView addSubview: textLabel];
        textLabel.text = @"测试";
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 1, 40)];
        [cell.contentView addSubview:lineView];
        lineView.backgroundColor = [UIColor blackColor];
        UILabel *textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(41, 0, 40, 40)];
        [cell.contentView addSubview: textLabel1];
        textLabel1.text = @"测试1";
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 40)];
        [cell.contentView addSubview:lineView1];
        lineView1.backgroundColor = [UIColor blackColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
@end
