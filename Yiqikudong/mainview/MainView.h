//
//  MainView.h
//  YiQiWeb
//
//  Created by BK on 14/11/18.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Redraw.h"
#import "ShareSheet.h"
#import "ShareViewController.h"
#import "BaseAnimation.h"
#import "SlideAnimation.h"
#import "ReminderView.h"
#import "CameraView.h"
#import "WebViewJavascriptBridge.h"
#import "MapViewController.h"
#import "BDVRSConfig.h"
#import "BaiduOAuthSDK.h"
#import "BaiduDelegate.h"
#import "BaiduAuthCodeDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRFileRecognizer.h"
#import "BDVRDataUploader.h"
#import "FlashLightView.h"
#import "BDVRCustomRecognitonViewController.h"
#import "VideoView.h"
#import "DownOrUploadView.h"
#import "VideoListViewController.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>
#import<StoreKit/StoreKit.h>
#import "NoteView.h"
#import "FindView.h"
#import "MineView.h"
#import "VideoViewController.h"
#import "ChatView.h"
@interface MainView : BaseController<UIWebViewDelegate,UIActionSheetDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WXApiDelegate,SKStoreProductViewControllerDelegate,NSURLConnectionDataDelegate,UIScrollViewDelegate, MVoiceRecognitionClientDelegate,BDRecognizerViewDelegate, MVoiceRecognitionClientDelegate,BDVRDataUploaderDelegate,BDRecognizerViewDelegate,BaiduAuthCodeDelegate,BaiduAuthorizeDelegate,BaiduAPIRequestDelegate,UITabBarControllerDelegate>
{
    NSDictionary *releaseInfo;
    
    int time;
//    ShareSheet*shareview;
    NSURLConnection*getConnection;//post请求连接
    NSMutableData*getData;
    
    BDRecognizerViewController *tmpRecognizerViewController ;

    NSMutableArray*noteArray;
    
    AFHTTPRequestOperationManager*manager;
}
@property(strong,nonatomic)UIWebView*webview;
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
@property (nonatomic, retain) BDVRCustomRecognitonViewController *audioViewController;
@end
