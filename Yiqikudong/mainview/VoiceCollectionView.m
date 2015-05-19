//
//  VoiceCollectionView.m
//  Yiqikudong
//
//  Created by BK on 15/4/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VoiceCollectionView.h"
#import "ListViewCell.h"
#import "VoiceObject.h"
#import "VoiceCollectModel.h"
@interface VoiceCollectionView ()

@end

@implementation VoiceCollectionView

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
    [lblTitle setText:@"收藏列表"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
    collectionTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    collectionTable.delegate = self;
    collectionTable.dataSource = self;
    collectionTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:collectionTable];
    collectionTable.tableFooterView = [UIView new];
    collectionArray = [VoiceCollectModel getVoiceCollection];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"collectionCell";
    ListViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[ListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    VoiceCollectModel *info = collectionArray[indexPath.section];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return collectionArray.count;
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
        VoiceCollectModel*info = collectionArray[indexPath.section];
        [VoiceCollectModel deleteVoiceCollect:info.voiceUrl];
        collectionArray = [VoiceCollectModel getVoiceCollection];
        [collectionTable reloadData];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayVoiceViewController *playVoice = [[PlayVoiceViewController alloc]init];
    VoiceCollectModel*info = collectionArray[indexPath.section];
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
    NSLog(@"%@",info.voiceName);
    [self presentViewController:playVoice animated:YES completion:^{
        
    }];
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
