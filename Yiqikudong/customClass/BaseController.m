//
//  BaseController.m
//  YiQiWeb
//
//  Created by BK on 14/12/26.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "BaseController.h"

@implementation BaseController
-(void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.alpha = 0;
////     Do any additional setup after loading the view.
//    UIView*navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
//    navView.backgroundColor = [UIColor blackColor];
//    if (self.navigationItem.titleView!=nil)
//    {
//        
//        [navView addSubview:self.navigationItem.titleView];
//    }else if(self.navigationItem.title!=nil)
//    {
//        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2, 40)];
//        title.center = CGPointMake(SCREENWIDTH/2, 40);
//        title.text = self.navigationItem.title;
//    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
