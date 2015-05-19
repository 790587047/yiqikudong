//
//  FollowListViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "FollowListViewController.h"
#import "FollowCell.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "Common.h"
#import "MJRefresh.h"

@interface FollowListViewController ()

@end

@implementation FollowListViewController{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]];
    
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
    //关注
    if (_type.length > 0) {
        [lblTitle setText:@"关注"];
    }
    else{
        [lblTitle setText:@"粉丝"];
    }
    
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.f]];
    [lblTitle setTextColor:WHITECOLOR];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(btnLeft.frame))];
    [topView addSubview:lblTitle];
    
//    NSInteger height = 0;
//    if (SCREENWIDTH == 320) {
//        height = 45;
//    }
//    else{
//        height = 55;
//    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(getHeadData)];
    [_tableView addFooterWithTarget:self action:@selector(getFootData)];
    [_tableView headerBeginRefreshing];
    
    [self loadData];
}

-(void) loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%@",_userId]};
    
    NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"message = %@",operation.responseString);
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
            if ([result isEqual: @"1"]) {
                
                NSArray *arrs = [dictionary objectForKey:@"info"];
                for (NSDictionary *eachDict in arrs) {
                    UserModel *obj = [[UserModel alloc] init];
                    obj.userId = [eachDict objectForKey:@"id"];
                    obj.userName = [eachDict objectForKey:@"userName"];
                    obj.userImagePic = [eachDict objectForKey:@"userImage"];
                    obj.voiceCount = [[eachDict objectForKey:@"voiceCount"] integerValue];
                    obj.followCount = [[eachDict objectForKey:@"followCount"] integerValue];
                    [_infoArray addObject:obj];
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
}

-(void) getHeadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page = 1;
        [_infoArray removeAllObjects];
        [self loadData];
        [_tableView headerEndRefreshing];
    });
}

-(void) getFootData{
    page ++;
    [self loadData];
    [_tableView footerEndRefreshing];
}

#pragma mark -- tableview datasource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _infoArray.count;
//    return 10;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELL = @"FollowCell";
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    
    if (!cell) {
        cell = [[FollowCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL];
    }
    UserModel *user = [_infoArray objectAtIndex:indexPath.section];
    [cell initData:user];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(void)goback{
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
