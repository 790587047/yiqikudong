//
//  GroudApplyView.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "GroudApplyView.h"

@interface GroudApplyView ()

@end

@implementation GroudApplyView
@synthesize titleName,description;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    self.title = @"进群申请";
    [self initSetView];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
}
-(void)initSetView
{
    if (SCREENWIDTH>320)
    {
        descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(8,TbarHeight+10, SCREENWIDTH-16, 150)];
    }else
    {
        descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(8,TbarHeight+10, SCREENWIDTH-16, 130)];
    }
    descriptionText.delegate = self;
    descriptionText.layer.cornerRadius = 5;
    descriptionText.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    descriptionText.layer.borderWidth = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:descriptionText];
    
    placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    placeholderLabel.textColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:208/255.0 alpha:1];
    placeholderLabel.text = @"请输入验证消息";
    placeholderLabel.backgroundColor = [UIColor clearColor];
    [descriptionText addSubview:placeholderLabel];
    
    
    UIView*baseView = [[UIView alloc]initWithFrame:CGRectMake(8, descriptionText.frame.size.height+descriptionText.frame.origin.y+12, SCREENWIDTH-16, 100)];
    baseView.backgroundColor = WHITECOLOR;
    baseView.layer.cornerRadius = 5;
    baseView.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    baseView.layer.borderWidth = 1;
    [self.view addSubview:baseView];
    
    UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, baseView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
    [baseView addSubview:line];
    
    for (int i = 0; i<2; i++)
    {
        UILabel*numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, i*50, 100, 50)];
        UILabel*numberLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(110,i*50, 100, 50)];
        if (i==0)
        {
            numberLabel.text = @"群聊名称";
            numberLabel.textColor = [UIColor blackColor];
            numberLabel1.text = @"我是名称";
            numberLabel1.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        }else if (i==1)
        {
            numberLabel.text = @"群简介";
            numberLabel.textColor = [UIColor blackColor];
            numberLabel1.text = @"我是简介";
            numberLabel1.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        }
        [baseView addSubview:numberLabel];
        [baseView addSubview:numberLabel1];
        
    }
    
    UIButton*sureChangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, baseView.frame.size.height+baseView.frame.origin.y+16, SCREENWIDTH-16, 45)];
    sureChangeBtn.layer.masksToBounds = YES;
    [sureChangeBtn setBackgroundColor:[UIColor colorWithRed:29/255.0 green:186/255.0 blue:59/255.0 alpha:1]];
    sureChangeBtn.layer.cornerRadius = 5;
    [sureChangeBtn setTitle:@"申请进群" forState:UIControlStateNormal];
    sureChangeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [sureChangeBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureChangeBtn];
}
-(void)sureAction
{
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        placeholderLabel.hidden = NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [descriptionText resignFirstResponder];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
