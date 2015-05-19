//
//  BaseViewController.m
//  CAVmap
//
//  Created by 3024 on 14-10-18.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize navView,backButton,searchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.hidden = YES;  // 隐藏自带的导航栏
//    self.navigationController.navigationBar.alpha = 0;
    [self initCustomNavgationBar];  // 自定义导航栏
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//     self.navigationController.navigationBar.alpha = 0;
}
// 标题
- (void)setTitle:(NSString *)title
{
    // 标题视图
    UILabel *titleView = [[UILabel alloc] initWithFrame:kFrame(kScreenWidth/2 - 20, 20, 80, 40)];
    titleView.center = CGPointMake(kScreenWidth/2 + 10, 40);
    titleView.text = title;
    titleView.font = [UIFont systemFontOfSize:16];
    titleView.minimumScaleFactor = 12;
    titleView.adjustsFontSizeToFitWidth = YES;
    titleView.textColor = [UIColor blackColor];
    [navView addSubview:titleView];
}

// 自定义导航栏
- (void)initCustomNavgationBar
{
    navView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];  //
    //
    navView.blurTintColor = [UIColor blackColor];  // 测试
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 40, 25)];  // 按钮的frame
    [backButton addTarget:self action:@selector(backButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];  // 添加返回的方法
    //    backButton.backgroundColor = [UIColor redColor];  // 测试
//    [backButton setImage:[UIImage imageNamed:@"barbuttonicon_back@2x"] forState:0];  // 设置图片
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [navView addSubview:backButton];   // 将按钮加载到视图
    [self.view addSubview:navView];
}

- (void)addRightMapButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = kFrame(kScreenWidth - 70, 25, 60, 28);
    [btn addTarget:self action:@selector(transformToMapView:) forControlEvents:UIControlEventTouchUpInside];  // 添加方法
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    // 设置圆角
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = NO;
    [navView addSubview:btn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_view_map.png"] highlightedImage:[UIImage imageNamed:@"topbar_view_map.png"]];
    imageView.frame = kFrame(5, 2.5, 20, 20);
    [btn addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kFrame(27.5, 3, 30, 20)];
    titleLabel.text = @"地图";
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor colorWithRed:10/255.0 green:95/255.0 blue:254/255.0 alpha:1];
    [btn addSubview:titleLabel];
    
}

// 添加搜索按钮
- (void)addSearchButton
{
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = kFrame(kScreenWidth - 50, 25, 40, 26);
    [searchButton addTarget:self action:@selector(searchButtonClicksAction:) forControlEvents:UIControlEventTouchUpInside];  // 添加方法
    searchButton.layer.borderWidth = 0.5;
    searchButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    // 设置圆角
    searchButton.layer.cornerRadius = 3;
    searchButton.layer.masksToBounds = NO;
    [navView addSubview:searchButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kFrame(0, 0, 40, 26)];
    titleLabel.text = @"搜索";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [searchButton addSubview:titleLabel];
}

#pragma mark - 点击方法

// 切换到地图视图的方法
- (void)transformToMapView:(UIButton *)sender
{
    // 去地图的方法
    NSLog(@"切换到地图视图");
}

// 点击搜索的方法
- (void)searchButtonClicksAction:(UIButton *)sender
{
    NSLog(@"点击搜索的方法");
}

// 返回按钮事件
- (void)backButtonClickAction:(UIButton *)sender
{
    //    NSLog(@"返回按钮按了");
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
