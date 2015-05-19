//
//  GroudMemberView.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "GroudMemberView.h"

@interface GroudMemberView ()

@end

@implementation GroudMemberView
@synthesize memberArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    self.title = [NSString stringWithFormat:@"群成员(%ld人)",memberArray.count];
    [self initSetView];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
}
-(void)initSetView
{
    int a,b;
    a = (int)((int)40+2)/4;
    b = ((int)40+2)%4;
    if (b>0)
    {
        a = a + 1;
    }
    
    if ((SCREENWIDTH/4+25)*a>SCREENHEIGHT-60)
    {
        baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-60)];
    }else
    {
        baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (SCREENWIDTH/4+20)*a)];
    }
    
    baseView.backgroundColor = WHITECOLOR;
    baseView.contentSize = CGSizeMake(SCREENWIDTH, (SCREENWIDTH/4+20)*a);
    [self.view addSubview:baseView];
//    memberArray.count
    for (int i = 0; i<40+2; i++)
    {
        UIImageView*image = (UIImageView*)[baseView viewWithTag:10000+i];
        if (image==nil)
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(15+SCREENWIDTH/4*(i%4), 15+(int)(i/4)*(SCREENWIDTH/4+20), SCREENWIDTH/4-30, SCREENWIDTH/4-30)];
        }
        
        image.userInteractionEnabled = YES;
        UILabel*titleLabel = (UILabel*)[baseView viewWithTag:20000+i];
        if (titleLabel==nil)
        {
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x, image.frame.origin.y+image.frame.size.height+3, image.frame.size.width, 30)];
        }
        
        titleLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i==40)
        {
            image.image = [UIImage imageNamed:@"groudAdd.jpg"];
            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addMember)];
            [image addGestureRecognizer:tap];
        }else if (i==40+1)
        {
            image.image = [UIImage imageNamed:@"groudDelete"];
            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteMember)];
            [image addGestureRecognizer:tap];
        }else
        {
            image.image = [UIImage imageNamed:@"groudDelete"];
            titleLabel.text = @"名称dafrdghfjg";
        }
        image.tag = 10000+i;
        titleLabel.tag = 20000+i;
        
        [baseView addSubview:titleLabel];
        [baseView addSubview:image];
    
    }
    UIButton*sureExitBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, baseView.frame.size.height+baseView.frame.origin.y+16, SCREENWIDTH-16, 35)];
    sureExitBtn.layer.masksToBounds = YES;
    [sureExitBtn setBackgroundColor:[UIColor colorWithRed:252/255.0 green:66/255.0 blue:70/255.0 alpha:1]];
    sureExitBtn.layer.cornerRadius = 5;
    [sureExitBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
    sureExitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [sureExitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureExitBtn];
}
-(void)addMember
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"backChatView" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"backChatView" object:nil];
    GroudMemberAddView *groudMemberAdd = [[GroudMemberAddView alloc]init];
    groudMemberAdd.viewController = self.viewController;
    [self.navigationController pushViewController:groudMemberAdd animated:YES];
}
-(void)deleteMember
{
    if (flagDelete==0)
    {
        for (int i = 1; i<40; i++)
        {
            UIImageView*image = (UIImageView*)[baseView viewWithTag:10000+i];
            UIImageView*deleImage = [[UIImageView alloc]initWithFrame:CGRectMake(-6, -6, 20, 20)];
            deleImage.image = [UIImage imageNamed:@"memberDelete"];
            deleImage.tag = image.tag+20000;
            [image addSubview:deleImage];
            deleImage.userInteractionEnabled = YES;
            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteSure:)];
            [deleImage addGestureRecognizer:tap];
        }
        flagDelete = 1;
    }else
    {
        for (int i = 1; i<40; i++)
        {
            UIImageView*image = (UIImageView*)[baseView viewWithTag:30000+i];
            [image removeFromSuperview];
        }
        flagDelete = 0;
    }
    
}
-(void)deleteSure:(UITapGestureRecognizer*)tap
{
    NSLog(@"删除===%ld",tap.view.tag);
}
-(void)exitAction
{
//    ChatView*chatview = [[ChatView alloc]init];
    [self.navigationController popToViewController:self.chatListController animated:YES];
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
