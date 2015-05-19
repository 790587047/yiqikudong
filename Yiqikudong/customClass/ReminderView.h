//
//  ReminderView.h
//  YiQiWeb
//
//  Created by BK on 14/11/24.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderView : UIView

+(ReminderView*)reminderView;
+(ReminderView*)reminderView1;
+(ReminderView*)reminderViewWithTitle:(NSString*)title;
+(ReminderView*)reminderViewFrameWithTitle:(NSString*)title;

//聊天录音提示框
+(ReminderView*)reminderViewTitle:(NSString*)title withLevel:(NSString*)level withFlag:(BOOL)flag;
@end
