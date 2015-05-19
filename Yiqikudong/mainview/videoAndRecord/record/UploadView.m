//
//  UploadView.m
//  YiQiWeb
//
//  Created by BK on 15/1/8.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "UploadView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoListViewController.h"
@interface UploadView ()

@end

@implementation UploadView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backbutton.tintColor = WHITECOLOR;
    self.navigationItem.leftBarButtonItem = backbutton;
    
    self.title = @"上传";
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    self.view.layer.backgroundColor = colorref;
    
    UITextField*textfild;
    if (isPad)
    {
        textfild = [[UITextField alloc]initWithFrame:CGRectMake(5, 5+44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH-10, 55)];
    }else
    {
        textfild = [[UITextField alloc]initWithFrame:CGRectMake(5, 5+44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH-10, 35)];
    }
    
    textfild.placeholder = @" 标题";
    textfild.delegate = self;
    textfild.tag = 1200;
    textfild.backgroundColor = WHITECOLOR;
    [self.view addSubview:textfild];
    
    UIView*view;
    UIImageView*imageview;
    
    if (isPad)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(5, 65+44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH-10, 390)];
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 200)];
        
    }else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(5, 45+44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH-10, 190)];
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 110)];
        
    }
    
    view.backgroundColor = WHITECOLOR;
    view.tag = 1100;
    [self.view addSubview:view];
    
    imageview.center = CGPointMake((SCREENWIDTH-10)/2, view.frame.size.height/2);
    imageview.image = [UIImage imageNamed:@"voice12"];
    [view addSubview:imageview];
    
    for (int i = 0; i<2; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isPad)
        {
            btn.frame = CGRectMake(5+SCREENWIDTH/2*i, 460+TbarHeight, (SCREENWIDTH-20)/2, 55);
            btn.titleLabel.font = [UIFont systemFontOfSize:25];
        }else
        {
            btn.frame = CGRectMake(5+SCREENWIDTH/2*i, 240+TbarHeight, (SCREENWIDTH-20)/2, 35);
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
       
        if (i==0)
        {
            [btn setTitle:@"本地录音" forState:UIControlStateNormal];
        }else
        {
            [btn setTitle:@"录一段" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = WHITECOLOR;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIButton*delegateBtn;
    delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isPad)
    {
        delegateBtn.frame = CGRectMake(5, 517+TbarHeight, 310, 41);
        [delegateBtn setImage:[UIImage redraw:[UIImage imageNamed:@"selected"] Frame:CGRectMake(0, 0, 38, 38)] forState:UIControlStateNormal];
        delegateBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    }else
    {
        delegateBtn.frame = CGRectMake(5, 342, 180, 21);
        [delegateBtn setImage:[UIImage redraw:[UIImage imageNamed:@"selected"] Frame:CGRectMake(0, 0, 18, 18)] forState:UIControlStateNormal];
        delegateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    [delegateBtn setTitle:@"我已阅读并接受上传协议" forState:UIControlStateNormal];
    [delegateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [delegateBtn addTarget:self action:@selector(delegateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    agreeFlag = YES;
    
    delegateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:delegateBtn];
    
    uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isPad)
    {
        uploadBtn.frame = CGRectMake(5, 565+TbarHeight, SCREENWIDTH-10, 70);
        uploadBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
    }else
    {
        uploadBtn.frame = CGRectMake(5, 370, SCREENWIDTH-10, 50);
        uploadBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    }
    
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    
    [uploadBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    uploadBtn.backgroundColor = [UIColor redColor];
    uploadBtn.enabled = NO;
    [uploadBtn addTarget:self action:@selector(uploadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
    
    
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"uploadVoice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVoice:) name:@"uploadVoice" object:nil];
    
    
}



-(void)uploadVoice:(NSNotification*)info
{
    
    NSDictionary *dict = [info userInfo];
    
    voiceInfo = [dict objectForKey:@"selectedVoice"];
    UITextField*textfield = (UITextField*)[self.view viewWithTag:1200];
    textfield.text = voiceInfo.name;
    UIView*view = [self.view viewWithTag:1100];
    for (UIView*subview in view.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            [subview removeFromSuperview];
        }
    }
    UILabel*timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    timeLabel.center = CGPointMake(SCREENWIDTH/2, view.frame.size.height-20);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    int second = (int)voiceInfo.sumTime%60;
    int mimute = ((int)voiceInfo.sumTime - second)/60>60?((int)voiceInfo.sumTime - second)/60%60:((int)voiceInfo.sumTime - second)/60;
    int hour = ((int)voiceInfo.sumTime - second)/60>60?((int)voiceInfo.sumTime - second)/60/60:0;
    timeLabel.text = [NSString stringWithFormat:@"%d:%d:%d",hour,mimute,second];
    [view addSubview:timeLabel];
    
    uploadBtn.enabled = YES;
}
-(void)btnAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"本地录音"])
    {
        [self localUpload];
    }else if ([btn.titleLabel.text isEqualToString:@"录一段"])
    {
        [self recordVoice];
    }
}
-(void)localUpload
{
    LocalVoiceView *localUploadView = [[LocalVoiceView alloc]init];
    [self.navigationController pushViewController:localUploadView animated:YES];
}
-(void)recordVoice
{
    RecordingView*recordingView = [[RecordingView alloc]init];
    [self.navigationController pushViewController:recordingView  animated:YES];
}


-(void)uploadBtnAction
{
    UITextField*textfield = (UITextField*)[self.view viewWithTag:1200];
    if (textfield.text ==nil)
    {
        [self showMessage:@"标题不能为空，请输入标题"];
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"，标题不能为空，请输入标题" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alert show];
        return;
    }
    if (agreeFlag)
    {
        [[DealData dealDataClass]saveUploadVoice:voiceInfo];
        VideoListViewController*uploadTable = [[VideoListViewController alloc]init];
        uploadTable.kind = self.kind;
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:uploadTable animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadVoiceSuccess" object:nil];
        });
        
        
    }else
    {
        [self showMessage:@"请阅读并勾选相关协议"];
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请阅读并勾选相关协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
    }
}

//显示错误提示
-(void) showMessage:(NSString *) msg{
    ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:msg];
    [self.view addSubview:remiderView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];//动画运行时间
        remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
        [UIView commitAnimations];//提交动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [remiderView removeFromSuperview];
        });
    });
}


-(void)delegateBtnAction:(UIButton*)btn
{
    if (agreeFlag)
    {
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"unSelected"] Frame:CGRectMake(0, 0, 20, 20)] forState:UIControlStateNormal];
        agreeFlag = NO;
    }else
    {
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"selected"] Frame:CGRectMake(0, 0, 20, 20)] forState:UIControlStateNormal];
        agreeFlag = YES;
    }
}

#pragma mark textfield--delagate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
