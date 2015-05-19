//
//  KZJShareSheet.h
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import "AppDelegate.h"
#import "Collection.h"
#import "SqlServer.h"
#import "WXApi.h"
#import "WXApiObject.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
@interface ShareSheet : UIView<WeiboAuthDelegate,WeiboRequestDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,UIAlertViewDelegate>
{
//    DealData*dealData;
    enum WXScene _scene;
    
}
@property(strong,nonatomic)UIWebView*webview;
@property(strong,nonatomic)Collection*item;
@property(strong,nonatomic)NSData*imageData;


+(ShareSheet*)shareWeiboView;
+(UIView*)shareCardView;
-(void)btnAction:(UIButton*)btn;
-(void) changeScene:(int) scene;
@end
