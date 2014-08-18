//
//  IHDataOperator.m
//  IosHW
//
//  Created by Claire Hsu on 2014/8/14.
//  Copyright (c) 2014年 livebricks. All rights reserved.
//

#import "IHDataOperator.h"
#import "IHRootViewController.h"



@implementation IHDataOperator


+(NSDictionary *)getDicFromURL:(NSString *)jsonURL{
    
    __block NSDictionary *jsonDic;
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonURL]];
    //IHRootViewController *rootViewController = [[IHRootViewController alloc]init];
    //Sync
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&jsonError];
    //jsonDic = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    
    
    //Async
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        /*
        if ([jsonDic count]>0) {
            IHRootViewController *rootViewController = [[IHRootViewController alloc]init];
            [rootViewController updateUI:[jsonDic count]];
           
        }
        */
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            
        });
        
        
    }];
   
    
    
    return jsonDic;
}

@end
