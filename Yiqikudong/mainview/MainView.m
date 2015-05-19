//
//  MainView.m
//  YiQiWeb
//
//  Created by BK on 14/11/18.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "MainView.h"
#import "CollectionsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RecordingView.h"
#import "Common.h"
#import "HomeViewController.h"

@interface MainView ()

@end

@implementation MainView{
    Collection *item;
    NSString* netFlag;
    NSURLRequest*errorRequest;
    //    ShareSheet*shareview;
}
@synthesize webview;
-(void)dealloc
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    webView.delegate = nil;
    webView = nil;
}
-(void)onComplete:(BDVRDataUploader *)dataUploader error:(NSError *)error
{
    NSLog(@"dsd");
}
-(void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults
{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
}
- (void)viewDidLoad {
    //    NSLog(@"%@",NSHomeDirectory());
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.title = @"亿启酷动";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                   nil];
//    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%f",[UIApplication sharedApplication].statusBarFrame.size.height] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//    [alert show];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"SCREENHEIGHT==%f",SCREENHEIGHT);
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, SCREENHEIGHT)];
    webview.tag = 1000;
    webview.delegate= self;
//    webview.paginationBreakingMode = UIWebPaginationBreakingModePage;
    webview.scrollView.delegate = self;
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:APPURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
    webview.scalesPageToFit = YES;
    [webview loadRequest:request];
    
    //    errorRequest = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:@"http://17ll.com"] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
//    webview.contentMode
    [self.view addSubview:webview];

    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    btnMore.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    item = [[Collection alloc] init];
    noteArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushCollections" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCollections) name:@"pushCollections" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushShare:) name:@"pushShare" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"camera" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(camera) name:@"camera" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXNOTInstalled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXNOTInstalled) name:@"WXNOTInstalled" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"map" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMap) name:@"map" object:nil];
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"voice" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVoice) name:@"voice" object:nil];
//    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"face" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFace) name:@"face" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"video" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVideo) name:@"video" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"flashlight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFlashLight) name:@"flashlight" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"record" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRecord) name:@"record" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendnote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendnote) name:@"sendnote" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"chat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushchat) name:@"chat" object:nil];
    
//    static int flagupdate = 0;
//    if (flagupdate == 0)
//    {
//        flagupdate = 1;
//        //452186370
//        NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID];
//        NSURL*url = [NSURL URLWithString:URL];
//        //
//        NSURLRequest*request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
//        //创建get异步请求
//        getConnection = [NSURLConnection connectionWithRequest:request delegate:self];
//    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //        NSLog(@"%@",dict);
//        //        NSString*strurl = [NSString stringWithFormat:@"http://192.168.0.62/blog/apply/AppInterface/sqData.asp?wxname=%@&purl=%@&openid=%@&address=%@",[NSString stringWithFormat:@"%@",[dict objectForKey:@"nickname"]],[NSString stringWithFormat:@"%@",[NSURL URLWithString:[dict objectForKey:@"headimgurl"]]],[NSString stringWithFormat:@"%@",[dict objectForKey:@"openid"]],[NSString stringWithFormat:@"%@,%@",[dict objectForKey:@"province"],[dict objectForKey:@"city"]]];
//        //        http://192.168.0.62/blog/apply20150317/AppInterface/yiqiVideoInterface.asp?sign=type&tid=1&typ=1&pnum=1
//        NSString*strurl = [NSString stringWithFormat:@"http://192.168.0.129/wap/apply20150317/AppInterface/yiqiVideoInterface.asp?sign=sear&kw=%@&pnum=1",@"十一"];
//        NSURL*url = [NSURL URLWithString:[strurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"%@==%@",strurl,url);
//        NSURLRequest*request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
//        NSHTTPURLResponse*response = nil;
//        NSError*error = nil;
//        NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
//            NSString*str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            //                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"str===%@",str);
//                        NSDictionary*array = [str objectFromJSONString];
//                        NSLog(@"array = %@",array);
//                        NSArray*array1 = [array objectForKey:@"info"];
//                        NSLog(@"%@",array1);
//            
//            //            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",array] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            //            [alert show];
//        });
//    });
//    [self uploadVoice];
    
//    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
//    label.numberOfLines = 0;
//    label.text = [NSString stringWithFormat:@"%@",@"Jhh\nGood night to\nThe first "];
//    label.backgroundColor = [UIColor blackColor];
//    label.textColor = WHITECOLOR;
//    [self.view addSubview:label];
}
-(void)uploadVoice
{
    //            NSURL*url = info.url;
    NSData*data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"喜欢你" ofType:@"mp3"]]];
    
    if (manager==nil)
    {
        //                                http://hzwkw.wicp.net/UploadAndDownload/
    http://192.168.0.62/blog/apply20150317/AppInterface/yiqiVideo_up_save.asp?tid=3&title=nihao&dat=
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.129/wap/apply20150317/AppInterface"]];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //            NSDictionary*parameters = @{@"yzm":@"2z82"};
    NSDictionary*parameters = @{@"tid":@"3",@"title":@"nihao",@"sign":@"mp3",@"uid":@"212123"};
    
    //  action
    //            AFHTTPRequestOperation*uploadRequest = [manager POST:@"upload.asp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //                NSLog(@"%@===---%@",operation,responseObject);
    //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //                NSLog(@"失败");
    //            }];
    UIImage*image = [UIImage imageNamed:@"takeVideo"];
    NSData*data2 = UIImageJPEGRepresentation(image, 1);
            AFHTTPRequestOperation*uploadRequest = [manager POST:@"yiqiVideo_up_save.asp" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:data name:@"dat" fileName:[NSString stringWithFormat:@"%@",[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"喜欢你" ofType:@"mp3"]]] mimeType:@"audio/mp3"];
                [formData appendPartWithFileData:data2 name:@"pic" fileName:[[NSBundle mainBundle] pathForResource:@"pic" ofType:@"png"] mimeType:@"image/png"];
                //                audio/mp3 video/mpeg4
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@===---%@",operation,responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败");
            }];
            
//            AFHTTPRequestOperation*operationRequest = uploadRequest;
            [uploadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//                NSError*error = nil;
                //                NSString*str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
//                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
                NSString*str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"====%@",str);
                NSDictionary*dict = [str objectFromJSONString];
                NSLog(@"获取到的数据为：===%@",dict);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [uploadRequest setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"%lu,%lld,%lld",(unsigned long)bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
            }];
            [uploadRequest start];
    
}

#pragma mark 聊天
-(void)pushchat
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hide" object:nil];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"聊天界面"]isEqualToString:@"否"])
    {
        ChatView*chatView = [[ChatView alloc]init];
        [self.navigationController pushViewController:chatView animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark 短信
-(void)sendnote
{
//    if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized) {
//        return ;
//    }
//    //判断短信功能能否调用
//    if ([MFMessageComposeViewController canSendText]) {
//        MFMessageComposeViewController*messageController=[[MFMessageComposeViewController alloc]init];
//        messageController.body=[NSString stringWithFormat:@"%@,%@",item.title,item.url];
//        messageController.messageComposeDelegate=self;
//        [self presentViewController:messageController animated:YES completion:^{
//            
//        }];
//    }else{
//        ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"短信功能无法调用"];
//        [self.view addSubview:remiderView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationDuration:0.5];//动画运行时间
//            remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//            [UIView commitAnimations];//提交动画
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [remiderView removeFromSuperview];
//            });
//        });
//        ReminderView*view = [ReminderView reminderView];
//        [view removeFromSuperview];
//    }
    //取得本地通信录名柄
//    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
////    NSMutableArray *arrayNames = [NSMutableArray array];
////    NSMutableArray *sections = [NSMutableArray array];
////    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    
////    BOOL flag = false;
//    //取得本地所有联系人记录
//    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
//    NSLog(@"%lu",(unsigned long)[tmpPeoples count]);
//    NoteBaseView*noteBaseView = [[NoteBaseView alloc]init];
//    noteBaseView.contentStr = [NSString stringWithFormat:@"%@%@",item.title,item.url];
//    [self.navigationController pushViewController:noteBaseView animated:YES];
    
//    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
//    peoplePicker.peoplePickerDelegate = self;
//    [self presentViewController:peoplePicker animated:YES completion:^{
//        
//    }];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://13710308460"]];
    [noteArray removeAllObjects];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(id tmpPerson in tmpPeoples)
    {
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        NSInteger valuesCount = 0;
        if (tmpPhones != nil) valuesCount = ABMultiValueGetCount(tmpPhones);
        if (valuesCount == 0) {
            CFRelease(tmpPhones);
            continue;
        }
        //获取电话号码和email
        NSString*str;
        for (NSInteger k = 0; k < valuesCount; k++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(tmpPhones, k);
            str = (__bridge NSString*)value;
            CFRelease(value);
        }
        CFRelease(tmpPhones);
        if (tmpFirstName ==nil&&tmpLastName!=nil)
        {
            [noteArray addObject:[NSString stringWithFormat:@"%@/%@",tmpLastName,str]];
        }else if (tmpFirstName!=nil&&tmpLastName==nil) {
            [noteArray addObject:[NSString stringWithFormat:@"%@/%@",tmpFirstName,str]];
        }else if (tmpFirstName!=nil&&tmpLastName!=nil){
            [noteArray addObject:[NSString stringWithFormat:@"%@%@/%@",tmpFirstName,tmpLastName,str]];
        }
        //        NSLog(@"%@%@==%@",tmpFirstName,tmpLastName,str);
    }
    CFRelease(addressBook);
    NoteView*noteview = [[NoteView alloc]init];
    noteview.noteArray = noteArray;
    noteview.contentStr = [NSString stringWithFormat:@"%@%@",item.title,item.url];
    [self.navigationController pushViewController:noteview animated:YES];

}


#pragma mark 推送到录音界面
-(void)pushRecord
{
//    FindView*findview = [[FindView alloc]init];
    HomeViewController *findview = [[HomeViewController alloc] init];
    UINavigationController*nav_find = [[UINavigationController alloc]initWithRootViewController:findview];
//    findview.title = @"首页";

    nav_find.tabBarItem.title = @"发现";//设置标签栏标题
    nav_find.tabBarItem.selectedImage = [UIImage imageNamed:@"Action_Copy@2x"];//选中后图标
    nav_find.tabBarItem.image = [UIImage imageNamed:@"Action_Copy@2x"];//设置未选中时图标
    
    MineView*mineview = [[MineView alloc]init];
    UINavigationController*nav_mine = [[UINavigationController alloc]initWithRootViewController:mineview];
    nav_mine.tabBarItem.title = @"我的";
    nav_mine.tabBarItem.selectedImage = [UIImage imageNamed:@"Action_Copy@2x"];//选中后图标
    nav_mine.tabBarItem.image = [UIImage imageNamed:@"Action_Copy@2x"];//设置未选中时图标
    
    RecodingBaseView*recordingview =[[RecodingBaseView alloc]init];
    recordingview.tabBarItem.title = @"录制";
    recordingview.tabBarItem.selectedImage = [UIImage imageNamed:@"Action_Copy@2x"];//选中后图标
    recordingview.tabBarItem.image = [UIImage imageNamed:@"Action_Copy@2x"];//设置未选中时图标
    
    UITabBarController*tab = [[UITabBarController alloc]init];
    tab.viewControllers = [NSArray arrayWithObjects:nav_find,nav_mine,recordingview, nil];
    tab.tabBar.selectedImageTintColor = [UIColor colorWithRed:240/255.0 green:94/255.0 blue:85/255.0 alpha:1];
    tab.delegate = self;
//    [self.navigationController.navigationBar setHidden:YES];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    [self.navigationController pushViewController:tab animated:YES];
    [self presentViewController:tab animated:YES completion:^{
        
    }];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[RecodingBaseView class]])
    {
        [tabBarController setHidesBottomBarWhenPushed:YES];
        RecordingView*recordingview = [[RecordingView alloc]init];
        [tabBarController presentViewController:recordingview animated:YES completion:^{
            
        }];
        return NO;
    }
    return YES;
}
#pragma mark 推送到手电筒界面
-(void)pushFlashLight
{
    FlashLightView*flashLightView = [[FlashLightView alloc]init];
    [self.navigationController pushViewController:flashLightView animated:YES];
}
#pragma mark 推送到地图页
-(void)pushMap
{
    //    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"地图标记"];
    MapViewController*mapView = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapView animated:YES];
}
//网络变化
-(void)networkChange:(NSNotification*)notification
{
    Reachability*reachability =(Reachability*)[notification object];
    
    //NSLog(@"%u,%u",[reachability currentReachabilityStatus],[reachability connectionRequired]);
    //生成警示框,网络环境发生变化时弹出
    if ([reachability connectionRequired]==YES)
    {
        [Common showMessage:@"无网络连接，请检查网络" withView:self.view];
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"无网络连接，请检查网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//        [alert show];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [alert dismissWithClickedButtonIndex:0 animated:YES];
//        });
    }else
    {
        if (netFlag!=nil&&![netFlag isEqualToString:[NSString stringWithFormat:@"%u",[reachability connectionRequired]]])
        {
            [webview loadRequest:errorRequest];
            UIView*view = (UIView*)[self.view viewWithTag:1003];
            [view removeFromSuperview];
        }
    }
    netFlag = [NSString stringWithFormat:@"%u",[reachability connectionRequired]];
    
}
//WXNOTInstalled微信未安装
-(void)WXNOTInstalled
{
    //    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的设备尚未安装微信,请先下载微信客户端。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //
    //    [alert show];
//    SendAuthReq* req =[[SendAuthReq alloc ] init ] ;
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    [WXApi sendAuthReq:req viewController:self delegate:self];
}
#pragma mark 推送到扫一扫页
-(void)camera
{
    CameraView*camera = [[CameraView alloc]init];
    camera.kind = @"扫一扫";
    [self.navigationController pushViewController:camera animated:YES];
}

#pragma mark 推送到收藏页
-(void)pushCollections
{
    CollectionsViewController *viewController = [[CollectionsViewController alloc] initWithNibName:@"CollectionsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 推送到人脸识别页
-(void)pushFace
{
    [BaiduOAuthSDK initWithAPIKey:API_KEY appId:API_ID];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
    
    CameraView*camera = [[CameraView alloc]init];
    camera.kind = @"人脸识别";
    [self.navigationController pushViewController:camera animated:YES];
    //    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([BaiduOAuthSDK isUserTokenValid])
        {
            [self alreadyLogin];
        }else
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            [BaiduOAuthSDK authorizeWithTargetViewController:self scope:@"basic,super_msg,netdisk,pcs_doc,pcs_video" andDelegate:self];
        }
    });
    
}
-(void)alreadyLogin
{
    [BaiduOAuthSDK apiRequestWithUrl:@"https://openapi.baidu.com/rest/2.0/passport/users/getLoggedInUser" httpMethod:@"POST" params:nil andDelegate:self];
}
-(void)loginDidSuccessWithTokenInfo:(BaiduTokenInfo *)tokenInfo
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self alreadyLogin];
    [[NSUserDefaults standardUserDefaults] setObject:tokenInfo.accessToken forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)authorizationCodeSuccessWithCode:(NSString *)code
{
    
}
-(void)authorizationCodeWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
-(void)loginDidCancel
{
    //    [self becomeFirstResponder];
}
-(void)loginFailedWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
- (void)apiRequestDidFinishLoadWithResult:(id)result
{
    //    NSLog(@"====");
    NSMutableString *resultStr = [NSMutableString stringWithFormat:@""];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDic = (NSDictionary *)result;
        for (NSString *key in [resultDic keyEnumerator]) {
            
            [resultStr appendFormat:@"%@:%@\n",key,[resultDic objectForKey:key]];
        }
    } else {
        NSArray *resultArr = (NSArray *)result;
        for (NSDictionary *resultItem in resultArr) {
            for (NSString *key in [resultItem keyEnumerator]) {
                
                [resultStr appendFormat:@"%@:%@\n",key,[resultItem objectForKey:key]];
            }
        }
    }
    return;
}

- (void)apiRequestDidFailLoadWithError:(NSError*)error
{
//    [self showMessage:[error localizedDescription]];
    [Common showMessage:[error localizedDescription] withView:self.view];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alertView show];
    return;
}
#pragma mark 推送到视频页
-(void)pushVideo
{
    //        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    //            UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
    //            imagePicker.delegate=self;
    //            [imagePicker setEditing:YES animated:YES];//允许编辑
    //    //        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    //            imagePicker.videoQuality =UIImagePickerControllerQualityTypeHigh;
    //            imagePicker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*)kUTTypeMovie,nil];
    //            [self presentViewController:imagePicker animated:YES completion:^{
    //                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //            }];
    //        }
    //        else{
    //            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法打开相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //            [alert show];
    //            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //        }
    //    DownOrUploadView*video = [[DownOrUploadView alloc]init];
    //    [self.navigationController pushViewController:video animated:YES];
    

    VideoViewController*viewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma mark 推送到分享页
-(void)pushShare:(NSNotification*)notif
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ShareViewController*shareView = [[ShareViewController alloc]init];
        shareView.shareContent = [[notif userInfo]objectForKey:@"shareContent"];
        shareView.shareKind =[[notif userInfo]objectForKey:@"shareKind"];
        shareView.imageData = [[notif userInfo] objectForKey:@"imageData"];
        shareView.shareUrl = [NSString stringWithFormat:@"%@",[[notif userInfo] objectForKey:@"shareUrl"]];
        [self.navigationController pushViewController:shareView animated:YES];
    });
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (webview.scrollView.contentOffset.y < -64||webview.scrollView.contentOffset.y > webview.scrollView.contentSize.height-SCREENHEIGHT+TbarHeight+45)
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
//    NSLog(@"%@",webView.request.URL);
    if (webView.canGoBack&&![webView.request.URL isEqual:[NSURL URLWithString:APPURL]])
    {
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        btnCancel.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = btnCancel;
    }else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    ReminderView *view = [ReminderView reminderView];
    [view removeFromSuperview];
    
    //显示标题
    if (webview!=nil)
    {
         NSString *showTitle = [webView stringByEvaluatingJavaScriptFromString:@"$('p').filter('top_title').val()"];
        if (showTitle.length == 0) {
            showTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        if ([showTitle hasPrefix:@"亿启酷动"])
        {
            self.title = @"亿启酷动";
        }else
        {
            self.title = showTitle;
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
    
    if (webview!=nil)
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
//    ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"加载失败"];
//    [self.view addSubview:remiderView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.5];//动画运行时间
//        remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//        [UIView commitAnimations];//提交动画
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [remiderView removeFromSuperview];
//        });
//    });
    NSLog(@"error == %@",error);
//    webView.delegate = nil;
//    [webView stopLoading];
    ReminderView*view = [ReminderView reminderView];
    [view removeFromSuperview];

}
//webview加载开始调用的代理
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ReminderView*view = [ReminderView reminderView];
    [self.view addSubview:view];

    if (webView.loading)
    {
        self.title = @"";
    }
    if (webview.canGoBack) {
        UIBarButtonItem*backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backOne)];
        backBtn.tintColor = WHITECOLOR;
        self.navigationItem.leftBarButtonItem = backBtn;
    }
    
    
}
-(void)backOne
{
//    if (webview.canGoBack)
//    {
        [webview stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
//    }
}
//返回按钮触发事件
-(void)back
{
    if (webview.canGoBack)
    {
        [webview goBack];
    }
}
//更多按钮触发事件
-(void)more
{
    //把webview中的键盘回收。
    if (webview!=nil)
    {
        [webview stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
    }
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    ShareSheet*shareview = [ShareSheet shareWeiboView];
    [shareview becomeFirstResponder];
    shareview.webview = webview;
    shareview.item = item;
    
    shareview.imageData = item.imgData;
    
    [self.navigationController.view addSubview:shareview];
}
#pragma mark - Navigation Controller Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    BaseAnimation *animationController;
    SlideAnimation *slideAnimationController = [[SlideAnimation alloc]init];
    animationController = slideAnimationController;
    switch (operation) {
        case UINavigationControllerOperationPush:
            animationController.type = AnimationTypePresent;
            return  animationController;
        case UINavigationControllerOperationPop:
            animationController.type = AnimationTypeDismiss;
            return animationController;
        default: return nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 更新提示

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });

}
//接收到请求响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    getData = [[NSMutableData alloc]init];
}
//连接建立,开始接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [getData appendData:data];
}
//数据加载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *results = [[NSString alloc] initWithBytes:[getData bytes] length:[getData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [results objectFromJSONString];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
         releaseInfo = [infoArray objectAtIndex:0];
//        NSLog(@"%@",infoDic);
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
            if (![lastVersion isEqualToString:currentVersion]) {
//                NSString*trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
//                NSLog(@"%@",trackViewURL);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                alert.tag = 10000;
                [alert show];
            }
    }
}
//请求失败触发事件
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection == getConnection)
    {
        NSLog(@"请求失败,error=%@",error);
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==0) {
            
            [self grade];
        }
    }
}
#pragma mark 给我评分
-(void)grade
{
//    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
//    [storeProductViewController setDelegate:self];
//    NSLog(@"%@",storeProductViewController);
    ReminderView*reminder = [ReminderView reminderView1];
    [self.view addSubview:reminder];
    //下面字典应该填写自己的app ID
//    __block int flag = 0;
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, queue, ^{
//        [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APP_ID}
//                                              completionBlock:^(BOOL result, NSError *error) {
//                                                  if (error) {
//                                                      NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
//                                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                                          [reminder removeFromSuperview];
//                                                          flag = 0;
//                                                      });
//                                                      
//                                                  } else {
//                                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                                          [self presentViewController:storeProductViewController animated:YES completion:nil];
//                                                          [reminder removeFromSuperview];
//                                                          flag = 1;
//                                                      });
//                                                  }
//                                              }];
//    });
//    dispatch_group_notify(group, queue, ^{
//        [NSThread sleepForTimeInterval:5];
//        if (flag==0)
//        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[releaseInfo objectForKey:@"trackViewUrl"]]];
                [reminder removeFromSuperview];
            });
//        }
//    });
    
    
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
