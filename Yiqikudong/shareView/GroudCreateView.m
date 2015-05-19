//
//  GroudCreateView.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "GroudCreateView.h"

@interface GroudCreateView ()

@end

@implementation GroudCreateView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;

    self.title = @"创建群聊";
    [self initSetView];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
}
-(void)initSetView
{
    titleText = [[UITextField alloc]initWithFrame:CGRectMake(8, TbarHeight+10, SCREENWIDTH-16, 35)];
    titleText.layer.cornerRadius = 5;
    titleText.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    titleText.layer.borderWidth = 1;
    titleText.delegate = self;
    titleText.placeholder = @"请输入群组名称";
    titleText.backgroundColor = WHITECOLOR;
    [self.view addSubview:titleText];
    //给textfield添加左视图实现光标右移
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 35)];
    titleText.leftView = paddingView;
    titleText.leftViewMode = UITextFieldViewModeAlways;
    
    
    if (SCREENWIDTH>320)
    {
        descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(8,titleText.frame.size.height+titleText.frame.origin.y+12, SCREENWIDTH-16, 150)];
    }else
    {
        descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(8,titleText.frame.size.height+titleText.frame.origin.y+12, SCREENWIDTH-16, 130)];
    }
    descriptionText.font = [UIFont systemFontOfSize:17];
    self.automaticallyAdjustsScrollViewInsets = NO;
    descriptionText.delegate = self;
    descriptionText.layer.cornerRadius = 5;
    descriptionText.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    descriptionText.layer.borderWidth = 1;
    [self.view addSubview:descriptionText];
    placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    placeholderLabel.textColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:208/255.0 alpha:1];
    placeholderLabel.text = @"请输入群组简介";
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
    switchBtn1 = [[UISwitch alloc]initWithFrame:CGRectMake(baseView.frame.size.width-60, 8, 40, 40)];
    switchBtn2 = [[UISwitch alloc]initWithFrame:CGRectMake(baseView.frame.size.width-60, 8+50, 40, 40)];
    for (int i = 0; i<2; i++)
    {
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+i*50, 200, 40)];
        label.textColor = [UIColor blackColor];
        
        if (i==0)
        {
            label.text=@"身份验证";
            switchBtn1.on = NO;
            [baseView addSubview:switchBtn1];
        }else if (i==1)
        {
            label.text=@"允许成员加入进群";
            switchBtn2.on = YES;
            [baseView addSubview:switchBtn2];
        }
        [baseView addSubview:label];
        
    }
    
    UIButton*sureChangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, baseView.frame.size.height+baseView.frame.origin.y+16, SCREENWIDTH-16, 45)];
    sureChangeBtn.layer.masksToBounds = YES;
    [sureChangeBtn setBackgroundColor:[UIColor colorWithRed:29/255.0 green:186/255.0 blue:59/255.0 alpha:1]];
    sureChangeBtn.layer.cornerRadius = 5;
    [sureChangeBtn setTitle:@"立即创建" forState:UIControlStateNormal];
    sureChangeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [sureChangeBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureChangeBtn];
}
-(void)sureAction
{
    NSLog(@"%u==%u",switchBtn1.on,switchBtn2.on);
    
}


//检查群名是否已存在
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"结束，可以检查名字存在否");
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
    [titleText resignFirstResponder];
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
