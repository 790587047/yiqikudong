//
//  AppDelegate.h
//  YiQiWeb
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import "WbApi.h"
#import "JDStatusBarNotification.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "rootNavigationController.h"
#import "BPush.h"
#import "OpenUDID.h"
#import "JSONKit.h"
#import "BMapKit.h"
#import <AddressBook/AddressBook.h>
#import "RecodingBaseView.h"
#import "MyTabBarController.h"
#import "CollectionsViewController.h"
//#import "YRSideViewController.h"
#import "UserCenterView.h"
#import "UserCenterController.h"
#import "XMPP.h"
#import "PlayVoiceViewController.h"
#import "ChatDealClass.h"
#import "MTStatusBarOverlay.h"
#import "RESideMenu.h"
//TencentSessionDelegate
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWebViewDelegate,WeiboSDKDelegate,WeiboAuthDelegate,WeiboRequestDelegate,WBHttpRequestDelegate,UIAlertViewDelegate,WXApiDelegate,TencentSessionDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,MTStatusBarOverlayDelegate,RESideMenuDelegate>
{
    NSURLConnection*getConnection;//post请求连接
    NSMutableData*getData;
    
    BMKMapManager*mapManager;
    BMKLocationService*locationService;
    
    
    XMPPStream *xmppStream;
    NSString *password;  //密码
    BOOL isOpen;  //xmppStream是否开着
    
    BOOL isInRegisting;
    
    NSTimer*timer;//应用实时测试有无新信息。
    
    int backOrforeFlag;
}
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString*shareKind;
@property(strong,nonatomic)NSString*shareContent;
@property(strong,nonatomic)NSString*shareUrl;
@property(strong,nonatomic)NSString*imageUrl;
@property(strong,nonatomic)NSData*imageData;
@property(strong,nonatomic)Reachability*reachability;

@property (strong, nonatomic) NSString *trackViewUrl;
@property (strong, nonatomic) NSDictionary *releaseInfo;

//@property (strong,nonatomic) YRSideViewController *sideViewController;

@property(nonatomic, readonly)XMPPStream *xmppStream;

@property(nonatomic, retain)id chatDelegate;
@property(nonatomic, retain)id messageDelegate;

@property(nonatomic,retain)NSString*lastState;//消息状态
@property(nonatomic,retain)NSString*state;//消息状态

@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (assign, nonatomic) NSInteger currentIndex;

//是否连接
-(BOOL)connect;
//断开连接
-(void)disconnect;

//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;

//注册
-(void)registerUser:(NSString *)jid withPassword:(NSString *)pass;
@end
