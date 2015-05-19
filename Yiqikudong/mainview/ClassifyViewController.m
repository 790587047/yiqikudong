//
//  ClassifyViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/3/10.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ClassifyViewController.h"
#import "AddVoiceImageViewController.h"
#import "Common.h"

//选中字体颜色
#define SELECTEDLETTERCOLOR     [UIColor colorWithRed:255.0/255.0 green:245.0/255.0 blue:208.0/255.0 alpha:1.0]
//未被选中字体颜色
#define UNSELECTEDLETTERCOLOR   [UIColor colorWithRed:162.0/255.0 green:128.0/255.0 blue:39.0/255.0 alpha:1.0] 
//选中button的背景色
#define SELECTEDBUTTONBGCOLOR   [UIColor colorWithRed:246.0/255.0 green:101.0/255.0 blue:35.0/255.0 alpha:1.0]
//未被选中button的背景色
#define UNSELECTEDBUTTONBGCOLOR [UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:231.0/255.0 alpha:1.0]

@interface ClassifyViewController ()

@end

@implementation ClassifyViewController{
    NSInteger selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex = -1;
    self.view.backgroundColor = WHITECOLOR;
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    });
}

//初始化页面
-(void)initView{
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recordbackground" ofType:@"jpg"]];
    bgImageView.alpha = .5f;
    [self.view addSubview:bgImageView];
    
    //导航栏
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:topView];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setFrame:CGRectMake(10, 30, 50, 30)];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [btnLeft setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnLeft];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [lblTitle setText:@"选择分类"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(SCREENWIDTH - 80, btnLeft.frame.origin.y, 80, 30)];
    [btnRight setTitle:@"下一步" forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [btnRight setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnRight];
    
    UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(5, 74, 200, 40)];
    lblInfo.text = @"为声音选个分类";
    [lblInfo setTextColor:UNSELECTEDLETTERCOLOR];
    [lblInfo setFont:[UIFont systemFontOfSize:18.0f]];
    [self.view addSubview:lblInfo];
    
    //分类按钮
    NSArray *buttonTitles = @[@"音乐",@"电影",@"相声",@"新闻资讯",@"百家讲坛",@"戏曲",@"儿童",@"IT科技",@"校园",@"健康养生",@"外语",@"财经",@"体育",@"其他"];
    
    CGFloat y = lblInfo.frame.size.height + lblInfo.frame.origin.y + 10;
    CGFloat width = SCREENWIDTH / 3 - 25;
    CGFloat height = 30;
    CGFloat x ;
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        
        if (i > 0 && i % 3 == 0) {
            int t = i % 3;
            y = y + height + 20;
            x = t * width + (t+1)*20;
        }
        else{
            int t = i;
            if (i > 3) {
                t = t % 3;
            }
            x = t * width + (t+1)*20;
        }
        if (i == buttonTitles.count - 1) {
            [self selectedButtonStyle:button];
            selectedIndex = i;
        }
        else
            [self unSelectedButtonStyle:button];
        [button setFrame:CGRectMake(x, y, width, height)];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}


//未被选中按钮样式
-(void) unSelectedButtonStyle : (UIButton *) button{
    button.selected = NO;
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:[[UIColor colorWithRed:186.0/255.0 green:158.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    [button setTitleColor:UNSELECTEDLETTERCOLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [button setBackgroundColor:UNSELECTEDBUTTONBGCOLOR];
}


//选中按钮样式
-(void) selectedButtonStyle : (UIButton *) sender{
    sender.selected = YES;
    sender.backgroundColor = SELECTEDBUTTONBGCOLOR;
    [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [sender setTitleColor:SELECTEDLETTERCOLOR forState:UIControlStateNormal];
}

//选中按钮修改样式
-(void) buttonSelected:(UIButton *) sender{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag != sender.tag && btn.selected) {
                [self unSelectedButtonStyle:btn];
                break;
            }
        }
    }
    selectedIndex = sender.tag - 10000;
    [self selectedButtonStyle:sender];
}

-(void) nextStep{
    if (selectedIndex > -1) {
        AddVoiceImageViewController *viewController = [[AddVoiceImageViewController alloc] init];
        viewController.classId = selectedIndex + 1;
        viewController.voiceSavePath = _voicePath;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else{
        [Common showMessage:@"请先选择类别再点击下一步" withView:self.view];
    }
}

//返回按钮事件
-(void) goback{
    [self dismissViewControllerAnimated:YES completion:nil];
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
