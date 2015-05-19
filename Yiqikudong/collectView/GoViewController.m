//
//  GoViewController.m
//  YiQiWeb
//
//  Created by Wendy on 14/11/21.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import "GoViewController.h"
#import "ShareSheet.h"
#import "ShareViewController.h"
#import "Common.h"

@interface GoViewController ()

@end

@implementation GoViewController{
    Collection *item;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backbutton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backbutton;
    
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    btnMore.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    UIWebView*webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [[UIScreen mainScreen] bounds].size.height)];
    webview.tag = 1000;
    webview.scalesPageToFit = YES;
    webview.delegate= self;
    webview.scrollView.delegate = self;
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:self.cUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
    
    item = [[Collection alloc] init];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIWebView*webview = (UIWebView*)[self.view viewWithTag:1000];
//    NSLog(@"%f",webview.scrollView.contentOffset.y);
    if (webview.scrollView.contentOffset.y < -64||webview.scrollView.contentOffset.y > webview.scrollView.contentSize.height-SCREENHEIGHT+[UIApplication sharedApplication].statusBarFrame.size.height-20)
    {
        scrollView.scrollEnabled = NO;
    }else
    {
        scrollView.scrollEnabled = YES;
    }
}
//webview加载结束调用的代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    NSLog(@"1213");
//    if (webView.canGoBack)
//    {
        //        NSLog(@"1213323");
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        btnCancel.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = btnCancel;
//    }
    ReminderView *view = [ReminderView reminderView];
    [view removeFromSuperview];
    
    //显示标题
    if (webView!=nil)
    {
         NSString *showTitle = [webView stringByEvaluatingJavaScriptFromString:@"$('p').filter('top_title').val()"];
        if (showTitle.length == 0) {
            showTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        if ([showTitle hasPrefix:@"亿启酷动"])
        {
            self.navigationItem.title = @"亿启酷动";
//            self.navigationItem.leftBarButtonItem = nil;
        }else
        {
            self.navigationItem.title = showTitle;
        }
        
        NSString *webUrl = webView.request.URL.absoluteString;
        NSRange range = [webUrl rangeOfString:@"17ll.com/apply/match-pic"];
        NSString *imgUrl;
        if (range.length > 0) {//获取参赛者图片
            imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"$(\"#giftPic\").find(\"div\").css( \"backgroundImage\")"];
            NSRange srange = [imgUrl rangeOfString:@"url"];
            if (srange.length > 0) {
                imgUrl = [imgUrl substringFromIndex:srange.location+srange.length+1];
                imgUrl = [imgUrl substringToIndex:imgUrl.length-1];
            }
        }
        else{//获取第一张图片
            imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[0].src;"];
        }
        if (imgUrl.length > 0) {
            //获取网页中第一张image
            item.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        }
        else{
            //如果网页没有图片，就截图
            CGRect r = [UIScreen mainScreen].applicationFrame;
            r.origin.y = r.origin.y + 44 ;
            UIGraphicsBeginImageContext(self.view.frame.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            UIRectClip(r);
            [self.view.layer renderInContext:context];
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            item.imgData = UIImageJPEGRepresentation(theImage,1.0);
            UIGraphicsEndImageContext();
        }
    }
    //    NSLog(@"%@",item.imgData);
    if (webView!=nil)
    {
        item.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        NSLog(@"==%@",item.title);
        item.url = webView.request.URL.absoluteString;
    }

    
}

//webview加载错误调用的代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Common showMessage:@"加载失败" withView:self.view];
     ReminderView *view = [ReminderView reminderView];
    [view removeFromSuperview];
}
//webview加载开始调用的代理
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ReminderView*view = [ReminderView reminderView];
    [self.view addSubview:view];
    
    self.title =@"";
//    if (webView.canGoBack) {
        UIBarButtonItem*backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backOne)];
        backBtn.tintColor = WHITECOLOR;
        self.navigationItem.leftBarButtonItem = backBtn;
//    }
    
    
}
-(void)backOne
{
    //    if (webview.canGoBack)
    //    {
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    [webView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
    //    }
}
//返回按钮触发事件
-(void)back
{
//    NSLog(@"31");
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    if (webView.canGoBack)
    {
        [webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//更多按钮触发事件
-(void)more
{
    ShareSheet*shareView = [ShareSheet shareWeiboView];
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    shareView.webview = webView;
    shareView.item = item;
    shareView.imageData = item.imgData;
    [self.navigationController.view addSubview:shareView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
