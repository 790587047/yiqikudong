//
//  HomeViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/5/13.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserCenterController.h"

@interface HomeViewController : UserCenterController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) UIView        *firstView;
@property (nonatomic, strong) UIView        *moreView;

@property (nonatomic, strong) UIView        *conView;
@property (nonatomic, strong) UIView        *picView;
@property (nonatomic, strong) UIScrollView  *picScrollView;
@property (nonatomic, strong) UIPageControl *picPageControl;
@property (nonatomic, strong) NSTimer       *picTimer;

@end
