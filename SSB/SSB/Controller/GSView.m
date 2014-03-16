//
//  GSView.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "GSView.h"

@implementation GSView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 50)];
        text.text = @"官山水库大坝监测平台";
        text.backgroundColor = [UIColor clearColor];
        [self addSubview:text];
        [self addWebView];
    }
    return self;
}

-(void)addWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
    [self addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"http://61.184.80.90/doc/page/main.asp"];
    //NSURL *url = [NSURL URLWithString:resoureUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
