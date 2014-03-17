//
//  DetailViewController.m
//  SSB
//
//  Created by YTB on 14-3-17.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "DetailViewController.h"
#import "WebServiceHelper.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

@end
