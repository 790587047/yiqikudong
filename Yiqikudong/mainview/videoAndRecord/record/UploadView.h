//
//  UploadView.h
//  YiQiWeb
//
//  Created by BK on 15/1/8.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordingView.h"
#import "LocalVoiceView.h"
@interface UploadView : BaseController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL agreeFlag;
    UIButton*uploadBtn;
    VoiceInfo*voiceInfo;
    
}
@property(nonatomic,retain)NSString*kind;
@end
