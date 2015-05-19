//
//  AddVoiceImageViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/3/10.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "AddVoiceImageViewController.h"
#import "Common.h"
#import "JDStatusBarNotification.h"
#import "ClassifyViewController.h"
#import "VoiceObject.h"
#import "MineView.h"
#import "PlayVoiceViewController.h"

@interface AddVoiceImageViewController ()

@end

@implementation AddVoiceImageViewController{
    UIImage *selectedImage;
    VoiceObject *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[VoiceObject alloc] init];
    self.view.backgroundColor = WHITECOLOR;
    [self initView];
}

//初始化页面
-(void)initView{
    UIColor *letterColor = [UIColor colorWithRed:162.0/255.0 green:128.0/255.0 blue:39.0/255.0 alpha:1.0];
    UIFont *titleFont = [UIFont systemFontOfSize:18.0f];
    
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recordbackground" ofType:@"jpg"]];
    bgImageView.alpha = .5f;
    [self.view addSubview:bgImageView];
    
    //导航栏
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:topView];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setFrame:CGRectMake(10, 30, 50, 30)];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [btnLeft setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnLeft];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [lblTitle setText:@"增加图片"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(SCREENWIDTH - 80, btnLeft.frame.origin.y, 80, 30)];
    [btnRight setTitle:@"下一步" forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [btnRight setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(theNextStep) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnRight];
    
    /** 标题 **/
    UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 200, 40)];
    lblInfo.text = @"为声音添加标题";
    [lblInfo setTextColor:letterColor];
    [lblInfo setFont:titleFont];
    [self.view addSubview:lblInfo];
    
    _txtTitle = [[UITextField alloc] initWithFrame:CGRectMake(20, 64+lblInfo.frame.size.height+10, SCREENWIDTH * 0.85, 35)];
    [_txtTitle setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:246.0/255.0 blue:229.0/255.0 alpha:1.0]];
    [_txtTitle.layer setBorderColor:[[UIColor colorWithRed:206.0/255.0 green:194.0/255.0 blue:150.0/255.0 alpha:1.0] CGColor]];
    [_txtTitle.layer setBorderWidth:1.0f];
    [_txtTitle.layer setMasksToBounds:YES];
    CGPoint p = self.view.center;
    [_txtTitle becomeFirstResponder];
    _txtTitle.center = CGPointMake(p.x, _txtTitle.center.y);
    [_txtTitle.layer setCornerRadius:18.0f];
    [_txtTitle setFont:titleFont];
    _txtTitle.delegate = self;
    [self.view addSubview:_txtTitle];
    
    UILabel *lblPadding = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _txtTitle.leftView = lblPadding;
    _txtTitle.leftViewMode = UITextFieldViewModeAlways;
    
    /** 图片 **/
    UILabel *lblImage = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_txtTitle.frame) + 20, 200, 40)];
    lblImage.text = @"为声音添加图片";
    [lblImage setTextColor:letterColor];
    [lblImage setFont:titleFont];
    [self.view addSubview:lblImage];
    
    _btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnImage setFrame:CGRectMake(30, lblImage.frame.origin.y + lblImage.frame.size.height, 85, 85)];
    [self.view addSubview:_btnImage];
    
    if ([[_voiceSavePath lastPathComponent] rangeOfString:@".mp3"].location != NSNotFound) {
        [_btnImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [_btnImage addTarget:self action:@selector(selectedImage) forControlEvents:UIControlEventTouchUpInside];
        model.voiceType = 0;
    }
    else{
        NSLog(@"_voiceSavePath=%@",_voiceSavePath);
        selectedImage = [Common getImage:[NSURL fileURLWithPath:_voiceSavePath]];
        [_btnImage setImage:selectedImage forState:UIControlStateNormal];
        model.voiceType = 1;
    }
    
    /**
    //分享
    UILabel *lblShare = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_btnImage.frame) + 20, 150, 40)];
    [lblShare setText:@"分享到..."];
    [lblShare setTextAlignment:NSTextAlignmentLeft];
    [lblShare setTextColor:letterColor];
    [lblShare setFont:titleFont];
    [self.view addSubview:lblShare];
    
    CGFloat buttonWidth = SCREENWIDTH / 2 - 40;
    CGFloat buttonHeight = 60;
    _btnSina = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSina setFrame:CGRectMake(30, CGRectGetMaxY(lblShare.frame), buttonWidth, buttonHeight)];
    [_btnSina setImage:[UIImage imageNamed:@"sinaShare"] forState:UIControlStateNormal];
    _btnSina.center = CGPointMake(SCREENWIDTH / 4 + 10, _btnSina.center.y);
    _btnSina.selected = NO;
    _btnSina.tag = 10000;
    [_btnSina addTarget:self action:@selector(SinaShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSina];
    
    _btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnQQ setFrame:CGRectMake(0, _btnSina.frame.origin.y, buttonWidth, buttonHeight)];
    [_btnQQ setImage:[UIImage imageNamed:@"QQSpaceShare"] forState:UIControlStateNormal];
    _btnQQ.center = CGPointMake(SCREENWIDTH / 2 + SCREENWIDTH / 4 - 10, _btnQQ.center.y);
    _btnQQ.selected = NO;
    _btnQQ.tag = 10001;
    [_btnQQ addTarget:self action:@selector(QQSpaceShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnQQ];
    
    //要安装微信不显示
    if ([WXApi isWXAppInstalled]) {
        _btnWeiXin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnWeiXin setFrame:CGRectMake(0, CGRectGetMaxY(_btnSina.frame) + 10, buttonWidth, buttonHeight)];
        [_btnWeiXin setImage:[UIImage imageNamed:@"weiXinShare"] forState:UIControlStateNormal];
        _btnWeiXin.center = CGPointMake(SCREENWIDTH / 4 + 10,_btnWeiXin.center.y);
        _btnWeiXin.selected = NO;
        _btnWeiXin.tag = 10002;
        [_btnWeiXin addTarget:self action:@selector(weiXinShare:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnWeiXin];
        
        _btnFriends = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFriends setFrame:CGRectMake(30, _btnWeiXin.frame.origin.y, buttonWidth, buttonHeight)];
        [_btnFriends setImage:[UIImage imageNamed:@"weiXinFriendShare"] forState:UIControlStateNormal];
        _btnFriends.center = CGPointMake(SCREENWIDTH / 2 + SCREENWIDTH / 4 - 10, _btnFriends.center.y);
        _btnFriends.selected = NO;
        _btnFriends.tag = 10003;
        [_btnFriends addTarget:self action:@selector(weiXinFriendsShare:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnFriends];
    }
    
    _permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
    
    NSString *appid = @"222222";
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                            andDelegate:self];
    **/
}

//下一步按钮操作
-(void)theNextStep{
    if ([self validate]) {
        model.voiceClassId = _classId;
        model.voiceAuthor = @"AA";
        model.voiceUrl = _voiceSavePath;
        if (selectedImage != nil) {
            //上传前图片处理
            UIImage *image = selectedImage;
            if (UIImagePNGRepresentation(selectedImage).length/1024>30){
                image = [Common scaleToSize:selectedImage width:100 height:100];
            }
            model.voicePic = UIImageJPEGRepresentation(image, 0.5);
        }
        model.createTime = [Common getCurrentDate:@"yyyy-MM-dd HH:mm:ss"];
        float sumTime = [Common getVideoLength:[NSURL fileURLWithPath:_voiceSavePath]];
        int second = (int)sumTime % 60;
        int mimute = ((int)sumTime - second) / 60 > 60 ? ((int)sumTime - second) / 60 % 60 : ((int)sumTime - second) / 60;
        int hour   = ((int)sumTime - second) / 60 > 60 ? ((int)sumTime - second) / 60 / 60 : 0;
        if (hour == 0) {
            model.voiceSumTime = [NSString stringWithFormat:@"%.2d:%.2d",mimute,second];
        }
        else
            model.voiceSumTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,mimute,second];
        
        model.total = [self getVoiceFileSize:_voiceSavePath];
        model.uploadingFlag = 1; //1表示True
        model.downloadFlag = 0; //0表示false
        model.downloadingFlag = 0;
        model.collectFlag = 0;
        [VoiceObject addVoiceModel:model];
        
        //        [self share];
        
        //        MineView*mineview = [[MineView alloc]init];
        //        mineview.kind = @"我的声音";
        
        //跳出多重模态视图
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"nav_mine" object:nil];
        }];
        //        [self dismissViewControllerAnimated:YES completion:^{
        //
        //        }];
        //        UINavigationController*nav_mine = [[UINavigationController alloc]initWithRootViewController:mineview];
        //        [self presentViewController:nav_mine animated:YES completion:nil];
        
        //        //返回
        //        UIViewController *presentViewController = [self presentingViewController];
        //        UIViewController *lastViewController = self;
        //        while (presentViewController) {
        //            id temp = presentViewController;
        //            presentViewController = [presentViewController presentingViewController];
        //            lastViewController = temp;
        //        }
        //        [lastViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
//获取视频文件的大小
-(CGFloat) getVoiceFileSize : (NSString *) path{
    NSError *error;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    unsigned long long length = [fileAttributes fileSize];
    float fileSize = length / 1024.0 / 1024.0;
    return fileSize;
}

-(void) share{
    //上传成功后要是选中分享按钮的就分享
    if (_btnSina.selected) {
        [self SinaShare];
    }
    else if (_btnQQ.selected){
        [self QQShare];
    }
    else if (_btnWeiXin.selected){
        if ([WXApi isWXAppInstalled]) {
            [self changeScene:WXSceneSession];
        }
        else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WXNOTInstalled" object:nil];
        }
    }
    else if (_btnFriends.selected){
        if ([WXApi isWXAppInstalled]) {
            [self changeScene:WXSceneTimeline];
        }
        else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WXNOTInstalled" object:nil];
        }
    }
}

//验证
-(BOOL) validate{
    NSString *title = [_txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (title.length == 0) {
        [Common showMessage:@"请输入标题" withView:self.view];
        return FALSE;
    }
    else{
        model.voiceName = title;
    }
//    else if (selectedImage == nil) {
//        [Common showMessage:@"请选择图片" withView:self.view];
//        return FALSE;
//    }
    return TRUE;
}

//添加图片
-(void) selectedImage{
    [_txtTitle resignFirstResponder];
    UIActionSheet*actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍摄照片",nil];
    [actionsheet showInView:self.view];
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate = self;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self presentViewController:picker animated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (buttonIndex==0)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //        picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:picker animated:YES completion:nil];
            });
            
        }else if (buttonIndex==1)
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Common showMessage:@"该设备没有摄像头" withView:self.view];
                });
            }else
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //        picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //        NSLog(@"%f==%f",picker.cameraOverlayView.frame.size.height,picker.cameraOverlayView.frame.size.width);
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:picker animated:YES completion:^{
                        
                    }];
                });
            }
        }
    });
    
}
#pragma mark--
#pragma mark -- imagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_btnImage setImage:selectedImage forState:UIControlStateNormal];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

//#pragma mark - 保存图片至沙盒
//- (NSString *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//    // 获取沙盒目录
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    NSLog(@"imagePath = %@",fullPath);
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//    return fullPath;
//}

#pragma mark--
#pragma mark--键盘回收
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![self.txtTitle isExclusiveTouch]) {
        [self.txtTitle resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark--
#pragma mark -- 授权
//新浪微博授权
-(void)SinaShare : (UIButton *) sender{
    [self changeSelected:sender];
    if (sender.selected) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault objectForKey:@"SinaToken"]){
            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
        }
        else{
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            [WeiboSDK sendRequest:request];
            [userDefault setObject:@1 forKey:@"Authentication"];
            [userDefault synchronize];
        }
    }
}

//选中分享按钮高亮显示
-(void) selectedHightLight:(UIButton *) sender{
    sender.selected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.highlighted = YES;
    });
}

//切换按钮选中状态
-(void) changeSelected:(UIButton *) sender {
    //取消延迟操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSInteger temp = 0;
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.selected) {
                temp = btn.tag;
                btn.selected = NO;
                btn.highlighted = NO;
                break;
            }
        }
    }
    if (temp != sender.tag) {
        [self selectedHightLight:sender];
    }
}

//QQ空间授权
-(void)QQSpaceShare:(UIButton *) sender{
    [self changeSelected:sender];
    if (sender.selected) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault objectForKey:@"QQToken"]){
            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
        }
        else{
            [_tencentOAuth authorize:_permissions inSafari:NO];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

//微信分享授权
-(void)weiXinShare : (UIButton *) sender{
    [self changeSelected:sender];
    if (sender.selected) {
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        if ([userDefault objectForKey:@"WeiXinToken"]){
//            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
//        }
//        else{
//            [self WeiXinAuth];
//        }
    }
}

//微信朋友圈授权
-(void)weiXinFriendsShare : (UIButton *) sender{
    [self changeSelected:sender];
    if (sender.selected) {
        
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        if ([userDefault objectForKey:@"WeiXinToken"]){
//            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
//        }
//        else{
//            [self WeiXinAuth];
//        }
    }
}

//微信授权
-(void) WeiXinAuth{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744";
    [WXApi sendReq:req];
}


#pragma mark --  
#pragma mark -- 分享
-(void)changeScene:(int)scene{
    _scene = (enum WXScene) scene;
    [self sendAudioContent];
}

//微信分享
-(void) sendAudioContent{
    if ([self validate]){
        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = record.title;
//        message.description = record.title;
        if (UIImagePNGRepresentation(selectedImage).length/1024>30){
            [message setThumbImage:[Common scaleToSize:selectedImage width:200 height:200]];
        }
        else{
            [message setThumbImage:selectedImage];
        }
//        [message setThumbData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:record.picPath], 1.0)];
//        [message setThumbImage:[UIImage imageWithContentsOfFile:record.picPath]];
        WXMusicObject *ext = [WXMusicObject object];
//        ext.musicUrl = record.videoPath;
//        ext.musicDataUrl = record.videoPath;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        
        [WXApi sendReq:req];

    }
    else{
        [Common showMessage:@"请求数据出错，请稍后重试" withView:self.view];
    }
}

#pragma mark--
#pragma mark -- TencentSessionDelegate
-(void)tencentDidLogin{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        [userDefault setObject:_tencentOAuth.accessToken forKey:@"QQToken"];
        [userDefault synchronize];
    }

    if ([userDefault objectForKey:@"QQToken"]){
        [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
    else{
        NSLog(@"登录不成功 没有获取accesstoken");
        [JDStatusBarNotification showWithStatus:@"登录失败" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)tencentDidLogout{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled)
        [JDStatusBarNotification showWithStatus:@"用户取消登录" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    else
        [JDStatusBarNotification showWithStatus:@"登录失败" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)tencentDidNotNetWork{
    [Common showMessage:@"无网络连接" withView:self.view];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(BOOL)onTencentReq:(TencentApiReq *)req{
    return YES;
}

-(BOOL)onTencentResp:(TencentApiResp *)resp{
    return YES;
}

//QQ空间分享
-(void) QQShare{
//    NSString *utf8String = record.videoPath;
//    NSString *title = record.title;
//    NSString *descriotion = record.title;
//    NSString *previewImageUrl = record.picPath;
//    NSString *flashURL = record.videoPath;
//    QQApiAudioObject *audioObj =
//    [QQApiAudioObject objectWithURL:[NSURL URLWithString:utf8String]
//                              title:title
//                        description:[NSString stringWithFormat:@"%@  %@",descriotion,flashURL]
//                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
//    [audioObj setFlashURL:[NSURL URLWithString:flashURL]];
//    
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
//    //将被容分享到qzone
//    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
//    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult{
    if (sendResult == EQQAPISENDSUCESS) {
        [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
    else if (sendResult == EQQAPISENDFAILD){
        [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
}

//新浪微博分享
-(void) SinaShare{
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = _txtTitle.text;
//  
//    WBMusicObject *music = [WBMusicObject object];
//    music.musicUrl = record.videoPath;
//    music.title = record.title;
//
//    music.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:record.picPath]];
//    music.description = record.title;
//    music.objectID = [NSString stringWithFormat:@"%ld",(long)record.tid];
//    
//    message.mediaObject = music;
//    
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
//    [WeiboSDK sendRequest:request];
}

//返回按钮事件
-(void) goback{
    [self dismissViewControllerAnimated:YES completion:nil];
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
