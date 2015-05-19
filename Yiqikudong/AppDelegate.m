//
//  AppDelegate.m
//  YiQiWeb
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "SqlServer.h"
#import "Statics.h"
#import "KKChatDelegate.h"
#import "KKMessageDelegate.h"
#import "HomeViewController.h"

#define n 1
#define m n
@implementation AppDelegate
@synthesize shareKind,shareContent,imageData,shareUrl,imageUrl,reachability,chatDelegate,xmppStream,state,lastState;
-(void)applicationDidFinishLaunching:(UIApplication *)application{
    //真机播放MP3
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    CFErrorRef error = NULL;
    //创建一个通讯录操作对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (&ABAddressBookRequestAccessWithCompletion != NULL) {
        // we're on iOS 6
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            NSLog(@"%u",granted);
        });
    }
    
    [BPush setupChannel:launchOptions];
    [BPush setDelegate: self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:myTypes];
    }
    [application setApplicationIconBadgeNumber:0];
    NSLog(@"%@====%f",NSHomeDirectory(),SCREENWIDTH);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    mapManager = [[BMKMapManager alloc]init];
    BOOL flag = [mapManager start:API_KEY generalDelegate:self];
    if (!flag)
    {
        NSLog(@"地图开启失败");
    }else
    {
        NSLog(@"地图开启成功");
        locationService.delegate = self;
        [locationService startUserLocationService];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS COLLECTIONINFO(ID INTEGER PRIMARY KEY AUTOINCREMENT,TITLE TEXT,URL TEXT,COLLECTIONDATE TEXT,IMAGEDATA BLOB); ";
     sqlCreateTable = [sqlCreateTable stringByAppendingString:@"CREATE TABLE IF NOT EXISTS VIDEOINFO(ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,VIDEOURL TEXT,TIMESCALE INT,IMAGEDATA BLOB,STATE INT,OPERATETIME TEXT,PLAYTIME DOUBLE,SUM DOUBLE,UPLOADFILESIZE DOUBLE,DOWNLOADID INT);"];
    [sqlDbInstance exec:sqlCreateTable];
    
    [self createSQL];

    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //以访问主机地址生成一个网络检测对象
    reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    //开始检测
    [reachability startNotifier];
    
    [WXApi registerApp:WXAPPID];
    [self performSelector:@selector(testLog) withObject:nil afterDelay:3];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareKind" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareKind:) name:@"shareKind" object:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天列表界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkNewsTimer) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop]run];
    });
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"playerIndex"]!= nil) {
        self.currentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"playerIndex"];
    }
    else
        self.currentIndex = 0;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    return YES;
}
-(void)checkNewsTimer
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*userID = @"10";
        NSURL*url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@chat/APP_PrivateChat_CheckAllNew.asp",chatUrlPrefix]];
        //创建可变链接请求
        NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        //设置http请求方式
        [request setHTTPMethod:@"POST"];
                NSString*bodyStr = [NSString stringWithFormat:@"SendID=%@",userID];
        [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        //response响应信息
        NSHTTPURLResponse*response = nil;
        //错误信息
        NSError*error = nil;
        //开始post同步请求
        NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //        NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
        NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"strResult = %@",strResult);
//        NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
        NSDictionary*dict = [strResult objectFromJSONString];
//        if (self ob) {
//            <#statements#>
//        }
//        [self removeObserver:self forKeyPath:@"state"];
//        if ([[dict objectForKey:@"msg"] isEqualToString:@"有新信息"])
//        {
//        NSLog(@"%@,%@",lastState,state);
        state = [dict objectForKey:@"code"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"聊天列表界面"]isEqualToString:@"否"])
        {
            if (lastState==nil)
            {
                lastState = [dict objectForKey:@"code"];
                state = [dict objectForKey:@"code"];
                if ([[dict objectForKey:@"msg"] isEqualToString:@"有新消息"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
                        overlay.animation = MTStatusBarOverlayAnimationFallDown;
                        overlay.detailViewMode = MTDetailViewModeHistory;
                        overlay.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
                        [overlay postMessage:@"有消息" animated:YES];
                        overlay.userInteractionEnabled = YES;
                        overlay.delegate = self;
                        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
                        [overlay addGestureRecognizer:tap];
//                        NSLog(@"%@==%@",[self activityViewController],[UIApplication sharedApplication].keyWindow.rootViewController);
                        [overlay show];
                        if (backOrforeFlag) {
                            UILocalNotification *notification=[[UILocalNotification alloc] init];
                            if (notification!=nil) {
                                NSDate *now=[NSDate new];
                                notification.fireDate=[now dateByAddingTimeInterval:0.01];
                                notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                                notification.timeZone=[NSTimeZone defaultTimeZone];
                                notification.applicationIconBadgeNumber=1; //应用的红色数字
                                notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
                                //去掉下面2行就不会弹出提示框
                                notification.alertBody=@"新消息";//提示信息 弹出提示框
                                notification.alertAction = @"打开";  //提示框按钮
                                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                            }
                        }
                    });
                }
            }else
            {
                if ([[dict objectForKey:@"msg"] isEqualToString:@"有新消息"])
                {
                    if (![lastState isEqualToString:state])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
                            overlay.animation = MTStatusBarOverlayAnimationFallDown;
                            overlay.detailViewMode = MTDetailViewModeHistory;
                            overlay.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
                            [overlay postMessage:@"有消息" animated:YES];
                            overlay.userInteractionEnabled = YES;
                            overlay.delegate = self;
                            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
                            [overlay addGestureRecognizer:tap];
//                            NSLog(@"%@==%@",[self activityViewController],[UIApplication sharedApplication].keyWindow.rootViewController.view);
                            [overlay show];
                            if (backOrforeFlag)
                            {
                                UILocalNotification *notification=[[UILocalNotification alloc] init];
                                if (notification!=nil) {
                                    NSDate *now=[NSDate new];
                                    notification.fireDate=[now dateByAddingTimeInterval:0.01];
                                    notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
                                    notification.timeZone=[NSTimeZone defaultTimeZone];
                                    notification.applicationIconBadgeNumber=1; //应用的红色数字
                                    notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
                                    //去掉下面2行就不会弹出提示框
                                    notification.alertBody=@"新消息";//提示信息 弹出提示框
                                    notification.alertAction = @"打开";  //提示框按钮
                                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                                }
                            }
                            
                        });
                    }
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
                        [overlay hide];
                    });
                }
            }
        }else
        {
            MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
            [overlay hide];
        }
        lastState = state;
        
    });
}
// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    return activityViewController;
}
-(void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        NSLog(@"点击进入新消息界面");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chat" object:nil];
        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
        [overlay hide];
        state = @"err";
    }
}

-(void)initView
{
    MainView*mainView = [[MainView alloc]init];
    rootNavigationController*nav_mainView = [[rootNavigationController alloc]initWithRootViewController:mainView];
    
//    FindView*findview = [[FindView alloc]init];
    HomeViewController *findview = [[HomeViewController alloc] init];
    UINavigationController*nav_findview = [[UINavigationController alloc]initWithRootViewController:findview];
    
    PlayVoiceViewController *playVoice = [[PlayVoiceViewController alloc]init];
    
    MineView*mineView = [[MineView alloc]init];
    mineView.kind = @"已下载";
    UINavigationController*nav_mineView = [[UINavigationController alloc]initWithRootViewController:mineView];
    
    RecodingBaseView*recordingview =[[RecodingBaseView alloc]init];
    
    NSMutableArray*image = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"home"],[UIImage imageNamed:@"findvoice"],[UIImage imageNamed:@"playvoice"],[UIImage imageNamed:@"mine"],[UIImage imageNamed:@"recordvoice"], nil];
    
    NSMutableArray*selectedImage = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"homeselected"],[UIImage imageNamed:@"findvoiceselected"],[UIImage imageNamed:@"playvoice"],[UIImage imageNamed:@"mineselected"],[UIImage imageNamed:@"recordvoiceselected"], nil];
    MyTabBarController *myTabBar = [[MyTabBarController alloc] initWithImage:image SeletedImage:selectedImage];
    myTabBar.titleArray = [NSArray arrayWithObjects:@"首页",@"发现",@"我的",@"录制",nil];
    myTabBar.viewControllers = [NSArray arrayWithObjects:nav_mainView,nav_findview,playVoice,nav_mineView,recordingview, nil];
    
    UserCenterView*userCenter = [[UserCenterView alloc]init];
        
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:myTabBar
                                                                    leftMenuViewController:userCenter
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"userCenterBackground"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    //    sideMenuViewController.contentViewInLandscapeOffsetCenterX = 100;
    sideMenuViewController.scaleMenuView = NO;
    //    sideMenuViewController.fadeMenuView = NO;
    sideMenuViewController.interactivePopGestureRecognizerEnabled = YES;
    sideMenuViewController.scaleBackgroundImageView = NO;
    
    //滑动手势范围
    sideMenuViewController.panFromEdge = YES;
    
    //拉到边缘后不可再拉
    sideMenuViewController.bouncesHorizontally = NO;
    
    //不会出现视觉偏差
    sideMenuViewController.parallaxEnabled = NO;
    sideMenuViewController.parallaxContentMaximumRelativeValue = 0;
    self.window.rootViewController = sideMenuViewController;
    
    [self.window makeKeyAndVisible];
    
    //网络检测
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:mainView selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
}
//创建数据库表
-(void)createSQL
{
    NSString*sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    //判断数据库是否打开成功
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    BOOL createResult1 = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS voiceCollect(ID INTEGER PRIMARY KEY AUTOINCREMENT,voiceName text,URL text ,SUMTIME TEXT,TOTAL float,CREATETIME text,AUTHOR text,IMAGEDATA BLOB,CLASSID INT,TYPE INT,picPath text,playSumCount TEXT,USERID TEXT)"];//primary key保证数据唯一
    //数据库可以存放的数据类型;bool ,integer ,real(浮点型),text(字符串),blob(二进制)
    if (createResult1)
    {
        NSLog(@"表voiceCollect创建成功");
    }
    BOOL createResult2 = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS voiceUpload(ID INTEGER PRIMARY KEY AUTOINCREMENT,voiceName text,URL text ,SUMTIME TEXT,TOTAL float,CREATETIME text,AUTHOR text,IMAGEDATA BLOB,CLASSID INT,TYPE INT,uploadingFlag int,downloadFlag INT,downloadingFlag INT,collectFlag int,picPath text,downloadTime text,playSumCount TEXT,USERID TEXT)"];//primary key保证数据唯一
    //数据库可以存放的数据类型;bool ,integer ,real(浮点型),text(字符串),blob(二进制)
    if (createResult2)
    {
        NSLog(@"表voiceUpload创建成功");
    }
    BOOL createResult3 = [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS voiceHistory(ID INTEGER PRIMARY KEY AUTOINCREMENT,voiceName text,URL text ,SUMTIME TEXT,TOTAL float,CREATETIME text,AUTHOR text,IMAGEDATA BLOB,CLASSID INT,TYPE INT,picPath text,playSumCount TEXT,USERID TEXT)"];//primary key保证数据唯一
    //数据库可以存放的数据类型;bool ,integer ,real(浮点型),text(字符串),blob(二进制)
    if (createResult3)
    {
        NSLog(@"表voiceHistory创建成功");
    }
    
    //聊天记录的表
    BOOL createResult6 = [dataBase executeUpdate:@"create table chatRecords(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,CHATID text,SENDID text,RECIEVEID text,MSGTYPE text,MSGID text,MSG text,TIME text,OTHER text)"];//primary key保证数据唯一
    //数据库可以存放的数据类型;bool ,integer ,real(浮点型),text(字符串),blob(二进制)
    if (createResult6)
    {
        NSLog(@"表chatRecords创建成功");
    }
    //聊天历史的列表（最近联系人）
    BOOL createResult7 = [dataBase executeUpdate:@"create table chatList(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,MYID text,CHATUSERID text,MAXID text,TIME text,PICURL text,CHATPICURL text,CHATUSERNAME text,STATECHAT text,MSG text,MSGID text,CHATTYPE text)"];//primary key保证数据唯一
    //数据库可以存放的数据类型;bool ,integer ,real(浮点型),text(字符串),blob(二进制)
    if (createResult7)
    {
        NSLog(@"表chatList创建成功");
    }
    //关闭数据库
    [dataBase close];
}
-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%@",userLocation);
}
- (void) testLog
{
    for (int i = 0; i < 1; i++)
    {
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"wxd930ea5d5a258f4f%d://",i]]];
    }
}
-(void)networkChange:(NSNotification*)notification
{
    NSLog(@"网络变化");
}
-(void)shareKind:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    shareKind = [dict objectForKey:@"shareKind"];
    shareContent = [dict objectForKey:@"content"];
    imageData = [dict objectForKey:@"imageData"];
    shareUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shareUrl"]];
    if (imageUrl==nil)
    {
        imageUrl = [dict objectForKey:@"imageUrl"];
    }
}

//程序回调返回
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([shareKind isEqualToString:@"新浪微博"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([shareKind isEqualToString:@"微信好友"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([shareKind isEqualToString:@"微信朋友圈"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([shareKind isEqualToString:@"QQ空间"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [[WbApi getWbApi]handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    NSLog(@"213233234525434");
    if ([shareKind isEqualToString:@"新浪微博"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([shareKind isEqualToString:@"微信好友"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([shareKind isEqualToString:@"微信朋友圈"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([shareKind isEqualToString:@"QQ空间"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [[WbApi getWbApi]handleOpenURL:url];
}
//下面三个方法为新浪回调方法
//收到微博的请求
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
//微博响应请求返回方法
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    //    NSLog(@"21323434");
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess )
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"新浪登陆状态"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
            [user setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"SinaToken"];
            [user setObject:[(WBAuthorizeResponse *)response userID] forKey:@"SinaUserID"];
            [user synchronize];
            
            if ([user objectForKey:@"Authentication"]) {
                [user removeObjectForKey:@"Authentication"];
                [user synchronize];
                [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
            }
            else{
                
                [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
                [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
                NSString *url;
                NSDictionary*params;
                
                url = @"https://upload.api.weibo.com/2/statuses/upload.json";
                //            NSLog(@"%@",shareContent);
                params=@{@"status":shareContent,@"pic":imageData};
                
                [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaToken"] url:url httpMethod:@"POST" params:params delegate:self withTag:@"1000"];
            }
        }
    }
}
#pragma mark 请求返回数据加载完毕
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    //    NSLog(@"%@",result);
    if ([request.tag isEqualToString:@"1000"])
    {
        //        [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSuccess" object:nil];
    }
}
//请求返回失败
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    if ([request.tag isEqualToString:@"1000"])
    {
        [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
}


#pragma mark 下面方法为腾讯微博回调方法
-(void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"腾讯登陆状态"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIImage*image = [UIImage imageWithData:imageData];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",shareContent, @"content",image,@"pic",nil];
    [[WbApi getWbApi] requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    
}
//腾讯微博请求数据返回方法
-(void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    //    [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSuccess" object:nil];
}
//腾讯微博错误返回方法
-(void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSLog(@"%@",error);
}

#pragma mark-QQ代理
-(void)tencentDidLogout
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)tencentDidLogin
{
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    //    NSLog(@"2313");
    NSString *utf8String = shareUrl;
    
    NSMutableString*title = [[NSMutableString alloc]initWithString:shareContent];
    NSRange range = NSMakeRange(shareContent.length-shareUrl.length, shareUrl.length);
    [title deleteCharactersInRange:range];
    NSString *description = shareContent;
    NSLog(@"%@%@",shareUrl,shareContent);
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:imageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qzone
    NSLog(@"%d",[QQApiInterface SendReqToQZone:req]);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSuccess" object:nil];
    
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)tencentDidNotNetWork
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(BOOL)onTencentReq:(TencentApiReq *)req
{
    return YES;
}
-(BOOL)onTencentResp:(TencentApiResp *)resp
{
    return YES;
}
#pragma mark 微信
//授权后回调
-(void) onResp:(BaseResp *)resp{
    NSLog(@"%@",resp);
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
        [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            if(resp.errCode == 0)
                [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
            else
                [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1 styleName:@"JDStatusBarStyleError"];
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            NSLog(@"%@===",dic);
            [self getAccess_token:code];
        }
    }
}

//获取token
-(void)getAccess_token:(NSString*)code
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,WXSECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                NSLog(@"%@===%@==%@",dic,[dic objectForKey:@"access_token"],[dic objectForKey:@"openid"]);
                [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"openid"] forKey:@"openid"];
                [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self getUserInfo:dic];
            }
        });
    });
}
//获取用户信息
-(void)getUserInfo:(NSDictionary*)dict
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[dict objectForKey:@"access_token"],[dict objectForKey:@"openid"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                NSLog(@"%@===%@",[dic objectForKey:@"nickname"],[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]]);
                NSLog(@"%@===%@===%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"],[[NSUserDefaults standardUserDefaults] valueForKey:@"openid"],[[NSUserDefaults standardUserDefaults] valueForKey:@"refresh_token"]);
            }
        });
        
    });
}
#pragma mark -mark 应用收到内存警告时执行的方法。
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    backOrforeFlag = 1;
    [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天列表界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    __block UIBackgroundTaskIdentifier bgTask;// 后台任务标识
    // 结束后台任务
    void (^endBackgroundTask)() = ^(){
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    };
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        endBackgroundTask();
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        double start_time = application.backgroundTimeRemaining;// 记录后台任务开始时间
        NSLog(@"%f",start_time);
//        BOOL networkAvailable = [YLSGlobalUtils isNetworkAvailable];
//        if(!networkAvailable){
//            NSLog(@"网络不可用，取消自动备份");
//            endBackgroundTask();
//            return;
//        }
        
//        BOOL need = [backupService checkNeedBackup];
//        if(!need){
//            NSLog(@"无需备份");
//            endBackgroundTask();
//            return;
//        }
        
//        [backupService doBackupProcessHandler:^(float done, float total){
//            // nothing to do with progress
//        } CompletionHandler:^(NSError* error, NSArray* statistics){
//            double done_time = application.backgroundTimeRemaining;
//            double spent_time = start_time - done_time;
//            NSLog(@"后台备份完成，耗时: %f秒", spent_time);
//            endBackgroundTask();
//        }];
    });
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentIndex forKey:@"playerIndex"];
    [[NSUserDefaults standardUserDefaults] setFloat:CMTimeGetSeconds(self.audioPlayer.currentItem.currentTime) forKey:@"playCurrentTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber=0;
    backOrforeFlag = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


//推送通知接收代理
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"deviceToken=%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //    [application registerForRemoteNotifications];UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"====%@",notificationSettings.categories] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认",nil];
    //    [alert show];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //    UIAlertView*alert1 = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"====%@",userInfo] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认",nil];
    //    [alert1 show];
    //    NSLog(@"%@",userInfo);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState != UIApplicationStateBackground) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:alert
                                                           delegate:nil
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
}
-(void)onMethod:(NSString*)method response:(NSDictionary*)data{
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        //        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        //        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        //        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            //            self.viewController.appidText.text = appid;
            //            self.viewController.useridText.text = userid;
            //            self.viewController.channelidText.text = channelid;
            
            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            //            self.appId = appid;
            //            self.channelId = channelid;
            //            self.userId = userid;
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            
        }
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error = %@",error);
}




-(void)setupStream{
    //初始化XMPPStream
    [self disconnect];
    [xmppStream removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)goOnline{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

-(void)goOffline{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}
//
-(BOOL)connect{
    [self setupStream];
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASS];
    NSString *server = [defaults stringForKey:SERVER];
    NSLog(@"%@=--=%@=--=%@",userId,pass,server);
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    if (userId == nil || pass == nil) {
        return NO;
    }
    
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    //设置服务器
    [xmppStream setHostName:server];
    //密码
    password = pass;
    
    //连接服务器
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:-1 error:&error]) {
        NSLog(@"cant connect %@", server);
        return NO;
    }
    NSLog(@"error==%@",error);
//    [self registerUser:userId withpassword:pass];
    return YES;
    
}

-(void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
}
//
////连接服务器
//
//
//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [self goOnline];
}
////验证未通过
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"尼玛===%@",error);
}
//
////收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
//        NSLog(@"message = %@", message);
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *type = [[message attributeForName:@"type"] stringValue];
    NSString *msg = [[message elementForName:@"body"] stringValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (msg !=nil)
    {
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:type forKey:@"type"];
        MsgObject*object = [[MsgObject alloc]init];
        object.content = msg;
        object.fromUserId = from;
        object.type = type;
        [[ChatDealClass dealDataClass]saveMsg:object];
    }
    if (from!=nil)
    {
        [dict setObject:from forKey:@"sender"];
    }
//    NSLog(@"%@===%@",msg,from);
    //消息接收到的时间
    [dict setObject:[Statics getCurrentTime] forKey:@"time"];
    //消息委托(这个后面讲)
    if (msg!=nil)
    {
        [_messageDelegate newMessageReceived:dict];
    }
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message;
{
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *type = [[message attributeForName:@"type"] stringValue];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (msg !=nil)
    {
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:type forKey:@"type"];
        MsgObject*object = [[MsgObject alloc]init];
        object.content = msg;
        object.fromUserId = from;
        object.type = type;
        [[ChatDealClass dealDataClass]saveMsg:object];
    }
    if (from!=nil)
    {
        [dict setObject:from forKey:@"sender"];
    }
//    NSLog(@"%@===%@",msg,from);
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //    NSLog(@"presence = %@", presence);
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    NSLog(@"%@==%@==%@",userId,presenceFromUser,presenceType);
    if (![[NSString stringWithFormat:@"%@", presenceFromUser] isEqualToString:userId]) {
        //在线状态
        if (![presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"192.168.0.69"]];
        }else{
            //用户列表委托(后面讲)
//            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"192.168.0.69"]];
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"192.168.0.69"]];
        }
    }
}
-(void)registerUser:(NSString *)jid withPassword:(NSString *)pass
{
    
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    return YES;
}


// 此方法在stream开始连接服务器的时候调用
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    isOpen = YES;
    NSError *error = nil;
    //验证密码
    NSLog(@"error%u==%@",[[self xmppStream] authenticateWithPassword:password error:&error],error);
}



#pragma mark 后台更新数据
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    http://www.chazidian.com/service/pinyin/ban/0/2/
//    http://192.168.0.136:82/apply/chat/APP_PrivateChat_CheckAllNew.asp?SendID=1
    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.0.136:82/apply/chat/APP_PrivateChat_CheckAllNew.asp"];
    NSLog(@"测试后台更新");
    //创建可变链接请求
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //设置http请求方式
    [request setHTTPMethod:@"POST"];
    //设置http请求body
    //    NSMutableString*str = (NSMutableString*)message;
    //    str = (NSMutableString*)[str stringByReplacingOccurrencesOfString:@" " withString:@"YQ"];
    NSString*bodyStr = [NSString stringWithFormat:@"SendID=%@",@"10"];
    //    NSLog(@"%@",bodyStr);
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    //response响应信息
    NSHTTPURLResponse*response = nil;
    //错误信息
    NSError*error = nil;
    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //        NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
    NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"strResult2 = %@",strResult);
    if (error)
    {
        completionHandler(UIBackgroundFetchResultFailed);
    }
    NSDictionary*dict = [strResult objectFromJSONString];
    if ([[dict objectForKey:@"msg"]isEqualToString:@"有新消息"])
    {
        completionHandler(UIBackgroundFetchResultNewData);
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        if (notification!=nil) {
            NSDate *now=[NSDate new];
            notification.fireDate=[now dateByAddingTimeInterval:0.01];
            notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber=1; //应用的红色数字
            notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
            //去掉下面2行就不会弹出提示框
            notification.alertBody=@"新消息";//提示信息 弹出提示框
            notification.alertAction = @"打开";  //提示框按钮
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }else
    {
        completionHandler(UIBackgroundFetchResultNoData);
    }
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chat" object:nil];
}

@end
