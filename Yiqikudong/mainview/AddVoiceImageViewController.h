//
//  AddVoiceImageViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/3/10.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AddVoiceImageViewController : BaseController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,TencentSessionDelegate,WXApiDelegate,UIActionSheetDelegate>{
    enum WXScene _scene;
    TencentOAuth* _tencentOAuth;
    NSArray* _permissions;
}

@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, copy) NSString *voiceSavePath;

@property (nonatomic, strong) UITextField *txtTitle;
@property (nonatomic, strong) UIButton *btnImage;
@property (nonatomic, strong) UIButton *btnSina;
@property (nonatomic, strong) UIButton *btnQQ;
@property (nonatomic, strong) UIButton *btnWeiXin;
@property (nonatomic, strong) UIButton *btnFriends;

-(void) changeScene:(int) scene;
@end
