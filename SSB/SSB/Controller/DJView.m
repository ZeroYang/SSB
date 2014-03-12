//
//  DJView.m
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "DJView.h"

@implementation DJView

@synthesize viewControl;
@synthesize spboard;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 50)];
        text.text = @"全市山洪灾害监测平台";
        [self addSubview:text];
    }
    return self;
}

- (void)initSpringBoard
{
    if (spboard) {
        return;
    }
    
    SBMenuItem *item = nil;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    int count = 5;
    for (int i = 0; i < count; i++) {
        AppData *app = [[AppData alloc] init];
        app.icon = [NSString stringWithFormat:@"serviceIcon-%d",i+1];
        app.name = [NSString stringWithFormat:@"应用%d",i+1];
        app.description = [NSString stringWithFormat:@"descriptiondescriptiondescription%d",i+1];
        app.appId = [NSString stringWithFormat:@"%d",i+1];
        app.appArgs = @"";
        item = [[SBMenuItem alloc] initWithApp:app];
        item.control = viewControl;
        [items addObject:item];
        
    }
    
    
    // at least, here is a Add buttonitem
    item = [[SBMenuItem alloc] initWithApp:nil];
    item.control = viewControl;
    [items addObject:item];
    
    CGRect spRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    spboard = [[SpringBoard alloc] initWithTitle:@"hello"
                                           items:items
                                           frame:spRect];
    [self addSubview:spboard];
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
