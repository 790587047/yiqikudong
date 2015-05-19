//
//  PersonalAnchorViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "PersonalAnchorViewController.h"
#import "PersonAnchorCell.h"
#import "PlayVoiceViewController.h"
#import "AFNetworking.h"
#import "Common.h"
#import "UserModel.h"
#import "MJRefresh.h"

@interface PersonalAnchorViewController ()

@end

@implementation PersonalAnchorViewController{
    UserModel *user;
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _voiceArray = [[NSMutableArray alloc] init];
    
    //修改状态栏颜色
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    [view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:view];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self InitView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化页面
 */
-(void) InitView{
    user = [[UserModel alloc] init];
    user.userId = _userId;
    
    [self loadData];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userAnchor.jpg"]];
    [bgView setFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT/3)];
    [self.view addSubview:bgView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(20, 20, 30, 25)];
    [btnBack setImage:[UIImage imageNamed:@"playBack"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnBack];
    
    NSInteger imgWidth = CGRectGetWidth(bgView.frame)/4;
    _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, imgWidth, imgWidth)];
    [_imgHead setImage:[UIImage imageNamed:@"touxiang"]];
//    [_imgHead setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.userImagePic]]]];
    _imgHead.center = CGPointMake(self.view.center.x, CGRectGetMidY(bgView.frame)-imgWidth/2);
    [bgView addSubview:_imgHead];
    
    _lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgHead.frame), 150, 35)];
    [_lblUserName setTextColor:WHITECOLOR];
    [_lblUserName setFont:[UIFont boldSystemFontOfSize:18.f]];
    [_lblUserName setTextAlignment:NSTextAlignmentCenter];
//    [_lblUserName setText:@"相见恨晚"];
    [_lblUserName setText:user.userName];
    _lblUserName.center = CGPointMake(_imgHead.center.x,_lblUserName.center.y);
    [bgView addSubview:_lblUserName];
    
    _lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lblUserName.frame), 200, 35)];
    [_lblInfo setTextColor:WHITECOLOR];
    [_lblInfo setTextAlignment:NSTextAlignmentCenter];
    [_lblInfo setFont:[UIFont systemFontOfSize:16.f]];
//    [_lblInfo setText:@"心如向阳，何惧忧伤"];
    [_lblInfo setText:user.userDescription];
    _lblInfo.center = CGPointMake(_lblUserName.center.x, _lblUserName.center.y+CGRectGetHeight(_lblUserName.frame));
    [bgView addSubview:_lblInfo];
    
    _lblCount = [[UILabel alloc] initWithFrame:CGRectMake(btnBack.frame.origin.x, CGRectGetMaxY(bgView.frame)+10, 200, 40)];
    [_lblCount setTextColor:[UIColor blackColor]];
    [_lblCount setText:[NSString stringWithFormat:@"发布的声音（ %lu ）",(unsigned long)_voiceArray.count]];
    [_lblCount setFont:[UIFont systemFontOfSize:16.f]];
    [self.view addSubview:_lblCount];
    
    UILabel *lblDot = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 7, 7)];
    [lblDot setBackgroundColor:[UIColor orangeColor]];
    lblDot.center = CGPointMake(lblDot.center.x, _lblCount.center.y);
    [self.view addSubview:lblDot];
    
    int height = 0;
    if (SCREENWIDTH == 320) {
        height = 50;
    }
    else{
        height = 60;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lblCount.frame) , SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(_lblCount.frame) - height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView addHeaderWithTarget:self action:@selector(getHeadData)];
    [_tableView addFooterWithTarget:self action:@selector(getFootData)];
    [_tableView headerBeginRefreshing];
}

-(void) loadData{
    
    //请求用户信息和列表数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%@",user.userId]};
    
    NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"message = %@",operation.responseString);
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
            if ([result isEqual: @"1"]) {
                user.userName        = [dictionary objectForKey:@"userName"];
                user.userImagePic    = [dictionary objectForKey:@"userImaage"];
                user.userDescription = [dictionary objectForKey:@"description"];
                
                NSArray *arrs = [dictionary objectForKey:@"info"];
                for (NSDictionary *eachDict in arrs) {
                    VoiceObject *obj = [[VoiceObject alloc] init];
                    obj.voiceId      = [eachDict objectForKey:@"id"];
                    obj.voiceClassId = [[eachDict objectForKey:@"tid"] integerValue];
                    obj.voiceName    = [eachDict objectForKey:@"title"];
                    obj.voiceUrl     = [eachDict objectForKey:@"url"];
                    obj.picPath      = [eachDict objectForKey:@"picurl"];
                    obj.voiceType    = [[eachDict objectForKey:@"flg"] integerValue];
                    obj.playSumCount = [eachDict objectForKey:@"playsu"];
                    obj.voiceAuthor  = [eachDict objectForKey:@"sname"];
                    obj.createTime   = [eachDict objectForKey:@"createTime"];
                    [_voiceArray addObject:obj];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail = %@",error);
            NSLog(@"failure = %@",operation);
            [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
        }];
    });
    
    for (int i = 0; i < 10; i++) {
        VoiceObject *obj = [[VoiceObject alloc] init];
        obj.voiceAuthor = @"成龙";
        obj.voiceName = @"飞燕掌上吴帝五上风";
        obj.voiceSumTime = @"10:20";
        obj.voiceClassId = 1;
        obj.playSumCount = @"1.4万";
        [_voiceArray addObject:obj];
    }
}

-(void) getHeadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page = 1;
        [_voiceArray removeAllObjects];
        [self loadData];
        [_tableView headerEndRefreshing];
    });
}

-(void) getFootData{
    page ++;
    [self loadData];
    [_tableView footerEndRefreshing];
}

#pragma mark -- tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _voiceArray.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *personCell = @"personCell";
    
    PersonAnchorCell *cell = [tableView dequeueReusableCellWithIdentifier:personCell];
    
    if (!cell) {
        cell = [[PersonAnchorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:personCell];
    }
    VoiceObject *obj = [_voiceArray objectAtIndex:indexPath.section];
    [cell initData:obj];
    
    [cell.btnPlay addTarget:self action:@selector(goToPlayVoiceView:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPlay.tag = 20000 + indexPath.section;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goToPlayView:indexPath.section];
}

//跳到播放页面
-(void) goToPlayVoiceView:(UIButton *) sender{
    NSInteger index = sender.tag - 20000;
    [self goToPlayView:index];
}

-(void) goToPlayView:(NSInteger) index {
    VoiceObject *obj = [_voiceArray objectAtIndex:index];
    PlayVoiceViewController *viewController = [[PlayVoiceViewController alloc] init];
    viewController.model = obj;
    [self presentViewController:viewController animated:YES completion:nil];
}

/**
 *  返回按钮事件
 */
-(void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
