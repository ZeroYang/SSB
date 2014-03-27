//
//  RainFallViewController.m
//  SSB
//
//  Created by YTB on 14-3-14.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "RainFallViewController.h"
#import "WebServiceHelper.h"
#import "RainFallLineChartViewController.h"
#import "SUIActivityIndicatorView.h"
#import "iToast.h"

@interface RainFallViewController ()
{
    NSMutableArray *ctitleList;
    NSArray *rtitleList;
    NSMutableArray *dataList;
    NSMutableArray *locationIds;
    SUIActivityIndicatorView *activityView;
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
    
    rtitleList = @[@"最近记录时间", @"1小时降雨量", @"3小时降雨量", @"6小时降雨量", @"12小时降雨量", @"24小时降雨量"];
    ctitleList = [[NSMutableArray alloc] init];
    dataList = [[NSMutableArray alloc] init];
    locationIds = [[NSMutableArray alloc] init];
    
    spreadView = [[MDSpreadView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:spreadView];
    
    spreadView.delegate = self;
    spreadView.dataSource = self;
    spreadView.userInteractionEnabled = YES;
    
    [spreadView reloadData];
    
    //
    activityView = [[SUIActivityIndicatorView alloc] init];
    [activityView showWaitingInViewController:self];
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
    [activityView hideWaiting];
    [[iToast makeText:@"获取降雨量数据失败!"] show];
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    [activityView hideWaiting];
    NSString *xmlResult = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xmlResult);
    
    NSDictionary *dic =[WebServiceHelper getWebServiceXMLResult:xmlResult xpath:@"getDataApp_YuliangtableResult"];
    
    NSString *result = [dic objectForKey:@"text"];
    
    NSArray *skArray = [result componentsSeparatedByString:@"#"];
    if(0 == [skArray count]) //报文格式错误
        return;
    for (int i= 0; i<[skArray count] - 1; i++) {
        NSString *skString = [skArray objectAtIndex:i];
        NSArray *components = [skString componentsSeparatedByString:@"|"];
        
        if ([components count] < 1) {
            return;
        }
        //locationId
        [locationIds addObject:[components objectAtIndex:0]];
        //标题
        [ctitleList addObject:[components lastObject]];
        NSMutableArray *rowDatas = [[NSMutableArray alloc] init];
        [rowDatas addObject:[components objectAtIndex:1]];
        //剔除id和水库名
        for (int i= 2; i<[components count] - 1; i++) {
            //降雨量 加上单位mm
            [rowDatas addObject:[NSString stringWithFormat:@"%@mm",[components objectAtIndex:i]]];
            
        }
        
        [dataList addObject:rowDatas];
    }
    [spreadView reloadData];
    
}

//水库名称 最近记录时间 1小时降雨量 3小时降雨量 6小时降雨量 12小时降雨量 24小时降雨量

//<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><getDataApp_YuliangtableResponse xmlns="http://tempuri.org/"><getDataApp_YuliangtableResult>61939860|2014/3/17 22:01:30|0|0|0|0|0|簸箩岩#61907900|2014/3/17 22:01:25|0|0|0|0|0|白杨坪#62039130|2014/3/17 22:29:27|0|0|0|0|0|太极峡#61907200|2014/3/17 22:01:45|0|0|0|0|0|程家沟#61939740|2014/3/17 22:01:31|0|0|0|0|0|洞子沟#61939730|2014/3/17 22:01:28|0|0|0|0|0|土台#61939720|2014/3/17 22:01:27|0|0|0|0|0|核桃园#61940060|2014/3/17 22:01:28|0|0|0|0|0|红山石#61938250|2014/3/17 22:01:26|0|0|0|0|0|双庙河#61939240|2014/3/17 22:01:24|0|0|0|0|0|岗河#61907300|2014/3/17 22:00:55|0|0|0|0|0|大柏河#61937700|2014/3/17 22:01:29|0|0|0|0|0|后湾一库#61940205|2014/3/17 22:01:33|0|0|0|0|0|许家畈#61937760|2014/3/17 22:01:34|0|0|0|0|0|小柏营#61907600|2014/3/17 22:01:22|0|0|0|0|0|吕家河#61937750|2014/3/17 22:01:32|0|0|0|0|0|十条沟#62009600|2014/3/16 10:04:25|0|0|0|0|0|白石河#61938900|2014/3/17 22:01:26|0|0|0|0|0|官亭#61907810|2014/3/17 22:01:45|0|0|0|0|0|三岔河#61938350|2014/3/17 22:01:31|0|0|0|0|0|黑垭#61906870|2014/3/17 22:01:24|0|0|0|0|0|寨河#61940260|2014/3/17 22:01:25|0|0|0|0|0|黑石沟#61906860|2014/3/17 22:01:46|0|0|0|0|0|堰湾#61940210|2014/3/17 22:13:02|0|0|0|0|0|金岗#61940110|2014/3/17 22:01:24|0|0|0|0|0|八里寨#61937245|2014/3/17 22:01:27|0|0|0|0|0|左绞河#61940100|2014/3/17 22:01:33|0|0|0|0|0|凤凰山#</getDataApp_YuliangtableResult></getDataApp_YuliangtableResponse></soap:Body></soap:Envelope>


#pragma mark - Spread View Datasource

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfColumnsInSection:(NSInteger)section
{
    //view的列数
    return [rtitleList count];
}

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfRowsInSection:(NSInteger)section
{
    //view的行数
    return [ctitleList count];
}

- (NSInteger)numberOfColumnSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    //section列数
    return 1;
}

- (NSInteger)numberOfRowSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    //section行数
    return 1;
}

#pragma mark Heights
// Comment these out to use normal values (see MDSpreadView.h)
- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowAtIndexPath:(MDIndexPath *)indexPath
{
    //行高度
    return 30;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowHeaderInSection:(NSInteger)rowSection
{
    //行 section 宽度
    return 30;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(MDIndexPath *)indexPath
{
    //列宽度
    return 180;
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnHeaderInSection:(NSInteger)columnSection
{
    //列 的 section 宽度
    return 90;
}

#pragma Cells
- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{

    static NSString *cellIdentifier = @"Cell";
    
    MDSpreadViewCell *cell = [aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewCell alloc] initWithStyle:MDSpreadViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *dataArray = [dataList objectAtIndex:rowPath.row];
    NSString *data = [dataArray objectAtIndex:columnPath.row];
    cell.textLabel.text = data;
    cell.textLabel.textColor = [UIColor colorWithRed:(arc4random()%100)/200. green:(arc4random()%100)/200. blue:(arc4random()%100)/200. alpha:1];
    
    return cell;
}

// either do that ^^ for advanced customization, or this vv and let the cell take care of all the details
// both can be combined if you wanted, by returning nil to the above methods

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)rowSection forColumnSection:(NSInteger)columnSection
{
    //TODO 竖直 title 第一列
    if (0 == columnSection && 0==rowSection) {
        return @"水库名称";
    }
    return [NSString stringWithFormat:@"Cor %d-%d", columnSection+1, rowSection+1];
}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
{
// 水平 title 第一行
    if (0 == [rtitleList count]) {
        return nil;
    }
    return [rtitleList objectAtIndex:columnPath.row];

}

- (id)spreadView:(MDSpreadView *)aSpreadView titleForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
{
    if (0 == [ctitleList count]) {
        return nil;
    }
    return [ctitleList objectAtIndex:rowPath.row];
}

- (void)spreadView:(MDSpreadView *)aSpreadView didSelectCellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    [spreadView deselectCellForRowAtIndexPath:rowPath forColumnAtIndexPath:columnPath animated:YES];
    NSLog(@"Selected %@ x %@", rowPath, columnPath);
    
    RainFallLineChartViewController *lineChart = [[RainFallLineChartViewController alloc] init];
    lineChart.locationId  = [locationIds objectAtIndex:rowPath.row];
    [self.navigationController pushViewController:lineChart animated:YES];
}

- (MDSpreadViewSelection *)spreadView:(MDSpreadView *)aSpreadView willSelectCellForSelection:(MDSpreadViewSelection *)selection
{
    return [MDSpreadViewSelection selectionWithRow:selection.rowPath column:selection.columnPath mode:MDSpreadViewSelectionModeRowAndColumn];
}

@end
