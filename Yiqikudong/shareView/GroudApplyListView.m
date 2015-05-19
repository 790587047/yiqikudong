//
//  GroudApplyListView.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "GroudApplyListView.h"

@interface GroudApplyListView ()

@end

@implementation GroudApplyListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    self.title = @"加群验证";
    
    applyListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    applyListTable.delegate = self;
    applyListTable.dataSource = self;
    applyListTable.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    applyListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:applyListTable];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifier = @"applyListCell";
    ApplyListCell*cell = (ApplyListCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[ApplyListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.userName.text = @"测试";
    cell.userImage.image = [UIImage imageNamed:@"groudMember.jpg"];
    
    [cell.agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeBtn.tag = 1000+indexPath.row;
    [cell.rejectBtn addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.rejectBtn.tag = 2000+indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(void)agreeAction:(UIButton*)btn
{
    NSLog(@"同意===%ld",btn.tag-1000);
}
-(void)rejectAction:(UIButton*)btn
{
    NSLog(@"拒绝===%ld",btn.tag-2000);
}

#warning 申请人数组，根据点击的tag值找出是点击哪个，然后发送接口通知服务器，更新界面。

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
