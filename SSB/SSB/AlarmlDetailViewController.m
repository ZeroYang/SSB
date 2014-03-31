//
//  AlarmlDetailViewController.m
//  SSB
//
//  Created by YTB on 14-3-29.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "AlarmlDetailViewController.h"
#import "RadarView.h"
#import "CaculateDistance.h"

@interface AlarmlDetailViewController ()
{
    NSMutableArray *ctitleList;
    NSArray *rtitleList;
    NSMutableArray *dataList;
    NSMutableArray *locationIds;
    
    RadarView* radar;
}
@end

@implementation AlarmlDetailViewController
@synthesize alarmData,alarmPoints;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"雷达预警监测";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //地区ID|地区名称|地区降雨量|地区水位|预警累计时间
    rtitleList = @[@"距离",@"地区降雨量", @"地区水位", @"预警累计时间"];
    ctitleList = [[NSMutableArray alloc] init];
    dataList = [[NSMutableArray alloc] init];
    locationIds = [[NSMutableArray alloc] init];
    
    UIScrollView * parentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    radar = [[RadarView alloc] initWithFrame:CGRectMake(10, 5, 300, 400)];
    [parentView addSubview:radar];
    radar.backgroundColor = [UIColor blackColor];
    
    spreadView = [[MDSpreadView alloc] initWithFrame:self.view.bounds];
    [spreadView setFrame:CGRectOffset(spreadView.frame, 0, 400 - 40)];
    [parentView addSubview:spreadView];
    
    [self.view addSubview:parentView];
    [parentView setContentSize:CGSizeMake(320, 2*self.view.bounds.size.height)];
    
    spreadView.delegate = self;
    spreadView.dataSource = self;
    spreadView.userInteractionEnabled = YES;
    [self parserDataStr];
    [spreadView reloadData];
    
    [self drawAlarmPoint];
}

-(void)drawAlarmPoint
{
    if ([alarmPoints count] > 0) {
        [radar drawPoint:alarmPoints];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parserDataStr
{
    //61940205|许家畈|0.4|5|1小时降雨量#62039130|太极峡|0.4|5|1小时降雨量#61939240|岗河|0.5|2|3小时降雨量
    NSArray *skArray = [alarmData componentsSeparatedByString:@"#"];
    if(0 == [skArray count]) //报文格式错误
    return;
    for (int i= 0; i<[skArray count]; i++) {
        NSString *skString = [skArray objectAtIndex:i];
        NSArray *components = [skString componentsSeparatedByString:@"|"];
        if ([components count] < 5) {
            return;
        }
        //locationId
        [locationIds addObject:[components objectAtIndex:0]];
        //地区名称
        [ctitleList addObject:[components objectAtIndex:1]];
        
        NSMutableArray *rowDatas = [[NSMutableArray alloc] init];

        //距离 加上单位km
        if ([alarmPoints count] >= i) {
            CPoint *point = [alarmPoints objectAtIndex:i];
            [rowDatas addObject:[NSString stringWithFormat:@"%fkm",point.distance]];
        }
        else
        {
            [rowDatas addObject:[NSString stringWithFormat:@"%fkm",0.0]];
        }

        //降雨量 加上单位mm
        [rowDatas addObject:[NSString stringWithFormat:@"%@mm",[components objectAtIndex:2]]];
        //地区水位 加上单位m
        [rowDatas addObject:[NSString stringWithFormat:@"%@m",[components objectAtIndex:3]]];
        //预警累计时间
        [rowDatas addObject:[components objectAtIndex:4]];

        
        [dataList addObject:rowDatas];
    }
}

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
//    
//    WaterLevelLineChartViewController *lineChart = [[WaterLevelLineChartViewController alloc] init];
//    lineChart.locationId  = [locationIds objectAtIndex:rowPath.row];
//    [self.navigationController pushViewController:lineChart animated:YES];
}

- (MDSpreadViewSelection *)spreadView:(MDSpreadView *)aSpreadView willSelectCellForSelection:(MDSpreadViewSelection *)selection
{
    return [MDSpreadViewSelection selectionWithRow:selection.rowPath column:selection.columnPath mode:MDSpreadViewSelectionModeRowAndColumn];
}


@end
