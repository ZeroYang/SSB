//
//  WaterLevelLineChartViewController.m
//  SSB
//
//  Created by YTB on 14-3-24.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "WaterLevelLineChartViewController.h"
#import "Constant.h"
#import "WebServiceHelper.h"
#import "FYChartView.h"
#import "APDocument.h"
#import "APElement.h"
#import "GDataXMLNode.h"

#define CHART_HEIGHT        (300)

@interface WaterLevelLineChartViewController ()<FYChartViewDataSource>
{
    NSString *location;
    NSMutableArray *monthDatas;
    NSMutableArray *sum1hValues;
    NSMutableArray *sum3hValues;
    NSMutableArray *sum6hValues;
    NSMutableArray *sum12hValues;
    NSMutableArray *sum24hValues;
    NSMutableArray *waterLevelValues;
    NSMutableArray *dayTimes;
    
}

@property (nonatomic, strong) FYChartView *chartView;
@property (nonatomic, strong) NSArray *values;



@end

@implementation WaterLevelLineChartViewController
@synthesize locationId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    monthDatas          = [[NSMutableArray alloc] init];
    sum1hValues         = [[NSMutableArray alloc] init];
    sum3hValues         = [[NSMutableArray alloc] init];
    sum6hValues         = [[NSMutableArray alloc] init];
    sum12hValues        = [[NSMutableArray alloc] init];
    sum24hValues        = [[NSMutableArray alloc] init];
    waterLevelValues    = [[NSMutableArray alloc] init];
    dayTimes            = [[NSMutableArray alloc] init];
    
    //nav menu
    CGRect frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAV_BAR);
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"1小时降雨量"];
    [menu displayMenuInView:self.view];
    menu.items = @[@"1小时降雨量", @"3小时降雨量", @"6小时降雨量", @"12小时降雨量", @"24小时降雨量",@"当月水位"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;

    
    //linechart
    UIScrollView * root= [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:root];
//#define ARC4RANDOM_MAX  0x100000000
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < 50; i++)
//    {
//        double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
//        [array addObject:[NSNumber numberWithDouble:val]];
//    }
//    self.values = array;
    
    self.chartView = [[FYChartView alloc] initWithFrame:CGRectMake(0.0f, (SCREEN_HEIGHT - CHART_HEIGHT)/4, 2*320.0f, CHART_HEIGHT)];
    self.chartView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.chartView.rectangleLineColor = [UIColor grayColor];
    self.chartView.lineColor = [UIColor blueColor];
    self.chartView.dataSource = self;
    //[self.view addSubview:self.chartView];
    
    [root addSubview:self.chartView];
    
    [root setContentSize:CGSizeMake(640, CHART_HEIGHT)];
    
    //
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    SINavigationMenuView *menu = ((SINavigationMenuView*)self.navigationItem.titleView);
    menu.menuButton.title.text = [menu.items objectAtIndex:index];
    
    if (0 == index) {
        self.values = sum1hValues;
    }
    
    if (1 == index) {
        self.values = sum3hValues;
    }
    
    if (2 == index) {
        self.values = sum6hValues;
    }
    
    if (3 == index) {
        self.values = sum12hValues;
    }
    
    if (4 == index) {
        self.values = sum24hValues;
    }
    
    if (5 == index) {
        self.values = waterLevelValues;
    }
    
    [self.chartView reloadData];
    NSLog(@"did selected item at index %d", index);
}

-(void) getData
{
    ///////////////////////////////////
//    ASIHTTPRequest *request = [WebServiceHelper getASISOAP11Request:@"http://61.184.84.212:10000/" webServiceFile:@"webService.asmx" xmlNameSpace:@" http://tempuri.org/" Action:@"getDataApp_Shuiwenzhantable"];
    
    ASIHTTPRequest *request = [WebServiceHelper getASISOAP11Request:@"http://61.184.84.212:10000/" webServiceFile:@"webService.asmx" xmlNameSpace:@" http://tempuri.org/" arguments:locationId Action:@"getData"];
    request.delegate = self;
    [request startAsynchronous];
}

-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"requestFailed error:%@", error);
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *xmlResult = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xmlResult);
    
    NSDictionary *dic =[WebServiceHelper getWebServiceXMLResult:xmlResult xpath:@"getDataResult"];
    
    
    NSString *result = [dic objectForKey:@"text"];
    result = [result stringByReplacingOccurrencesOfString:locationId withString:@"locationId"];

    [self parser:result];
    
    self.values = sum1hValues;
    [self.chartView reloadData];
}

#pragma mark - FYChartViewDataSource

//number of value count
- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;
{
    return self.values ? self.values.count : 0;
}

//value at index
- (float)chartView:(FYChartView *)chartView valueAtIndex:(NSInteger)index
{
    return [((NSNumber *)self.values[index]) floatValue];
}

//horizontal title at index
- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index
{
    
    if (0 == index%5) {
        return [NSString stringWithFormat:@"%@",[dayTimes objectAtIndex:index]];
    }
    return nil;
}

//horizontal title alignment at index
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
    if (index == 0)
    {
        alignment = HorizontalTitleAlignmentCenter;
    }
    else if (index == self.values.count - 1)
    {
        alignment = HorizontalTitleAlignmentRight;
    }
    
    return alignment;
}

//description view at index
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index
{
    NSString *description = [NSString stringWithFormat:@"time=%@\nvalue=%.2f", [dayTimes objectAtIndex:index],
                             [((NSNumber *)self.values[index]) floatValue]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chart_ description_bg"]];
    CGRect frame = imageView.frame;
    frame.size = CGSizeMake(80.0f, 40.0f);
    imageView.frame = frame;
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(.0f, .0f, imageView.frame.size.width, imageView.frame.size.height)];
    label.text = description;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10.0f];
    [imageView addSubview:label];
    
    return imageView;
}

-(void) parser:(NSString *)str
{
    APDocument *apdoc = [[APDocument alloc] initWithString:str];
    APElement *rootElement = [apdoc rootElement];
    
    APElement *nameEle = [rootElement firstChildElementNamed:@"name"];
    location = [nameEle value];//获取监测点的名称

    NSArray *elemEles = [rootElement childElements:@"elem"];
    
    
    
    for (APElement *elemEle in elemEles) {
        
        NSMutableDictionary *dayDataDic = [[NSMutableDictionary alloc] init];
        
        APElement *countEle = [elemEle firstChildElementNamed:@"count"];
        [dayDataDic setObject:[countEle value] forKey:@"count"];
        
        APElement *timeEle = [elemEle firstChildElementNamed:@"time"];
        [dayDataDic setObject:[timeEle value] forKey:@"time"];
        [dayTimes addObject:[timeEle value]];
        
        APElement *Sum1hfallEle = [elemEle firstChildElementNamed:@"Sum1hfall"];
        [dayDataDic setObject:[Sum1hfallEle value] forKey:@"Sum1hfall"];
        [sum1hValues addObject:[Sum1hfallEle value]];
        
        APElement *Sum1hfal3Ele = [elemEle firstChildElementNamed:@"Sum1hfal3"];
        [dayDataDic setObject:[Sum1hfal3Ele value] forKey:@"Sum1hfal3"];
        [sum3hValues addObject:[Sum1hfal3Ele value]];
        
        APElement *Sum6hfallEle = [elemEle firstChildElementNamed:@"Sum6hfall"];
        [dayDataDic setObject:[Sum6hfallEle value] forKey:@"Sum6hfall"];
        [sum6hValues addObject:[Sum6hfallEle value]];
        
        APElement *Sum12hfallEle = [elemEle firstChildElementNamed:@"Sum12hfall"];
        [dayDataDic setObject:[Sum12hfallEle value] forKey:@"Sum12hfall"];
        [sum12hValues addObject:[Sum12hfallEle value]];
        
        APElement *Sum24hfallEle = [elemEle firstChildElementNamed:@"Sum24hfall"];
        [dayDataDic setObject:[Sum24hfallEle value] forKey:@"Sum24hfall"];
        [sum24hValues addObject:[Sum24hfallEle value]];
        
        
        APElement *WaterLevelEle = [elemEle firstChildElementNamed:@"WaterLevel"];
        [dayDataDic setObject:[WaterLevelEle value] forKey:@"WaterLevel"];
        [waterLevelValues addObject:[WaterLevelEle value]];
        
        [monthDatas addObject:dayDataDic];
    }
    
}

-(void)getDayTimes
{
    for (NSDictionary *dayValues in monthDatas) {
        [dayTimes addObject:[dayValues objectForKey:@"time"]];
    }
}

@end
