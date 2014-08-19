//
//  IHRootViewController.m
//  IosHW
//
//  Created by Claire Hsu on 2014/8/13.
//  Copyright (c) 2014年 livebricks. All rights reserved.
//

#import "IHRootViewController.h"


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
    //getDataDic = [IHDataOperator getDicFromURL:JSON_URL];
    
    
    //NSLog(@"data:%@",[getDataDic description]);
    
    fullScreen = [[UIScreen mainScreen] bounds];
    self.scrollView = [[UIScrollView alloc]initWithFrame:fullScreen];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView setPagingEnabled:YES];
    

    indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = self.scrollView.center;
    [indicatorView startAnimating];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:indicatorView];
    
    
    //Async
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JSON_URL]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        jsonDataAll = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self updateUI:[jsonDataAll count]];
            
        });
        
        
    }];
    
   
    
}



-(void)updateUI: (int)dataCount{
    NSLog(@"dic nums:%d",dataCount);
    //self.scrollView.backgroundColor = [UIColor whiteColor];
    [indicatorView removeFromSuperview];
    
    
    NSArray *itemsArr = [jsonDataAll objectForKey:@"livebricks"];
    //NSLog(@"items:%@",[itemsArr description]);
    itemNums = [itemsArr count];
    //    for (itemsDic in itemsArr) {
    //        NSLog(@"img_path:%@",[itemsDic objectForKey:@"image_filepath"]);
    //    }
    
    
    self.scrollView.contentSize = CGSizeMake(fullScreen.size.width*itemNums, fullScreen.size.height);
    [self.view addSubview:self.scrollView];
    
    int defaultPageControlHeight = 10;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, fullScreen.size.height-defaultPageControlHeight, fullScreen.size.width, defaultPageControlHeight)];
    self.pageControl.numberOfPages = itemNums;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:self.pageControl];
    
    int imgViewHeight = 200;
    for (int i =0; i<itemNums; i++) {
        itemsDic = [itemsArr objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc]
                        initWithFrame:CGRectMake(i*fullScreen.size.width, 20, fullScreen.size.width, imgViewHeight)];
        //imgView.image = [UIImage imageNamed:@"asset@2x.png"];
        imgView.backgroundColor = [UIColor grayColor];
        
        
        NSString *imgUrlStr = [itemsDic objectForKey:@"image_url"];
        
        //Set default img
        imgView.image = [UIImage imageNamed:@"asset@2x.png"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:imgView];

        
        //Check img file in Cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        NSString *imgFilePath = [itemsDic objectForKey:@"image_filepath"];
        NSString *catheImgPath = [cachesDirectory stringByAppendingPathComponent:imgFilePath];
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:catheImgPath]) {
            
            //Download img file __Async
            
            [self downloadImgFromURL:[NSURL URLWithString:imgUrlStr] cacheImgPath:catheImgPath compeledBlock:^(BOOL successed, UIImage *image) {
                if (successed) {
                    NSLog(@"img_NO.%d",i);
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        imgView.image = image;
                        
                    });
                   
                    
                }
            }];
            
        }else{
            
            imgData = [NSData dataWithContentsOfFile:catheImgPath];
            imgView.image = [UIImage imageWithData:imgData];
            
        }
        
  
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgView:)];
        [imgView addGestureRecognizer:tapRecognizer];
        
        
        
        
        
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(i*fullScreen.size.width, imgViewHeight+20, fullScreen.size.width, fullScreen.size.height-imgViewHeight-38)];
        textView.backgroundColor = [UIColor grayColor];
        textView.dataDetectorTypes = UIDataDetectorTypeAll;
        textView.text = [itemsDic objectForKey:@"description"];
        textView.backgroundColor = [UIColor whiteColor];
        textView.editable = NO;
        textView.scrollEnabled = YES;
        //textView.selectable = NO;
        

        [self.scrollView addSubview:textView];
    }

    
   
}

-(void)downloadImgFromURL:(NSURL *)url cacheImgPath:(NSString *)cacheImgPath compeledBlock:(void (^) (BOOL successed,UIImage *image))compeledBlock{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (!connectionError) {
                                   imgData = [NSData dataWithContentsOfURL:url];
                                   [imgData writeToFile:cacheImgPath atomically:YES];
                                   
                                   
                                       
                                       UIImage *img = [[UIImage alloc]initWithData:imgData];
                                       compeledBlock(YES,img);
                                   
                        
                                   
                               }else{
                                   compeledBlock(NO,nil);
                               }
                           }];

}

#pragma mark - Gresure methods
-(void)clickImgView:(UITapGestureRecognizer *)gesture{
    NSLog(@"img clicked!");
}




#pragma mark - UIScrollView delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //textView.selectable = NO;
    
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
