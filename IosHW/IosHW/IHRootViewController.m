//
//  IHRootViewController.m
//  IosHW
//
//  Created by Claire Hsu on 2014/8/13.
//  Copyright (c) 2014年 livebricks. All rights reserved.
//

#import "IHRootViewController.h"

@interface IHRootViewController ()

@end

@implementation IHRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    fullScreen = [[UIScreen mainScreen] bounds];
    self.scrollView = [[UIScrollView alloc]initWithFrame:fullScreen];
    self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.delegate = self;
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.contentSize = CGSizeMake(fullScreen.size.width*3, fullScreen.size.height);
    [self.view addSubview:self.scrollView];
    
    int defaultPageControlHeight = 36;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, fullScreen.size.height-defaultPageControlHeight, fullScreen.size.width, defaultPageControlHeight)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:self.pageControl];
    
    
    UIImageView *imgView = [[UIImageView alloc]
                            initWithFrame:CGRectMake(0, 0, fullScreen.size.width, 200)];
    imgView.image = [UIImage imageNamed:@"asset@2x.png"];
    [self.scrollView addSubview:imgView];
    
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 200, fullScreen.size.width, fullScreen.size.height-200)];
    textView.text = @"description";
    textView.backgroundColor = [UIColor blueColor];
    textView.editable = NO;
    [self.scrollView addSubview:textView];

    
    
    
}

#pragma mark - UIScrollView delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    //NSLog(@"page number:%d",page);
    self.pageControl.currentPage = page;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
