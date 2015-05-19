//
//  KZJMyTabBarController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Redraw.h"
#import "RecordingView.h"
#import "PlayVoiceViewController.h"
@interface MyTabBarController : UITabBarController
{
    int flag;
    int angle,flagStart;
}
@property(nonatomic,retain)UIView*baseView;
@property (nonatomic, weak)UIButton *selectedBtn;//存储上一个被选按钮
@property(nonatomic,retain)NSMutableArray*imageArr;//存储未被按的按钮背景
@property(nonatomic,retain)NSMutableArray*seletedImageArr;//存储被按的按钮背景
@property(nonatomic,retain)NSArray*titleArray;//存储标题

@property(retain,nonatomic)NSString*direction;//存储动画方向
@property(retain,nonatomic)NSMutableArray*btnArr;//存储按钮

-(id)initWithImage:(NSMutableArray*)image SeletedImage:(NSMutableArray*)seletedImage;//初始化传值
-(void)btn;//按钮初始化
@end
