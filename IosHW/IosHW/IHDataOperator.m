//
//  IHDataOperator.m
//  IosHW
//
//  Created by Claire Hsu on 2014/8/14.
//  Copyright (c) 2014年 livebricks. All rights reserved.
//

#import "IHDataOperator.h"

@implementation IHDataOperator


+(NSDictionary *)getDicFromURL:(NSString *)jsonURL{
    NSError *jsonError = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&jsonError];
    
    
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonError];

    return jsonDic;
}

@end
