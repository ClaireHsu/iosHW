
#Claire assignment1


##為什麼
###interface
`@interface IHRootViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate>{`

`@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIImageView *imgView;`

###implementation

`UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
[self.scrollView addGestureRecognizer:swipeRecognizer];`
                
`-(void)swipeGesture:(UISwipeGestureRecognizer *)gesture{
    self.textView.selectable = NO;
}`

`fullScreen = [[UIScreen mainScreen] bounds];`

`self.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;`

`UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self.scrollView action:@selector(clickImgView:)];
        [self.imgView addGestureRecognizer:tapRecognizer];`



###為什麼IHDataOperator要分出來？
`+(NSDictionary *)getDicFromURL:(NSString *)jsonURL{
    NSError *jsonError = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&jsonError];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonError];
    return jsonDic;}`

