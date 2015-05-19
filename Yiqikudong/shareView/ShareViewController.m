//
//  ShareViewController.m
//  YiQiWeb
//
//  Created by BK on 14/11/19.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "ShareViewController.h"
#import "AppDelegate.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize shareContent,shareKind,imageData,imageUrl,shareUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    NSLog(@"view的y==%f",self.view.frame.origin.y);
    self.title = [NSString stringWithFormat:@"分享到%@",shareKind];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    btnMore.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    UILabel*logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH, 40)];
    logoLabel.tag = 1300;
    if ([shareKind isEqualToString:@"腾讯微博"])
    {
        CGColorRef colorref1 = CGColorCreate(colorSpace, (CGFloat[]){0.365,0.718,0.945,1});
        logoLabel.layer.backgroundColor = colorref1;
        UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 140, 40)];
        logoImage.image = [UIImage imageNamed:@"logo2"];
        [logoLabel addSubview:logoImage];
        CGColorRelease(colorref1);
    }else if ([shareKind isEqualToString:@"新浪微博"])
    {
        logoLabel.frame = CGRectMake(0, 44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH, 48);
        UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 140, 40)];
        logoImage.image = [UIImage imageNamed:@"weibologo"];
        [logoLabel addSubview:logoImage];
    }else if ([shareKind isEqualToString:@"QQ空间"])
    {
        CGColorRef colorref1 = CGColorCreate(colorSpace, (CGFloat[]){0.365,0.718,0.945,1});
        logoLabel.layer.backgroundColor = colorref1;
        UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 40, 40)];
        logoImage.image = [UIImage imageNamed:@"qqkongjian"];
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImage.frame.origin.x+
                                                                      logoImage.frame.size.width+10, 0, 100, 40)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"QQ空间";
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [logoLabel addSubview:titleLabel];
        
        [logoLabel addSubview:logoImage];
        CGColorRelease(colorref1);
    }
    [self.view addSubview:logoLabel];
    
    
    UITextView*textView = [[UITextView alloc]initWithFrame:CGRectMake(5, logoLabel.frame.size.height+70, SCREENWIDTH-10, SCREENHEIGHT-220-64)];
    textView.tag = 1000;
    self.automaticallyAdjustsScrollViewInsets = NO;
    textView.text = shareContent;
    textView.layer.borderWidth = 1;
    textView.delegate = self;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:17];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [textView becomeFirstResponder];
//    });
    
    [self.view addSubview:textView];

    //测试文字高度
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width-10, textView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%f",rect.size.height);
            textView.frame = CGRectMake(15, logoLabel.frame.size.height+70, SCREENWIDTH-30, rect.size.height+40);
            UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, textView.frame.size.height+122, 90, 90)];
            imageView.tag = 1100;
            imageView.image = [UIImage imageWithData:imageData];
            [self.view addSubview:imageView];
        });
    });

    AppDelegate*appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];
    
    NSString *appid = @"222222";//1103511856
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                            andDelegate:appdelegate];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back1) name:@"sendSuccess" object:nil];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    UILabel*logolabel = (UILabel*)[self.view viewWithTag:1300];
    UIImageView*image = (UIImageView*)[self.view viewWithTag:1100];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width-10, textView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    NSLog(@"%f",rect.size.height);
    textView.frame = CGRectMake(15, logolabel.frame.size.height+70, SCREENWIDTH-30, rect.size.height+40);
    image.frame = CGRectMake(15, textView.frame.size.height+122, 90, 90);
    
}

//取消返回按钮
-(void)back
{
    if ([shareUrl isEqualToString:@"(null)"]||shareUrl==nil||shareUrl.length==0)
    {
        [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1 styleName:@"JDStatusBarStyleError"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)back1
{
    [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    [self.navigationController popViewControllerAnimated:YES];
}
//发送按钮
-(void)send
{
    UITextView*textView = (UITextView*)[self.view viewWithTag:1000];
    [textView resignFirstResponder];
    AppDelegate*appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([shareKind isEqualToString:@"新浪微博"])
    {
        NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
        if ([user objectForKey:@"SinaToken"])
        {
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
            NSString *url;
            NSDictionary*params;
            url = @"https://upload.api.weibo.com/2/statuses/upload.json";
            params=@{@"status":shareContent,@"pic":imageData};
            [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaToken"] url:url httpMethod:@"POST" params:params delegate:appdelegate withTag:@"1000"];
        }else
        {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            [WeiboSDK sendRequest:request];
        }
    }else if ([shareKind isEqualToString:@"腾讯微博"])
    {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        if ([[WbApi getWbApi]getToken].accessToken)
        {
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        [[WbApi getWbApi] loginWithDelegate:appdelegate andRootController:appdelegate.window.rootViewController];
    }else if ([shareKind isEqualToString:@"QQ空间"])
    {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [tencentOAuth authorize:permissions];
    }
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
