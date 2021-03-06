//
//  WebServiceHelper.m
//  SSB
//
//  Created by YTB on 14-3-16.
//  Copyright (c) 2014年 YTB. All rights reserved.
//

#import "WebServiceHelper.h"
#import "GDataXMLNode.h"

@implementation WebServiceHelper

/*
 //Mark: 生成SOAP1.1版本的ASIHttp请求
 参数 webURL： 远程WebService的地址，不含*.asmx
 参数 webServiceFile： 远程WebService的访问文件名，如service.asmx
 参数 xmlNS： 远程WebService的命名空间
 参数 webServiceName： 远程WebService的名称
 参数 wsParameters： 调用参数数组，形式为[参数1名称，参数1值，参数2名称，参数2值⋯⋯]，如果没有调用参数，此参数为nil
 */
+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                         Action:(NSString *) action
{

    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
    <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
    <soap:Body>\
    <%@ xmlns=\"%@\" />\
    </soap:Body>\
    </soap:Envelope>", action, xmlNS];

    //请求发送到的路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WebURL, wsFile]];

    ASIHTTPRequest * theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    //[theRequest addRequestHeader:@"Host" value:@"61.184.84.212"];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [theRequest addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@", xmlNS,action]];
    
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest setRequestMethod:@"POST"];
    [theRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    return theRequest;
}

+ (ASIHTTPRequest *)getASISOAP11Request:(NSString *) WebURL
                         webServiceFile:(NSString *) wsFile
                           xmlNameSpace:(NSString *) xmlNS
                              arguments:(NSString *) args
                                 Action:(NSString *) action
{

    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                         <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                         <soap:Body>\
                         <getData xmlns=\"http://tempuri.org/\">\
                         <location>%@</location>\
                         </getData>\
                         </soap:Body>\
                         </soap:Envelope>", args];
    
    //请求发送到的路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WebURL, wsFile]];
    
    ASIHTTPRequest * theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    //[theRequest addRequestHeader:@"Host" value:@"61.184.84.212"];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [theRequest addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@", xmlNS,action]];
    
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest setRequestMethod:@"POST"];
    [theRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    return theRequest;
}
/**
 解析webservice返回的XML成一个NSDictionary
 参数：content ,要解析的数据
 参数：path ,要解析的XML数据一个根节点
 返回：NSDictionary
 */
+ (NSDictionary *)getWebServiceXMLResult:(NSString *) content xpath:(NSString *)path
{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    content = [content stringByReplacingOccurrencesOfString:@"<" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@">" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"xmlns" withString:@"noNSxml"];
    NSError *docError = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:&docError];
    if(!docError)
    {
        NSArray *children = nil;
        children = [document nodesForXPath:[NSString stringWithFormat:@"//%@",path] error:&docError];
        if(!docError)
        {
            if(children && [children count]>0)
            {
                GDataXMLElement *rootElement = (GDataXMLElement *)[children objectAtIndex:0];
                NSArray *nodearr = [rootElement children];
                for (int i = 0; i<[nodearr count]; i++) {
                    GDataXMLElement *element = (GDataXMLElement *)[nodearr objectAtIndex:i];
                    [resultDict setObject:[element stringValue] forKey:[element name]];
                }
            }
        }
    }
    [document release];
    return [resultDict autorelease];
}

@end
