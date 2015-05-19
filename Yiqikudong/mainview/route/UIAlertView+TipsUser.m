//
//  UIAlertView+TipsUser.m
//  CAVmap
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "UIAlertView+TipsUser.h"
#import "AppDelegate.h"
@implementation UIAlertView (TipsUser)

+ (void)showAlertViewWithMessage:(NSString*)message buttonTitles:(NSString *)buttonTitles, ...NS_REQUIRES_NIL_TERMINATION
{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:buttonTitles, nil];
//    [alert show];
    ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:message];
    AppDelegate*app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:remiderView];
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

@end
