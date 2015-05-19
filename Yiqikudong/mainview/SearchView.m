//
//  SearchView.m
//  Yiqikudong
//
//  Created by BK on 15/3/20.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "SearchView.h"
#import "PlayVoiceViewController.h"

@interface SearchView ()

@end

@implementation SearchView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, TbarHeight)];
    view.backgroundColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:39/255.0 alpha:1];
    [self.view addSubview:view];
    
    searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, TbarHeight-44, SCREENWIDTH, 40)];
    searchbar.showsCancelButton = YES;
    searchbar.delegate = self;
    searchbar.text = @"录音";
    searchbar.placeholder = @"搜索";
    searchbar.tintColor = [UIColor blackColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (UIView*view1 in searchbar.subviews)
        {
            for (UIView*view2 in view1.subviews)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([view2 isKindOfClass:[UITextField class]])
                    {
                        view2.backgroundColor = WHITECOLOR;
                    }
                    if ([view2 isKindOfClass:[UIButton class]]) {
                        view2.tintColor = WHITECOLOR;
                    }
                });
            }
        }
    });
//    searchBar.barTintColor = WHITECOLOR;
    searchbar.barStyle = UISearchBarIconClear;
    [view addSubview:searchbar];
    [searchbar becomeFirstResponder];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.view.backgroundColor = WHITECOLOR;
    
    voiceInfoArray = [[NSMutableArray alloc]init];
    if (SCREENWIDTH==320)
    {
        searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, TbarHeight, SCREENWIDTH, SCREENHEIGHT-TbarHeight-45) style:UITableViewStylePlain];
    }else
    {
        searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, TbarHeight, SCREENWIDTH, SCREENHEIGHT-TbarHeight-50) style:UITableViewStylePlain];
    }
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    page = 1;
    [searchTable addFooterWithTarget:self action:@selector(loadMore)];
    searchTable.tableFooterView = [UIView new];
    [self.view addSubview:searchTable];
}
-(void)loadMore
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        page++;
        for (VoiceObject*info in [VoiceObject getSearchResultWithKeyWord:searchbar.text withPage:page]) {
            [voiceInfoArray addObject:info];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (voiceInfoArray.count>0)
            {
                [searchTable reloadData];
            }else
            {
                [Common showMessage:@"为搜索到相关信息" withView:self.view];
            }
            [searchTable footerEndRefreshing];
        });
    });
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        voiceInfoArray = [VoiceObject getSearchResultWithKeyWord:searchBar.text withPage:page];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (voiceInfoArray.count>0)
            {
                [searchTable reloadData];
                page=1;
            }else
            {
                [Common showMessage:@"未搜索到相关信息" withView:self.view];
            }
        });
    });
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchbar resignFirstResponder];
}
#pragma mark table代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"listCell";
    ListViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[ListViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
    }
    VoiceObject*info = voiceInfoArray[indexPath.row];
//    NSLog(@"%@",info.voiceName);
    [cell initData:info];
    
    [cell.downloadBtn addTarget:self action:@selector(gotoDownload:) forControlEvents:UIControlEventTouchUpInside];
    cell.downloadBtn.tag = 10000 + indexPath.section;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return voiceInfoArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController popViewControllerAnimated:YES];
    VoiceObject *obj = [voiceInfoArray objectAtIndex:indexPath.section];
    PlayVoiceViewController *viewController = [PlayVoiceViewController playVoiceView];
    viewController.model = obj;
    [self presentViewController:viewController animated:YES completion:nil];
}
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
