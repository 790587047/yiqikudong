//
//  VoiceHistoryView.m
//  Yiqikudong
//
//  Created by BK on 15/4/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VoiceHistoryView.h"
#import "VoiceObject.h"
#import "VoiceHistoryModel.h"
#import "ListViewCell.h"
#import "PlayVoiceViewController.h"
@interface VoiceHistoryView ()

@end

@implementation VoiceHistoryView

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
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(SCREENWIDTH-80, 30, 80, 30)];
    [btnRight setTitle:@"一键清空" forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
    [btnRight setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnRight];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [lblTitle setText:@"播放历史"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
    historyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    historyTable.delegate = self;
    historyTable.dataSource = self;
    historyTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:historyTable];
    historyTable.tableFooterView = [UIView new];
    historyArray = [VoiceHistoryModel getVoiceHistory];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"historyCell";
    ListViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[ListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    VoiceHistoryModel *info = historyArray[indexPath.section];
    VoiceObject*info1 = [[VoiceObject alloc]init];
    info1.voiceId = info.voiceId;
    info1.voiceClassId = info.voiceClassId;
    info1.voiceType = info.voiceType;
    info1.voiceName = info.voiceName;
    info1.voiceUrl = info.voiceUrl;
    info1.voicePic = info.voicePic;
    info1.voiceAuthor = info.voiceAuthor;
    info1.createTime = info.createTime;
    info1.playSumCount = info.playSumCount;
    info1.voiceSumTime = info.voiceSumTime;
    info1.total = info.total;
    info1.picPath = info.picPath;
    [cell initData:info1];
    [cell.collectBtn setHidden:YES];
    [cell.downloadBtn setHidden:YES];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return historyArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VoiceHistoryModel*info = historyArray[indexPath.section];
        [VoiceHistoryModel deleteVoiceHistory:info.voiceUrl];
        historyArray = [VoiceHistoryModel getVoiceHistory];
        [historyTable reloadData];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayVoiceViewController *playVoice = [[PlayVoiceViewController alloc]init];
    VoiceHistoryModel*info = historyArray[indexPath.section];
    VoiceObject*info1 = [[VoiceObject alloc]init];
    info1.voiceId = info.voiceId;
    info1.voiceClassId = info.voiceClassId;
    info1.voiceType = info.voiceType;
    info1.voiceName = info.voiceName;
    info1.voiceUrl = info.voiceUrl;
    info1.voicePic = info.voicePic;
    info1.voiceAuthor = info.voiceAuthor;
    info1.createTime = info.createTime;
    info1.playSumCount = info.playSumCount;
    info1.voiceSumTime = info.voiceSumTime;
    info1.total = info.total;
    info1.picPath = info.picPath;
    playVoice.model = info1;
    NSLog(@"%@",historyArray);
    [self presentViewController:playVoice animated:YES completion:^{
        
    }];
}
-(void)clearHistory
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清除全部播放历史吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (VoiceHistoryModel*info in historyArray)
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [VoiceHistoryModel deleteVoiceHistory:info.voiceUrl];
//                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [historyArray removeAllObjects];
                [historyTable reloadData];
            });
        });
        
        
        
    }
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
