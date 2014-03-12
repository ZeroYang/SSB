//
//  AppData.h
//  SSB
//
//  Created by YTB on 14-3-12.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

/// app icon路径
@property (nonatomic, strong) NSString *icon;
/// name title
@property (nonatomic, strong) NSString *name;
/// description 描述
@property (nonatomic, strong) NSString *description;
/// appId
@property (nonatomic, strong) NSString *appId;
/// appArgs 参数
@property (nonatomic, strong) NSString *appArgs;

//TODO add 属性

@end
