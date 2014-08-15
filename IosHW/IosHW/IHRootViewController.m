//
//  IHRootViewController.m
//  IosHW
//
//  Created by Claire Hsu on 2014/8/13.
//  Copyright (c) 2014年 livebricks. All rights reserved.
//

#import "IHRootViewController.h"
#import "IHAppDelegate.h"

#define JSON_URL @"http://www.indexbricks.com/data/get_update.php?function_code=Intro&store=livebricks&version=0&language=TW"

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
    
    // Get Data
    
    getDataDic = [IHDataOperator getDicFromURL:JSON_URL];
    //NSLog(@"data:%@",[getDataDic description]);
    NSArray *itemsArr = [getDataDic objectForKey:@"livebricks"];
    //NSLog(@"items:%@",[itemsArr description]);
    itemNums = [itemsArr count];
//    for (itemsDic in itemsArr) {
//        NSLog(@"img_path:%@",[itemsDic objectForKey:@"image_filepath"]);
//    }
    
    
    fullScreen = [[UIScreen mainScreen] bounds];
    self.scrollView = [[UIScrollView alloc]initWithFrame:fullScreen];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.contentSize = CGSizeMake(fullScreen.size.width*itemNums, fullScreen.size.height);
    [self.view addSubview:self.scrollView];
    
    int defaultPageControlHeight = 36;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, fullScreen.size.height-defaultPageControlHeight, fullScreen.size.width, defaultPageControlHeight)];
    self.pageControl.numberOfPages = itemNums;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:self.pageControl];
    
    int imgViewHeight = 200;
    for (int i =0; i<itemNums; i++) {
        itemsDic = [itemsArr objectAtIndex:i];
        self.imgView = [[UIImageView alloc]
                                initWithFrame:CGRectMake(i*fullScreen.size.width, 20, fullScreen.size.width, imgViewHeight)];
        //imgView.image = [UIImage imageNamed:@"asset@2x.png"];
        NSString *imgUrlStr = [itemsDic objectForKey:@"image_url"];
        self.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self.scrollView action:@selector(clickImgView:)];
        [self.imgView addGestureRecognizer:tapRecognizer];
        
        [self.scrollView addSubview:self.imgView];
        
        
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(i*fullScreen.size.width, imgViewHeight+20, fullScreen.size.width, fullScreen.size.height-imgViewHeight-38)];
        self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.textView.text = [itemsDic objectForKey:@"description"];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.editable = NO;
        self.textView.scrollEnabled = YES;
        //textView.selectable = NO;
        
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
        [self.scrollView addGestureRecognizer:swipeRecognizer];
        
        
        
        [self.scrollView addSubview:self.textView];
    }
  
}

#pragma mark - Gresure methods
-(void)clickImgView:(UITapGestureRecognizer *)gesture{
    NSLog(@"img clicked!");
}


-(void)swipeGesture:(UISwipeGestureRecognizer *)gesture{
    self.textView.selectable = NO;
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
