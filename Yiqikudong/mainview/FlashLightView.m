//
//  FlashLightView.m
//  YiQiWeb
//
//  Created by BK on 14/12/22.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "FlashLightView.h"
#import "Common.h"

@interface FlashLightView ()

@end

@implementation FlashLightView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手电筒";
    

    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithTitle:@"闪烁" style:UIBarButtonItemStylePlain target:self action:@selector(blink:)];
    btnMore.tag = 1300;
    btnMore.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    
    UIImageView*imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH, SCREENHEIGHT-(44+[UIApplication sharedApplication].statusBarFrame.size.height))];
    imageview.userInteractionEnabled = YES;

    imageview.image = [UIImage imageNamed:@"flashlight_led_bg"];
    [self.view addSubview:imageview];
    
    UIImageView*lightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/2)];
    lightView.image = [UIImage imageNamed:@"flashlight_light_off"];
    lightView.tag = 1200;
    lightView.userInteractionEnabled = YES;
    [imageview addSubview:lightView];
    
    UIImageView*light = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
//    light.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT-SCREENHEIGHT*3/8);
    light.image = [UIImage imageNamed:@"flashlight_led_body_bg"];
    light.userInteractionEnabled = YES;
    [imageview addSubview:light];
    NSLog(@"%@",light);
    
    UIButton*flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(0, 0, SCREENWIDTH/6, SCREENWIDTH/6);
    flashBtn.center = CGPointMake(light.frame.size.width/2, light.frame.size.height*43/64);
    [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_off"] forState:UIControlStateNormal];
    [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_off_press"] forState:UIControlStateSelected];
//    flashBtn
//    flashBtn.adjustsImageWhenDisabled = NO;
    [flashBtn addTarget:self action:@selector(lightAction) forControlEvents:UIControlEventTouchUpInside];
    flashBtn.tag = 1000;
    [light addSubview:flashBtn];
    
    AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchMode == AVCaptureTorchModeOn)
    {
        lightView.image = [UIImage imageNamed:@"flashlight_light_on"];
        [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_on"] forState:UIControlStateNormal];
        [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_on_press"] forState:UIControlStateSelected];
        flag = 1;
    }
}
//开关事件
-(void)lightAction
{
    AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch])
    {
        if (flag2==0)
        {
            [Common showMessage:@"打开手电筒失败" withView:self.view];
//            ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"打开手电筒失败"];
//            [self.view addSubview:remiderView];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationBeginsFromCurrentState:YES];
//                [UIView setAnimationDuration:0.5];//动画运行时间
//                remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//                [UIView commitAnimations];//提交动画
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [remiderView removeFromSuperview];
//                });
//            });
        }
    }else
    {
        if (flag==0)
        {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];
            flag = 1;
            UIButton*flashBtn = (UIButton*)[self.view viewWithTag:1000];
            [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_on"] forState:UIControlStateNormal];
            [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_on_press"] forState:UIControlStateSelected];
            UIImageView*lightView = (UIImageView*)[self.view viewWithTag:1200];
            lightView.image = [UIImage imageNamed:@"flashlight_light_on"];
        }else
        {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
            flag = 0;
            UIButton*flashBtn = (UIButton*)[self.view viewWithTag:1000];
            [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_off"] forState:UIControlStateNormal];
            [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_off_press"] forState:UIControlStateSelected];
            [timer invalidate];
            UIImageView*lightView = (UIImageView*)[self.view viewWithTag:1200];
            lightView.image = [UIImage imageNamed:@"flashlight_light_off"];
            UIBarButtonItem*btnMore = self.navigationItem.rightBarButtonItem;
            btnMore.title = @"闪烁";
        }
    }
}
//返回按钮
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)blink:(UIBarButtonItem*)btn
{
//    [btn setEnabled:NO];
    NSString *title = btn.title;
    if ([title isEqualToString:@"闪烁"])
    {
        AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (![device hasTorch])
        {
            [Common showMessage:@"打开手电筒失败" withView:self.view];
//            ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"打开手电筒失败"];
//            [self.view addSubview:remiderView];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationBeginsFromCurrentState:YES];
//                [UIView setAnimationDuration:0.5];//动画运行时间
//                remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//                [UIView commitAnimations];//提交动画
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [remiderView removeFromSuperview];
//                });
//            });
        }else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                [timer fire];
                [[NSRunLoop currentRunLoop]run];
            });
            UIButton*flashBtn = (UIButton*)[self.view viewWithTag:1000];
            [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_on"] forState:UIControlStateNormal];
            [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_on_press"] forState:UIControlStateHighlighted];
            flag = 1;
            UIImageView*lightView = (UIImageView*)[self.view viewWithTag:1200];
            lightView.image = [UIImage imageNamed:@"flashlight_light_on"];
            btn.title = @"关闭";
        }
    }else if ([title isEqualToString:@"关闭"])
    {
        AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
        flag = 0;
        UIButton*flashBtn = (UIButton*)[self.view viewWithTag:1000];
        [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_off"] forState:UIControlStateNormal];
        [flashBtn setImage:[UIImage imageNamed:@"flashlight_power_off_press"] forState:UIControlStateSelected];
        [timer invalidate];
        UIImageView*lightView = (UIImageView*)[self.view viewWithTag:1200];
        lightView.image = [UIImage imageNamed:@"flashlight_light_off"];
        btn.title = @"闪烁";
    }
}
-(void)timerAction
{
    AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (flag3==0)
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
        flag3 = 1;
    }else
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
        flag3 = 0;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    flag2=0;
    [timer invalidate];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
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
