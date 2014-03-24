//
//  RainFallLineChartViewController.m
//  SSB
//
//  Created by YTB on 14-3-24.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "RainFallLineChartViewController.h"
#import "Constant.h"
#import "WebServiceHelper.h"

@interface RainFallLineChartViewController ()

@end

@implementation RainFallLineChartViewController
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
    
    CGRect frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAV_BAR);
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"1小时降雨量"];
    [menu displayMenuInView:self.view];
    menu.items = @[@"1小时降雨量", @"3小时降雨量", @"6小时降雨量", @"12小时降雨量", @"24小时降雨量"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;

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

    }
    
    if (1 == index) {

    }
    
    if (2 == index) {

    }
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
}

@end
