//
//  ReferenceViewController.m
//  SSB
//
//  Created by YTB on 14-3-14.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "ReferenceViewController.h"
#import "WebViewController.h"

#define CELL_HEIGHT             (40)

@interface ReferenceItem : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;

-(id)initWithTitle:(NSString*)text Url:(NSString*)string;

@end
@implementation ReferenceItem

@synthesize title;
@synthesize url;

-(id)initWithTitle:(NSString*)text Url:(NSString*)string
{
    
    self = [super init];
    if (self) {
        self.title = text;
        self.url = string;
    }
    return self;
}

@end


@interface ReferenceViewController ()
{
    NSMutableArray *dataList;
    
}
@end

@implementation ReferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"相关链接";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataList = [[NSMutableArray alloc] init];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"1、本局山洪灾害系统网址" Url:@"http://61.184.84.212:8081/system/login!input.action"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"2、浪河水库安全系统平台(该站经常不能登录)" Url:@"http://61.184.80.242:8081/"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"3、官山水库安全系统视频平台" Url:@"http://61.184.80.90/doc/page/main.asp"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"4、十堰气象局网址(该站只有给与授权IP网址才能登录)" Url:@"http://218.200.157.18/(S(5cwy4ihaiefjmhlihf0j4pra))/default.aspx"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"5、湖北公众信息网址" Url:@"http://zdz.hbqx.gov.cn/"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"6、中央气象台1-3天预报" Url:@"http://www.nmc.gov.cn/publish/forecasts.htm"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"7、本局水务防汛网址" Url:@"http://61.184.84.212:8086/"]];
    [dataList addObject:[[ReferenceItem alloc] initWithTitle:@"8、长江水情网址" Url:@"http://www.cjh.com.cn/"]];
    
    UITableView *view = [[UITableView alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    view.dataSource = self;
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor whiteColor];
    view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"ReferenceCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        ReferenceItem *item = [dataList objectAtIndex:[indexPath row]];
        cell.textLabel.text = item.title;
        cell.textLabel.numberOfLines = 0;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReferenceItem *item = [dataList objectAtIndex:[indexPath row]];
    WebViewController* a =  [[WebViewController alloc] init];
    a.resoureUrl = item.url;
    a.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController)
    {
        UINavigationController* nav = self.navigationController;
        [nav pushViewController:a animated:YES];
    }
}

@end
