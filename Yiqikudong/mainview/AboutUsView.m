
//
//  AboutUsView.m
//  Yiqikudong
//
//  Created by BK on 15/4/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "AboutUsView.h"

@interface AboutUsView ()

@end

@implementation AboutUsView

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
    [lblTitle setText:@"关于我们"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
    UITextView*aboutUsText = [[UITextView alloc]initWithFrame:CGRectMake(10, 64, SCREENWIDTH-20, SCREENHEIGHT-64)];
    aboutUsText.text = @"亿启酷动（17LL.COM）是中国最权威的品牌活动策划、互动式新媒体传播、网络营销专业平台，由100多位资深品牌策划、营销及管理专家顾问团支持。亿启酷动提供最完美的O2O营销方案、免费提供活动发布、比赛投票、企业招聘等微营销服务。让商家轻营运、易招商、少投入、高效率达到品牌推广，一起共享亿万级移动互联网红利！亿启电台是其旗下的一款具有录制和上传下载等功能一体化的免费电台功能的应用，用户可以在查看活动详情的时候听一首有feel的歌，也可以上传自己的纪念曲留念。";
    self.automaticallyAdjustsScrollViewInsets = NO;
    aboutUsText.font = [UIFont systemFontOfSize:17];
    aboutUsText.editable = NO;
    [self.view addSubview:aboutUsText];
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
