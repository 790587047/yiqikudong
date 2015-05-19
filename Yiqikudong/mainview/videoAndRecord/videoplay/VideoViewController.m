//
//  VideoViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/2/17.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoListViewController.h"
#import "VideoModel.h"
#import "VideoListViewController.h"
#import "Common.h"

@interface VideoViewController ()

@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIButton *btnPlay;

@end

@implementation VideoViewController{
    UIImagePickerController *imagePicker;
    dispatch_source_t _timer;
    ReminderView *indicator;
    VideoModel *videoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    backbutton.tintColor = WHITECOLOR;
    self.navigationItem.leftBarButtonItem = backbutton;
    
    self.navigationItem.title = @"视频";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回按钮事件
- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//拍摄视频
- (IBAction)takeVideo:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [Common showMessage:@"该设备没有摄像头" withView:self.view];
        return;
    }
    if (![[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeMovie]) {
        [Common showMessage:@"不支持录制的视频类型" withView:self.view];
        return;
    }
    if (imagePicker == nil) {
        imagePicker = [[UIImagePickerController alloc] init];
    }
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,kUTTypeVideo, nil];
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //    imagePicker.showsCameraControls = YES;
    
    imagePicker.showsCameraControls = NO;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = .5f;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        //闪光灯
        UIButton *btnFlashLamp = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFlashLamp setFrame:CGRectMake(4, 2, 30, 30)];
        CGPoint point = btnFlashLamp.center;
        point.y = topView.center.y;
        btnFlashLamp.center = point;
        [btnFlashLamp setTitle:@"Auto" forState:UIControlStateNormal];
        [btnFlashLamp.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        //    [btnFlashLamp setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btnFlashLamp addTarget:self action:@selector(cameraTorchOn:) forControlEvents:UIControlEventTouchUpInside];
        btnFlashLamp.selected = YES;
        [topView addSubview:btnFlashLamp];
    }
    
    //视频时间
    if (_lblTime == nil) {
        _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    _lblTime.center = topView.center;
    [_lblTime setText:@"00:05:00"];
    _lblTime.textAlignment = NSTextAlignmentCenter;
    _lblTime.textColor = WHITECOLOR;
    [_lblTime setFont:[UIFont systemFontOfSize:14.0f]];
    [topView addSubview:_lblTime];
    
    
    //切换前后摄像头
    UIButton *btnChangeCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnChangeCamera setFrame:CGRectMake(SCREENWIDTH - 40, 2, 40, 40)];
    [btnChangeCamera setImage:[UIImage imageNamed:@"cameraSwitch"] forState:UIControlStateNormal];
    //    [btnChangeCamera setBackgroundColor:[UIColor blueColor]];
    [btnChangeCamera addTarget:self action:@selector(swapFrontAndBackCameras:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnChangeCamera];
    
    CGPoint point = btnChangeCamera.center;
    point.y = topView.center.y;
    btnChangeCamera.center = point;
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-60, SCREENWIDTH, 60)];
    buttomView.backgroundColor = [UIColor blackColor];
    buttomView.alpha = .5f;
    
    //取消按钮
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setFrame:CGRectMake(10, 15, 60, 30)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    //    [btnCancel setBackgroundColor:[UIColor redColor]];
    [btnCancel setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:btnCancel];
    
    //开始拍摄按钮
    if (_btnPlay == nil) {
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [_btnPlay setFrame:CGRectMake(SCREENWIDTH/2 - 25, 2, 50, 50)];
    point = _btnPlay.center;
    point.y = btnCancel.center.y;
    _btnPlay.center = point;
    [_btnPlay setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
    [_btnPlay addTarget:self action:@selector(startShooting:) forControlEvents:UIControlEventTouchUpInside];
    _btnPlay.selected = YES;
    [buttomView addSubview:_btnPlay];
    
    [imagePicker.cameraOverlayView addSubview:topView];
    [imagePicker.cameraOverlayView addSubview:buttomView];
    
    //    imagePicker.videoMaximumDuration = 10.f; //5分钟
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)showVideoList:(id)sender {
    VideoListViewController *viewController = [[VideoListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark-
#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
            NSString *path = (NSString *)[[info valueForKey:UIImagePickerControllerMediaURL] path];
            // 保存视频
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }];
}

// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    NSLog(@"videoPath = %@",videoPath);
    NSLog(@"error = %@",error);
    
//    indicator = [ReminderView reminderView];
//    [self.view addSubview:indicator];
    
    NSURL *pathUrl = [NSURL fileURLWithPath:videoPath];
    
    // 上传文件时，是文件不允许被覆盖，文件重名
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4",str];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Compress"];
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:videoName];
    NSURL *tempUrl = [NSURL fileURLWithPath:documentsDirectory];
    NSLog(@"tempUrl=%@",tempUrl);

    VideoModel *model = [[VideoModel alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //压缩视频
        [self lowQuailtyWithInputURL:pathUrl outputURL:tempUrl blockHandler:^(AVAssetExportSession *session){
            if(session.status == AVAssetExportSessionStatusCompleted){
                NSLog(@"success!");
                model.v_timeScale = [self getVideoLength:tempUrl];
                model.v_Url = [NSString stringWithFormat:@"%@",tempUrl];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator removeFromSuperview];
                    if (model.v_Url.length > 0) {
                        UIImage *image = [self getImage:pathUrl];
                        model.v_imageData = UIImageJPEGRepresentation(image, 1);
                        model.sumMemory = [self getVideoFileSize:tempUrl.path];
                        
                        [Common deleteFile:pathUrl.path];
                        
                        //                                model.v_Name = self.txtTitle.text;
                        model.v_State = Uploading;
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        // 设置时间格式
                        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                        model.v_OperationTime = [formatter stringFromDate:[NSDate date]];
                        
                        model.v_PlayTime = 0.00f;
                        model.downloadMemory = 0.00f;
                        
                        videoModel = model;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存视频文件名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                        alert.tag = 1001;
                        [alert show];
                        
                    }
                    else{
                        [Common deleteFile:pathUrl.path];
                        [self showFailMessage];
                    }
                });
            }else if (session.status == AVAssetExportSessionStatusFailed){
                NSLog(@"error = %@",session.error);
                [Common deleteFile:pathUrl.path];
                [self showFailMessage];
            }
            else
            {
                NSLog(@"压缩视频失败！");
                [self showFailMessage];
            }
        }];
    });

}

//压缩视频
- (void)lowQuailtyWithInputURL:(NSURL*)inputURL
                     outputURL:(NSURL*)outputURL
                  blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    //输出格式
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = TRUE;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}

//获取视频的缩略图
-(UIImage *)getImage:(NSURL *)videoURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error ;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
//获取视频时长
-(CGFloat) getVideoLength:(NSURL *)movieURL{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;//视频的总时长，单位秒
    return second;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

//获取视频文件的大小
-(CGFloat) getVideoFileSize : (NSString *) path{
    NSError *error;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    unsigned long long length = [fileAttributes fileSize];
    float fileSize = length / 1024.0 / 1024.0;
    return fileSize;
}

//时间戳+随机数生成上传视频名称
-(NSString *)getUploadVideoName {
    NSString *currentDate = [self getCurrentDate:@"yyyyMMddHHmmss"];
    NSString *randomStr = [[NSMutableString alloc] init] ;
    for (int i = 0; i < 4; i++) {
        long random = arc4random()%100000;
        randomStr = [randomStr stringByAppendingString:[NSString stringWithFormat:@"%ld",random]];
    }
    NSString *videoName = [NSString stringWithFormat:@"%@%@",currentDate,randomStr];
    return videoName;
}

//获取当前时间
-(NSString *)getCurrentDate : (NSString *) dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}

-(void) showFailMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Common showMessage:@"出现错误，请重新选择" withView:self.view];
        [indicator removeFromSuperview];
    });
}

#pragma mark-
#pragma mark---拍摄视频界面
//显示拍摄视频的倒计时时间
-(void) showCameraTime{
    __block int timeout=300; //倒计时时间5分钟
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"视频录制时间到，最长时间为5分钟"];
                [self.view addSubview:remiderView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:0.5];//动画运行时间
                    remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
                    [UIView commitAnimations];//提交动画
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [remiderView removeFromSuperview];
                        if (indicator == nil) {
                            indicator = [ReminderView reminderView];
                            [self.view addSubview:indicator];
                        }
                    });
                });
                [imagePicker stopVideoCapture];
            });
        }else{
            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"00:0%d:%.2d",minutes, seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblTime.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//打开闪光灯
-(void)cameraTorchOn:(UIButton *) sender{
    if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    else if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff){
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    else {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

//取消按钮事件
-(void) cancelCamera{
    [self imagePickerControllerDidCancel:imagePicker];
}

//切换前后摄像头
-(void)swapFrontAndBackCameras:(UIButton *) sender{
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

//开始拍摄
-(void) startShooting:(UIButton *) sender{
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"videoStop"] forState:UIControlStateNormal];
        [imagePicker startVideoCapture];
        [self showCameraTime];
        //        [sender setTitle:@"停止" forState:UIControlStateNormal];
        sender.selected = NO;
    }
    else{
        [sender setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
        [imagePicker stopVideoCapture];
        sender.selected = YES;
        dispatch_source_cancel(_timer);
        indicator = [ReminderView reminderView];
        [self.view addSubview:indicator];
    }
}

#pragma mark---UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[alertView textFieldAtIndex:0] text].length > 0) {
            videoModel.v_Name = [[alertView textFieldAtIndex:0] text];
        }
        else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            videoModel.v_Name = [formatter stringFromDate:[NSDate date]];
        }
        if (![VideoModel isExistsUploadVideoName:videoModel.v_Name]) {
            videoModel.downLoadId = 0;//未下载
            //添加数据
            [VideoModel addVideoModel:videoModel];
            VideoListViewController *viewController = [[VideoListViewController alloc] init];
            viewController.isTakeVideoView = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else{
            [Common showMessage:@"该视频名已存在，请重新输入" withView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存视频文件名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
            });
        }
    }
}
@end
