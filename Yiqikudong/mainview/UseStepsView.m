//
//  UseStepsView.m
//  Yiqikudong
//
//  Created by BK on 15/4/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "UseStepsView.h"

@interface UseStepsView ()

@end

@implementation UseStepsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITECOLOR;
    //导航栏
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:topView];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setFrame:CGRectMake(0, 30, 50, 30)];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [btnLeft setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnLeft];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [lblTitle setText:@"使用步骤"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
    [self initScrollUseSteps];
    
}
-(void)initScrollUseSteps
{
    stepsScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    stepsScroll.contentSize = CGSizeMake(SCREENWIDTH*5, SCREENHEIGHT-64);
    stepsScroll.delegate = self;
    stepsScroll.pagingEnabled = YES;
    [self.view addSubview:stepsScroll];
    for (int i = 0; i<5; i++)
    {
        UIImageView*imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        if (i==4)
        {
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"step%d",i+1]];
        }else
        {
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"step%d.jpg",i+1]];
        }
        
        [stepsScroll addSubview:imageview];
    }
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-60, SCREENWIDTH, 30)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:pageControl];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControl.currentPage = (int)scrollView.contentOffset.x/SCREENWIDTH;
}
-(void)goback
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
