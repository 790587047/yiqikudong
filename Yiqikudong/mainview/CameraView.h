//
//  CameraView.h
//  YiQiWeb
//
//  Created by BK on 14/11/25.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Redraw.h"
#import "ZBarSDK.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyView.h"
#import "ShareSheet.h"
#import "Collection.h"
@interface CameraView : BaseController<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    int num,flag;
    BOOL upOrdown;
    NSTimer * timer;
    NSString *webUrl;
    
    Collection *item;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic,strong)NSString*kind;
@end
