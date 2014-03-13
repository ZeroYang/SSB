//
//  MenuItem.h
//  SSB
//
//  Created by YTB on 14-3-13.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

/// icon路径
@property (nonatomic, strong) NSString *icon;
/// name title
@property (nonatomic, strong) NSString *name;

@property (nonatomic,weak) UIViewController *viewControl;

@end
