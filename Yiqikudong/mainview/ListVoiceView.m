//
//  ListVoiceView.m
//  Yiqikudong
//
//  Created by BK on 15/3/19.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ListVoiceView.h"
#import "AFNetworking.h"
#import "Common.h"
#import "MJRefresh.h"
#import "PlayVoiceViewController.h"
#import "VoiceCollectModel.h"

@interface ListVoiceView ()

@end

@implementation ListVoiceView{
    int page;
    NSMutableArray *mutableDownOperations;
    NSMutableArray *downloadingInfos; //存储正在下载的数据
    NSMutableArray *downloadInfos; //已下载
}

@synthesize kind;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
//    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = kind;
    
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"最火",@"最近更新"]];
    _segment.frame = CGRectMake(0, 72, SCREENWIDTH-20, 40);
    _segment.center = CGPointMake(self.view.center.x, _segment.center.y);
    _segment.tintColor = [UIColor orangeColor];
    _segment.selectedSegmentIndex = 0;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName,  [UIFont fontWithName:@"SnellRoundhand-Bold"size:17],NSFontAttributeName ,shadow,NSShadowAttributeName ,nil];
    [_segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    [_segment addTarget:self action:@selector(getSelectedData) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    
    if (SCREENWIDTH==320)
    {
        listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH, SCREENHEIGHT - 120 - 45) style:UITableViewStylePlain];
    }else
    {
        listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH, SCREENHEIGHT - 120 - 55) style:UITableViewStylePlain];
    }
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:listTable];
    page = 1;
    [listTable addHeaderWithTarget:self action:@selector(getHeadData)];
    [listTable addFooterWithTarget:self action:@selector(getFootData)];
    listTable.tableFooterView = [UIView new];
    [listTable headerBeginRefreshing];
    
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    btnSearch.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnSearch;
    
    voiceInfoArray        = [[NSMutableArray alloc]init];
    mutableDownOperations = [[NSMutableArray alloc] init];
    downloadingInfos      = [[NSMutableArray alloc] init];
    downloadInfos         = [[NSMutableArray alloc] init];
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

-(void) getHeadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page = 1;
        [voiceInfoArray removeAllObjects];
        [self getData];
        [listTable headerEndRefreshing];
    }); 
}

-(void) getFootData{
    
    page ++;
    [self getData];
    [listTable footerEndRefreshing];
}

//加载数据
-(void)getData
{
    NSDictionary*dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",nil] forKeys:[NSArray arrayWithObjects:@"音乐",@"电影",@"相声",@"新闻资讯",@"百家讲坛",@"戏曲",@"儿童",@"IT科技",@"校园",@"健康养生",@"外语",@"财经",@"体育",@"其他", nil]];
    
    NSString *path = [NSString stringWithFormat:@"%@yiqiVideoInterface.asp",VOICEHEADPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([dict objectForKey:kind] == nil) {
        [params setValue:@"recomm" forKey:@"sign"];
    }
    else{
        [params setValue:@"type" forKey:@"sign"];
        [params setValue:[NSString stringWithFormat:@"%@",[dict objectForKey:kind]] forKey:@"tid"];
        [params setValue:[NSString stringWithFormat:@"%ld",(long)_segment.selectedSegmentIndex] forKey:@"typ"];
    }
    [params setValue:[NSNumber numberWithInt:page] forKey:@"pnum"];
    [params setValue:@10 forKey:@"pagcnt"];
//    NSLog(@"%@",params);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    ReminderView *indicator = [ReminderView reminderView];
//    [self.view addSubview:indicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"message = %@",operation.responseString);
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
            if ([result isEqual: @"1"]) {
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
                    obj.createTime   = [Common dealDateTime:[eachDict objectForKey:@"createTime"]];
//                    obj.voiceSumTime = [Common getVoiceTimeLength:[NSURL URLWithString:obj.voiceUrl]];
                    [voiceInfoArray addObject:obj];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [indicator removeFromSuperview];
                    [listTable reloadData];
                });
            }
//            else{
//                [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
//            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail = %@",error);
            NSLog(@"failure = %@",operation);
            [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
        }];
    });
}

//UISegmentedControl切换事件
-(void) getSelectedData{
    [listTable headerBeginRefreshing];
}

#pragma mark table代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mark = @"listCell";
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell == nil)
    {
        cell = [[ListViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
    }
    VoiceObject *info = voiceInfoArray[indexPath.section];
    [cell initData:info];
    
    [cell.downloadBtn addTarget:self action:@selector(gotoDownload:) forControlEvents:UIControlEventTouchUpInside];
    cell.downloadBtn.tag = 10000 + indexPath.section;
    
    [cell.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.collectBtn.tag = 20000 + indexPath.section;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return voiceInfoArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VoiceObject *obj = [voiceInfoArray objectAtIndex:indexPath.section];
    [VoiceObject sendAddPlayNumber:obj.voiceId];
    PlayVoiceViewController *viewController = [[PlayVoiceViewController alloc] init];
    viewController.model = obj;
    [self presentViewController:viewController animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

#pragma mark --
#pragma mark -- 下载
//下载
-(void) gotoDownload:(UIButton *) sender{
    NSInteger index = sender.tag - 10000;
    VoiceObject *obj = [voiceInfoArray objectAtIndex:index];
    if (![VoiceObject isExistsDownLoadUrl:obj.voiceUrl]) {
        obj.createTime = @"";
        obj.downloadingFlag = 1;
        obj.downloadFlag = 0;
        obj.downloadTime = [Common getCurrentDate:@"yyyy-MM-dd HH:mm:ss"];
        obj.userId = @"1";
        if ([VoiceObject addVoiceModel:obj]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nav_mine_download" object:nil];
        }
        else
            [Common showMessage:@"下载失败，请稍候再试" withView:self.view];
    }
    else{
        [Common showMessage:@"该音频已下载" withView:self.view];
    }
}

//进入搜索页
-(void)searchAction
{
    self.navigationController.navigationBarHidden = YES;
    SearchView*searchView =[[SearchView alloc]init];
    [self.navigationController pushViewController:searchView animated:YES];
}

//返回按钮
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 收藏
/**
 *  收藏按钮操作
 *
 *  @param sender button
 */
-(void) collectAction:(UIButton *) sender{
    NSInteger index = sender.tag - 20000;
    VoiceObject *obj = [voiceInfoArray objectAtIndex:index];
    if (![VoiceCollectModel isExistsCollectUrl:obj.voiceUrl]) {
        VoiceCollectModel *model = [[VoiceCollectModel alloc] init];
        model.voiceUrl           = obj.voiceUrl;
        model.voiceType          = obj.voiceType;
        model.voiceSumTime       = obj.voiceSumTime;
        model.voicePic           = obj.voicePic;
        model.voiceName          = obj.voiceName;
        model.voiceClassId       = obj.voiceClassId;
        model.picPath            = obj.picPath;
        model.voiceAuthor        = obj.voiceAuthor;
        model.playSumCount       = obj.playSumCount;
        model.total              = obj.total;
        model.createTime         = [Common getCurrentDate:@"yyyy-MM-dd"];
        [VoiceCollectModel addVoiceCollectInfo:model];
        [Common showMessage:@"收藏成功" withView:self.view];
    }
    else
        [Common showMessage:@"已收藏" withView:self.view];
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
