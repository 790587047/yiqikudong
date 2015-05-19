//
//  GroudMemberAddView.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "GroudMemberAddView.h"

@interface GroudMemberAddView ()

@end

@implementation GroudMemberAddView
@synthesize recentArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    personInfo = [[NSMutableArray alloc]init];
    numArray = [[NSMutableArray alloc]init];
    self.title = @"增加成员";
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    
    recentMenberTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-60)];
    recentMenberTable.delegate = self;
    recentMenberTable.dataSource = self;
    recentMenberTable.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    recentMenberTable.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        view.backgroundColor = [UIColor clearColor];
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, SCREENWIDTH-20, 45);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setTitle:@"返回聊天信息" forState:UIControlStateNormal];
        [btn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:29/255.0 green:186/255.0 blue:60/255.0 alpha:1]];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(backChatView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        view;
    });
    [self.view addSubview:recentMenberTable];
    
    UIView*baseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-60, SCREENWIDTH, 60)];
    baseView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [self.view addSubview:baseView];
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.frame = CGRectMake(10, 10, 120, 40);
    [selectAll setTitle:@"全选" forState:UIControlStateNormal];
    selectAll.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    selectAll.layer.cornerRadius = 5;
    selectAll.backgroundColor = [UIColor colorWithRed:29/255.0 green:186/255.0 blue:60/255.0 alpha:1];
    [selectAll addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:selectAll];
    
    sureAction = [UIButton buttonWithType:UIButtonTypeCustom];
    sureAction.frame = CGRectMake(SCREENWIDTH-130, 10, 120, 40);
    [sureAction setTitle:@"确定" forState:UIControlStateNormal];
    sureAction.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    sureAction.layer.cornerRadius = 5;
    sureAction.backgroundColor = [UIColor colorWithRed:29/255.0 green:186/255.0 blue:60/255.0 alpha:1];
    [sureAction addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:sureAction];
}
-(void)backChatView
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"backChatView" object:nil];
    [self.navigationController popToViewController:self.viewController animated:YES];
}
-(void)sureAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectAllAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"全选"])
    {
        [personInfo removeAllObjects];
        [numArray removeAllObjects];
        for (int i=0; i<20; i++)
        {
//            [personInfo addObject:noteArray[i]];
            [numArray addObject:[NSNumber numberWithInt:i]];
        }
        [recentMenberTable reloadData];
        
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }else if ([btn.titleLabel.text isEqualToString:@"取消"])
    {
        [personInfo removeAllObjects];
        [numArray removeAllObjects];
        [recentMenberTable reloadData];
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        btn.backgroundColor =  [UIColor colorWithRed:29/255.0 green:186/255.0 blue:60/255.0 alpha:1];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifier = @"recentMemberCell";
    GroudRecentCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[GroudRecentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.userName.text =
    cell.userImage.image = [UIImage imageNamed:@"groudAdd.jpg"];
    cell.selectedImage.image = [UIImage imageNamed:@"groud_add_round"];
    cell.userName.text = @"ceshi";
    cell.userSelected = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSNumber*number in numArray)
        {
            if (number.integerValue == indexPath.row)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.userSelected = YES;
                    cell.selectedImage.image = [UIImage imageNamed:@"groud_add_selected"];
                });
            }
        }
    });
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroudRecentCell*cell = (GroudRecentCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.userSelected ==YES)
    {
        cell.selectedImage.image = [UIImage imageNamed:@"groud_add_round"];
        //        UIImageView*view = (UIImageView*)[cell.contentView viewWithTag:13000+indexPath.row];
        //        view.image = [UIImage imageNamed:@"quan"];
        int a = 0,b = 0,c = 0;
        for (NSNumber*str in numArray)
        {
            a++;
            if ([str isEqualToNumber:[NSNumber numberWithInteger:indexPath.row]])
            {
                b = a;
                c = 1;
            }
        }
        if (c==1)
        {
            [numArray removeObjectAtIndex:b-1];
        }
        cell.userSelected = NO;
    }else
    {
        cell.selectedImage.image = [UIImage imageNamed:@"groud_add_selected"];
        cell.userSelected = YES;
        [numArray addObject:[NSNumber numberWithInteger:indexPath.row]];
        
    }
    if (numArray.count == recentArray.count)
    {
        [selectAll setTitle:@"取消" forState:UIControlStateNormal];
        selectAll.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }else
    {
        [selectAll setTitle:@"全选" forState:UIControlStateNormal];
        selectAll.backgroundColor =  [UIColor colorWithRed:29/255.0 green:186/255.0 blue:60/255.0 alpha:1];
    }
    
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
