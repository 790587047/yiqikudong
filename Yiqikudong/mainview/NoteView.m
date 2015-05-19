//
//  NoteView.m
//  Yiqikudong
//
//  Created by BK on 15/2/15.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "NoteView.h"
#import "Common.h"

@interface NoteView ()

@end

@implementation NoteView
@synthesize noteArray,contentStr;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    personInfo = [[NSMutableArray alloc]init];
    phoneArray = [[NSMutableArray alloc]init];
    numArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-50) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:view];
    for (int i =0; i<2; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0)
        {
            btn.frame = CGRectMake(10, 8, 80, 34);
            [btn setTitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            btn.layer.borderColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1].CGColor;
            btn.layer.borderWidth = 1;
        }else if (i==1)
        {
            btn.frame = CGRectMake(SCREENWIDTH-90, 8, 80, 34);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"全选" forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor redColor]];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        btn.layer.cornerRadius = 5;
        
    }
    
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnSure = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    btnSure.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnSure;
}
-(void)btnAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"全选"])
    {
        [personInfo removeAllObjects];
        [numArray removeAllObjects];
        
        for (int i=0; i<noteArray.count; i++)
        {
            [personInfo addObject:noteArray[i]];
            [numArray addObject:[NSNumber numberWithInt:i]];
        }
        [tableview reloadData];
        UIBarButtonItem *btnSure = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
        btnSure.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = btnSure;
    }else if ([btn.titleLabel.text isEqualToString:@"取消"])
    {
        [personInfo removeAllObjects];
        [numArray removeAllObjects];
        [tableview reloadData];
        UIBarButtonItem *btnSure = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
        btnSure.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = btnSure;
    }
}
-(void)backAction:(UIBarButtonItem*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell*cell = (NoteCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.backgroundColor isEqual:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]])
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.image.image = [UIImage imageNamed:@"quan"];
//        UIImageView*view = (UIImageView*)[cell.contentView viewWithTag:13000+indexPath.row];
//        view.image = [UIImage imageNamed:@"quan"];
        int a = 0,b = 0,c = 0;
        for (NSString*str in personInfo)
        {
            a++;
            if ([str isEqualToString:noteArray[indexPath.row]])
            {
                b = a;
                c = 1;
            }
        }
        if (c==1)
        {
            [personInfo removeObjectAtIndex:b-1];
            [numArray removeObjectAtIndex:b-1];
        }
    }else
    {
        cell.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
        [personInfo addObject:noteArray[indexPath.row]];
        [numArray addObject:[NSNumber numberWithInteger:indexPath.row]];
//        cell.accessoryType=UITableViewCellAccessoryCheckmark;
//        UIImageView*view = (UIImageView*)[cell.contentView viewWithTag:13000+indexPath.row];
//        view.image = [UIImage imageNamed:@"nike"];
        cell.image.image = [UIImage imageNamed:@"nike"];
        
    }
    if (personInfo.count>0)
    {
        UIBarButtonItem *btnSure = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
        btnSure.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = btnSure;
    }else
    {
        UIBarButtonItem *btnSure = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
        btnSure.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = btnSure;
    }
}
-(void)dealData:(NSMutableArray*)array
{
    [phoneArray removeAllObjects];
    for (NSString*str in array)
    {
        NSArray*darray = [str componentsSeparatedByString:@"/"];
        [phoneArray addObject:[darray lastObject]];
    }
}
-(void)sureAction
{
    [self dealData:personInfo];
    if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized) {
        return ;
    }
    if ([MFMessageComposeViewController canSendText]) {
        messageController=[[MFMessageComposeViewController alloc]init];
        messageController.body=[NSString stringWithFormat:@"%@",contentStr];
        messageController.messageComposeDelegate=self;
//        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"多人" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
//        btnCancel.tintColor = [UIColor blueColor];
//        for (UIView*view in messageController.view.subviews)
//        {
//            if ([view isKindOfClass:[UINavigationBar class]])
//            {
//                NSLog(@"%@",view.subviews);
//                for (UIView*view1 in view.subviews)
//                {
//                    
//                }
//            }else
//            {
////                NSLog(@"%@",view.subviews);
//            }
//        }
//        messageController.navigationItem.leftBarButtonItem = btnCancel;
        if (phoneArray.count>0)
        {
            messageController.recipients = phoneArray;
        }
        [self presentViewController:messageController animated:YES completion:^{
            
        }];
    }else{
        [Common showMessage:@"短信功能无法调用" withView:self.view];
//        ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"短信功能无法调用"];
//        [self.view addSubview:remiderView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationDuration:0.5];//动画运行时间
//            remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//            [UIView commitAnimations];//提交动画
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [remiderView removeFromSuperview];
//            });
//        });
        ReminderView*view = [ReminderView reminderView];
        [view removeFromSuperview];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSString*str=nil;
    switch (result) {
        case MessageComposeResultCancelled:
            str=@"短信发送取消";
            break;
        case MessageComposeResultSent:
            str=@"短信发送成功";
            break;
        case MessageComposeResultFailed:
            str=@"短信发送失败";
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [Common showMessage:str withView:self.view];
//    ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:str];
//    [self.view addSubview:remiderView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.5];//动画运行时间
//        remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//        [UIView commitAnimations];//提交动画
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [remiderView removeFromSuperview];
//        });
//    });
    ReminderView*view = [ReminderView reminderView];
    [view removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return noteArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"mark";
    NoteCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[NoteCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
    }
    cell.backgroundColor = [UIColor whiteColor];
//    UIImageView*view = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 16, 18, 18)];
//    view.image = [UIImage imageNamed:@"quan"];
//    view.tag = 13000+indexPath.row;
//    view.hidden = NO;
//    [cell.contentView addSubview:view];
    cell.image.image = [UIImage imageNamed:@"quan"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSNumber*number in numArray)
        {
            if (number.integerValue == indexPath.row)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
                    cell.image.image = [UIImage imageNamed:@"nike"];
                });
            }
        }
    });
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = noteArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
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
