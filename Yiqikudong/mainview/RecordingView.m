//
//  RecordingView.m
//  YiQiWeb
//
//  Created by BK on 15/1/8.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "RecordingView.h"
#import "lame.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface RecordingView ()

@end

// 全局指针
lame_t lame;

@implementation RecordingView
@synthesize viewRecording,peakPowerArray,averagePowerArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //    if ([self.kind isEqualToString:@"录音"])
    //    {
    
    //    }
    indicator = [ReminderView reminderView];
    self.title = @"录音";
    UIImageView*backgroungimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backgroungimage.image = [UIImage imageNamed:@"recordbackground.jpg"];
    [self.view addSubview:backgroungimage];
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-75, SCREENWIDTH, 75)];
    view.alpha = 0.2;
    view.backgroundColor = WHITECOLOR;
    [self.view addSubview:view];
    
    UIImageView*lineimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-77, SCREENWIDTH, 2)];
    lineimage.image = [UIImage imageNamed:@"linerecord"];
    [self.view addSubview:lineimage];
    
    UIButton*recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(0, 0, 85, 85);
    recordBtn.tag = 999;
    recordBtn.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT-75);
    recordBtn.layer.cornerRadius = recordBtn.frame.size.width/2;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.layer.borderWidth = 6;
    recordBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.1].CGColor;
    recordBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    [recordBtn setImage:[UIImage imageNamed:@"recordplay"] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    
    flagRecord = NO;
    if (imagePicker == nil) {
        imagePicker = [[UIImagePickerController alloc] init];
    }
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    timeLabel.center = CGPointMake(SCREENWIDTH/2, 130);
    timeLabel.font = [UIFont systemFontOfSize:17];
    timeLabel.text = @"00:00/60:00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:timeLabel];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREENWIDTH-40)/2, SCREENHEIGHT-140, 40, 10)];
    pageControl.numberOfPages = 6;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    pageControl.pageIndicatorTintColor = WHITECOLOR;
    [self.view addSubview:pageControl];
    
    UILabel*recordLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-70)/2, SCREENHEIGHT-175, 70, 30)];
    recordLabel.text = @"录音";
    recordLabel.textAlignment = NSTextAlignmentCenter;
    recordLabel.textColor = [UIColor whiteColor];
    recordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:recordLabel];
    for (int i = 0; i<2; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0)
        {
            btn.frame = CGRectMake(8, SCREENHEIGHT-50, 70, 30);
            [btn setTitle:@"重录" forState:UIControlStateNormal];
        }else if(i==1)
        {
            btn.frame = CGRectMake(SCREENWIDTH-78, SCREENHEIGHT-50, 70, 30);
            [btn setTitle:@"保存" forState:UIControlStateNormal];
            
        }
        btn.tag = 1000+i;
        btn.alpha = 0;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor colorWithRed:0.957 green:0.816 blue:0.51 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"recordbtn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:btn];
        });
    }
    
    UIButton*backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"recordback"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    MVmodel = [UIButton buttonWithType:UIButtonTypeCustom];
    MVmodel.frame = CGRectMake(SCREENWIDTH-65, 30, 55, 30);
    [MVmodel setTitle:@"MV模式" forState:UIControlStateNormal];
    [MVmodel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    MVmodel.layer.borderWidth = 1;
    MVmodel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    MVmodel.titleLabel.font = [UIFont systemFontOfSize:14];
    [MVmodel addTarget:self action:@selector(takeVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:MVmodel];
}


-(void)recordAction
{
    [MVmodel setHidden:YES];
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    for (int i = 0; i<2; i++)
    {
        UIButton*btn = (UIButton*)[self.view viewWithTag:1000+i];
        btn.alpha = 1;
    }
    UIButton*recordBtn = (UIButton*)[self.view viewWithTag:999];
    if (flagRecord ==NO)
    {
        recordBtn.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        if (!flag)
        {
            
            peakPowerArray = [[NSMutableArray alloc] init];
            averagePowerArray  = [[NSMutableArray alloc]init];
            
            voiceInfo = [[VoiceInfo alloc]init];
            NSError*error1 = nil;
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
            NSLog(@"error1 = %@",error1);
            [audioSession setActive:YES error:nil];
            NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 11025.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,[NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,nil];
            voiceInfo.dateStr = [self updateLabel];
            tmpFile = [NSURL fileURLWithPath:
                       [NSTemporaryDirectory() stringByAppendingPathComponent:
                        [NSString stringWithFormat:@"%@",
                         voiceInfo.dateStr]]];
            voiceInfo.url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",voiceInfo.dateStr]]];
            NSError*error = nil;
            recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:setting error:&error];
            NSLog(@"%@",error);
            recorder.meteringEnabled = YES;
            [recorder setDelegate:self];
            [recorder prepareToRecord];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
            [timer fire];
            [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [recorder record];
        });
        flagRecord = YES;
    }else
    {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        recordBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
        //        [self.recordView commitRecording];
        voiceInfo.sumTime = sumTime;
        flag = YES;
        [recorder pause];
//        [audioSession setActive:NO error:nil];
        
        [timer invalidate];
        //        [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
        flagRecord = NO;
        //        });
    }
}

-(NSString*)updateLabel {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    int y = (int)[dd year];
    int m =  (int)[dd month];
    int d =  (int)[dd day];
    
    int hour =  (int)[dd hour];
    int min =  (int)[dd minute];
    int sec =  (int)[dd second];
    
    
    return [NSString stringWithFormat:@"%d-%d-%d-%d-%d-%d",y,m,d,hour,min,sec];
}
-(void)timer
{
    if (recorder.isRecording)
    {
        sumTime = recorder.currentTime;
        int second = (int)recorder.currentTime%60;
        int mimute = (int)recorder.currentTime/60>60?(int)recorder.currentTime/60%60:(int)recorder.currentTime/60;
        //        int hour = (int)recorder.currentTime/60>60?(int)recorder.currentTime/60/60:00;
        dispatch_async(dispatch_get_main_queue(), ^{
            page++;
            //            if (page%2)
            //            {
            //                pageControl.currentPage = (page+1)/2%6;
            //            }
            if (!(page%3))
            {
                pageControl.currentPage = ((page+3)/3-1)%6;
            }
            
            [self detectionVoice];
            timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d/60:00",mimute,second];
            if (second==3600)
            {
                [timer invalidate];
                
                //                UIButton*btn = (UIButton*)[self.view viewWithTag:1001];
                //                btn.enabled = YES;
                //                UIButton*btn1 = (UIButton*)[self.view viewWithTag:1002];
                //                btn1.enabled = NO;
                UIButton*recordBtn = (UIButton*)[self.view viewWithTag:999];
                recordBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
                flagRecord = NO;
                
                voiceInfo.sumTime = sumTime;
                flag = NO;
                [timer invalidate];
                [recorder stop];
//                AVAudioSession*audioSession = [AVAudioSession sharedInstance];
//                [audioSession setActive:NO error:nil];
                
                UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:@"保存" forState:UIControlStateNormal];
                [self saveAction:btn];
            }
        });
    }
}
- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    //    double lowPassResults = pow(10, (0.05 * ));
    [peakPowerArray addObject:[NSString stringWithFormat:@"%f",-[recorder peakPowerForChannel:0]]];
    [averagePowerArray addObject:[NSString stringWithFormat:@"%f",recorder.currentTime]];
    
    if (viewRecording==nil)
    {
        viewRecording = [[ViewForRecordMeters alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        viewRecording.backgroundColor = [UIColor clearColor];
        
        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 80)];
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scroll];
        [scroll addSubview:viewRecording];
    }
    viewRecording.peakPowerArray = peakPowerArray;
    viewRecording.averagePowerArray = averagePowerArray;
    scroll.contentSize = CGSizeMake(peakPowerArray.count*4, 80);
    viewRecording.frame = CGRectMake(0, 0, peakPowerArray.count*4, 80);
    
    if (peakPowerArray.count*4>SCREENWIDTH)
    {
        scroll.contentOffset = CGPointMake(peakPowerArray.count*4-SCREENWIDTH, 0);
    }
    [scroll setNeedsDisplay];
    [viewRecording setNeedsDisplay];
    
    //最大50  0
    //图片 小-》大
    //    if (0<lowPassResults<=0.05) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice12.png"]];
    //    }else if (0.05<lowPassResults<=0.10) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice1.png"]];
    //        NSLog(@"%f====%f",-[recorder peakPowerForChannel:0],-[recorder averagePowerForChannel:0]);
    //    }else if (0.10<lowPassResults<=0.15) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice2.png"]];
    //    }else if (0.15<lowPassResults<=0.20) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice3.png"]];
    //    }else if (0.20<lowPassResults<=0.25) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice4.png"]];
    //    }else if (0.25<lowPassResults<=0.30) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice5.png"]];
    //    }else if (0.30<lowPassResults<=0.35) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice6.png"]];
    //    }else if (0.35<lowPassResults<=0.40) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice7.png"]];
    //    }else if (0.40<lowPassResults<=0.45) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice8.png"]];
    //    }else if (0.45<lowPassResults<=0.50) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice9.png"]];
    //    }else if (0.50<lowPassResults<=0.55) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice10.png"]];
    //    }else if (0.55<lowPassResults) {
    //        [self.imageview setImage:[UIImage imageNamed:@"voice11.png"]];
    //    }
}


- (NSString *)audio_PCMtoMP3
{
    NSString*str = [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@",
                     voiceInfo.dateStr]];
    //    NSLog(@"%@",str);
    NSString *mp3FileName = [str lastPathComponent];
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:voicePath])
    {
        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *mp3FilePath = [voicePath stringByAppendingPathComponent:mp3FileName];

    
    @try {
        int read, write;
        
        FILE *pcm = fopen([str cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
//        NSLog(@"==%s",[[NSHomeDirectory() stringByAppendingPathComponent:[str lastPathComponent]] cStringUsingEncoding:1]);
        if(pcm == NULL)
        {
            NSLog(@"file not found");
        }
        else
        {
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        return @"";
    }
    @finally {
        str = mp3FilePath;
        NSLog(@"MP3生成成功: %@",str);
        return str;
    }
}


-(void)saveAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"保存"])
    {
        
        //        if (recorder.recording)
        //        {
        //            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先暂停录制再保存" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        //            [alert show];
        //        }else
        //        {
        flag = NO;
        [timer invalidate];
        [recorder stop];
//        AVAudioSession*audioSession = [AVAudioSession sharedInstance];
//        [audioSession setActive:NO error:nil];
        flagRecord = NO;
        UIButton*recordBtn = (UIButton*)[self.view viewWithTag:999];
        NSString *voicePath = [self audio_PCMtoMP3];
        recordBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
        if (voicePath.length > 0) {
            ClassifyViewController *classify = [[ClassifyViewController alloc]init];
            classify.voicePath = voicePath;
            [self presentViewController:classify animated:YES completion:^{
                
            }];
        }
        else
            [Common showMessage:@"出现错误，请重新再录" withView:self.view];
        
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"保存录音文件名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [alert show];
        //        }
    }else if ([btn.titleLabel.text isEqualToString:@"重录"])
    {
        flag = NO;
        [timer invalidate];
        [recorder stop];
//        AVAudioSession*audioSession = [AVAudioSession sharedInstance];
//        [audioSession setActive:NO error:nil];
        flagRecord = NO;
        [self recordAction];
        [peakPowerArray removeAllObjects];
        [averagePowerArray removeAllObjects];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex ==1)
//    {
//        [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
//        if ([alertView textFieldAtIndex:0].text!=nil)
//        {
//            info.name =[alertView textFieldAtIndex:0].text;
//        }else
//        {
//            info.name = info.dateStr;
//        }
//        info.sumTime = sumTime;
//        [self saveDataIntoLibrary];
//        
//        [timer invalidate];
//        [recorder stop];
//        [peakPowerArray removeAllObjects];
//        [averagePowerArray removeAllObjects];
//        flag = NO;
//    }
//}
-(void)saveDataIntoLibrary
{
//    [[DealData dealDataClass] saveVoice:info];
    
}
-(void)backAction
{
    [timer invalidate];
    [recorder stop];
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (MVmodel!=nil)
    {
        [MVmodel setHidden:NO];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    UIButton*recordBtn = (UIButton*)[self.view viewWithTag:999];
    recordBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    voiceInfo.sumTime = sumTime;
    //    flag = YES;
    [recorder stop];
//    [audioSession setActive:NO error:nil];
    
    [timer invalidate];
    //        [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
    flagRecord = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拍摄视频
- (void)takeVideo {

    if (flagRecord)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [Common showMessage:@"该设备没有摄像头" withView:self.view];
            return;
        }
        if (![[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeMovie]) {
            [Common showMessage:@"不支持录制的视频类型" withView:self.view];
            return;
        }
        if (timer.isValid)
        {
            [timer invalidate];
        }
//        if (recorder.isRecording)
//        {
//        [recorder stop];
//        AVAudioSession*audioSession = [AVAudioSession sharedInstance];
//        [audioSession setCategory:nil error:nil];
//        [audioSession setActive:NO error:nil];
//        }
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePicker.showsCameraControls = YES;
        imagePicker.videoMaximumDuration = 300;
        imagePicker.delegate = self;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:imagePicker animated:YES completion:^{
//                [recorder stop];
//                AVAudioSession*audioSession = [AVAudioSession sharedInstance];
//                [audioSession setCategory:nil error:nil];
//                [audioSession setActive:NO error:nil];
            }];
        });
        
    }
}


#pragma mark-
#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
            NSString *path = (NSString *)[[info valueForKey:UIImagePickerControllerMediaURL] path];
            
            [self.view addSubview:indicator];
            // 保存视频
            [self video:path didFinishSavingWithError:nil contextInfo:nil];
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
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"];
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:videoName];
    NSURL *tempUrl = [NSURL fileURLWithPath:documentsDirectory];
    NSLog(@"tempUrl=%@,documentsDirectory=%@",tempUrl,documentsDirectory);
    
//    VideoModel *model = [[VideoModel alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //压缩视频
        [self lowQuailtyWithInputURL:pathUrl outputURL:tempUrl blockHandler:^(AVAssetExportSession *session){
            if(session.status == AVAssetExportSessionStatusCompleted){
                NSLog(@"success!");
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    ClassifyViewController *viewController = [[ClassifyViewController alloc] init];
                    
                    viewController.voicePath = documentsDirectory;
                    [self presentViewController:viewController animated:YES completion:nil];
                    [indicator removeFromSuperview];
                });
            }else if (session.status == AVAssetExportSessionStatusFailed){
                NSLog(@"error = %@",session.error);
                [Common deleteFile:pathUrl.path];
                [self showFailMessage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator removeFromSuperview];
                });
            }
            else
            {
                NSLog(@"压缩视频失败！");
                [self showFailMessage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator removeFromSuperview];
                });
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


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

//时间戳+随机数生成上传视频名称
-(NSString *)getUploadVideoName {
    NSString *currentDate = [Common getCurrentDate:@"yyyyMMddHHmmss"];
    NSString *randomStr = [[NSMutableString alloc] init] ;
    for (int i = 0; i < 4; i++) {
        long random = arc4random()%100000;
        randomStr = [randomStr stringByAppendingString:[NSString stringWithFormat:@"%ld",random]];
    }
    NSString *videoName = [NSString stringWithFormat:@"%@%@",currentDate,randomStr];
    return videoName;
}

-(void) showFailMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Common showMessage:@"出现错误，请重新选择" withView:self.view];
        [indicator removeFromSuperview];
    });
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
