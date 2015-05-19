//
//  BDVRCustomRecognitonViewController.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <UIKit/UIKit.h>
#import "BDVoiceRecognitionClient.h"



// @class - BDVRCustomRecognitonViewController
// @brief - 语音搜索界面的实现类
@interface BDVRCustomRecognitonViewController : BaseController<MVoiceRecognitionClientDelegate>
{
	UIImageView *_dialog;
//    BDVRViewController *clientSampleViewController;
    
    NSTimer *_voiceLevelMeterTimer; // 获取语音音量界别定时器

}

// 属性
@property (nonatomic, retain) UIImageView *dialog;
//@property (nonatomic, assign) BDVRViewController *clientSampleViewController;
@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;

// 方法
- (void)cancel:(id)sender;
@end // BDVRCustomRecognitonViewController
