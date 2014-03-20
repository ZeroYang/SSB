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
{
    NSMutableArray *ctitleList;
    NSArray *rtitleList;
    NSMutableArray *dataList;
}
@end

@implementation WaterLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"实时水位";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    rtitleList = @[@"最近记录时间", @"最近记录水位", @"8时水位", @"20时降雨量"];
    ctitleList = [[NSMutableArray alloc] init];
    dataList = [[NSMutableArray alloc] init];
    
    spreadView = [[MDSpreadView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:spreadView];
    
    spreadView.delegate = self;
    spreadView.dataSource = self;
    spreadView.userInteractionEnabled = YES;
    
    [spreadView reloadData];
    
    
    
    ///////////////////////////////////
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
    
    NSString *xmlResult = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xmlResult);
    
    NSDictionary *dic =[WebServiceHelper getWebServiceXMLResult:xmlResult xpath:@"getDataApp_ShuiwenzhantableResult"];
    
    NSString *result = [dic objectForKey:@"text"];
    
    NSArray *skArray = [result componentsSeparatedByString:@"#"];
    for (int i= 0; i<[skArray count] - 1; i++) {
        NSString *skString = [skArray objectAtIndex:i];
        NSArray *components = [skString componentsSeparatedByString:@"|"];
        
        //标题
        [ctitleList addObject:[components objectAtIndex:4]];
        NSMutableArray *rowDatas = [[NSMutableArray alloc] init];
        //add 时间
        [rowDatas addObject:[components lastObject]];
        
        //add 水位
        for (int i= 1; i<4; i++) {

            NSString *value = [components objectAtIndex:i];
            if ([value doubleValue]>0) {
                value = [NSString stringWithFormat:@"%@m",value];
            }
            //水位 加上单位m
            [rowDatas addObject:value];
        }
        
        [dataList addObject:rowDatas];
    }
    [spreadView reloadData];
}

//<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><getDataApp_ShuiwenzhantableResponse xmlns="http://tempuri.org/"><getDataApp_ShuiwenzhantableResult>62009600|296.6|数据缺失|296.6|白石河|2|2014/3/16 10:04:25#61906870|261.7|261.7|261.7|寨河|3|2014/3/17 22:01:24#61907200|394.6|394.6|394.6|程家沟|3|2014/3/17 22:01:45#61906860|252.6|252.6|252.6|堰湾|3|2014/3/17 22:01:46#61907300|196.12|196.12|196.12|大柏河|3|2014/3/17 22:00:55#61907600|344.58|344.58|344.58|吕家河|3|2014/3/17 22:01:22#61907810|481.06|481.04|481.06|三岔河|3|2014/3/17 22:01:45#61907900|250.43|250.43|250.43|白杨坪|3|2014/3/17 22:01:25#</getDataApp_ShuiwenzhantableResult></getDataApp_ShuiwenzhantableResponse></soap:Body></soap:Envelope>


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
}

- (MDSpreadViewSelection *)spreadView:(MDSpreadView *)aSpreadView willSelectCellForSelection:(MDSpreadViewSelection *)selection
{
    return [MDSpreadViewSelection selectionWithRow:selection.rowPath column:selection.columnPath mode:MDSpreadViewSelectionModeRowAndColumn];
}


@end
