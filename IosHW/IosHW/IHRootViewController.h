//
//  IHRootViewController.h
//  IosHW
//
//  Created by Claire Hsu on 2014/8/13.
//  Copyright (c) 2014年 livebricks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IHRootViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>{
    CGRect fullScreen;
    NSDictionary *jsonDataAll;
    NSDictionary *itemsDic;
    UIActivityIndicatorView *indicatorView;
    NSDictionary *jsonDic;
    
    NSData * imgData;
    int itemNums;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
//@property (strong, nonatomic) UITextView *textView;
//@property (strong, nonatomic) UIImageView *imgView;

-(void)updateUI:(int)dataCount;



@end
