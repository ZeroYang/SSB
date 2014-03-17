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

//+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
//                         webServiceFile:(NSString *) wsFile
//                           xmlNameSpace:(NSString *) xmlNS
//                         webServiceName:(NSString *) wsName
//                           wsParameters:(NSMutableArray *) wsParas;

+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                                 Action:(NSString *) action;
//+ (NSString *)getSOAP11WebServiceResponse:(NSString *) WebURL
//                           webServiceFile:(NSString *) wsFile
//                             xmlNameSpace:(NSString *) xmlNS
//                           webServiceName:(NSString *) wsName
//                             wsParameters:(NSMutableArray *) wsParas;

//+ (NSString *)getSOAP11WebServiceResponseWithNTLM:(NSString *) WebURL
//                                   webServiceFile:(NSString *) wsFile
//                                     xmlNameSpace:(NSString *) xmlNS
//                                   webServiceName:(NSString *) wsName
//                                     wsParameters:(NSMutableArray *) wsParas
//                                         userName:(NSString *) userName
//                                         passWord:(NSString *) passWord;

//+ (NSString *)checkResponseError:(NSString *) theResponse;

@end
