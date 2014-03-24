//
//  WebServiceHelper.h
//  SSB
//
//  Created by YTB on 14-3-16.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface WebServiceHelper : NSObject

+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                                 Action:(NSString *) action;

+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                              arguments:(NSString *) args
                                 Action:(NSString *) action;

+ (NSDictionary *)getWebServiceXMLResult:(NSString *) content xpath:(NSString *)path;

@end
