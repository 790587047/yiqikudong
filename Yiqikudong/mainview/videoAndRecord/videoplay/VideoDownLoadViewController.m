//
//  VideoDownLoadViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/2/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VideoDownLoadViewController.h"
#import "VideoModel.h"
#import "TitleCell.h"
#import "UploadCell.h"
#import "AFNetworking.h"
#import "Common.h"

//下载视频路径
#define WEBPATH   [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DownLoad/Temp"]
//正在下载视频路径
#define CACHEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DownLoad/Cache"]

@interface VideoDownLoadViewController ()

@end

@implementation VideoDownLoadViewController{
    NSMutableArray *boolArray;
    NSIndexPath *sIndexPath;
    NSMutableArray *downLoadInfos;
    NSMutableArray *mutableOperations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    boolArray = [[NSMutableArray alloc] init];
    downLoadInfos = [[NSMutableArray alloc] init];
    mutableOperations = [[NSMutableArray alloc] init];
    
    [self createFileDictionary];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.sectionFooterHeight = 0;
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.tableFooterView = [UIView new];
    }
    [self.view addSubview:self.tableView];
    
    [self initDataView];
}

//创建文件夹
-(void) createFileDictionary{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CACHEPATH]) {
        [fileManager createDirectoryAtPath:CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:WEBPATH]) {
        [fileManager createDirectoryAtPath:WEBPATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getDownLoadData{
    [self.downDictionary removeAllObjects];
    self.downDictionary = [VideoModel getAllUploadVideoInfo:Downloading And:DownloadFinish];
    NSArray *keys = self.downDictionary.allKeys;
    for (int i = 0; i < keys.count; i++) {
        [boolArray addObject:@"0"];
    }
}

-(void)initDataView{
    [self getDownLoadData];
    if (self.downDictionary.count > 0) {
        [mutableOperations removeAllObjects];
        [downLoadInfos removeAllObjects];
        NSArray *arrs = [self.downDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)Downloading]];
        if (arrs.count>0) {
            for (int i = 0; i <= arrs.count -1; i++) {
                VideoModel *model = [arrs objectAtIndex:i];
                [self downLoadAction:model];
            }
            boolArray[0] = @"1";
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.downDictionary.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([boolArray[section] isEqual: @"1"]) {
        NSString *key = [self.downDictionary.allKeys objectAtIndex:section];
        NSArray *arrs = [self.downDictionary objectForKey:key];
        return arrs.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    
    NSString *key = [self.downDictionary.allKeys objectAtIndex:section];
    NSArray *arrs = [self.downDictionary objectForKey:key];
    if (boolArray.count > 0 && [boolArray[section] isEqual: @"1"] && arrs.count > row) {
        
        VideoModel *model;
        if (downLoadInfos.count > 0 && [key isEqualToString:[NSString stringWithFormat:@"%ld",(long)Downloading]])
            model = [downLoadInfos objectAtIndex:row];
        
        if ([key isEqualToString:[NSString stringWithFormat:@"%ld",(long)DownloadFinish]])
            model = [arrs objectAtIndex:row];
        
        static NSString *CellIdentifier = @"UploadCell";
        
        UploadCell *cell = (UploadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
            cell = [[UploadCell alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell initData:model];
        
        cell.btnUpload.tag = row + 3000;
        if (model.v_State == Downloading) {
            [cell.btnUpload addTarget:self action:@selector(pauseOrStartDownLoad:) forControlEvents:UIControlEventTouchUpInside];
            if (cell.btnUpload != nil && model.errorIndex == 1)
                [cell.btnUpload addTarget:self action:@selector(reDownLoad:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [cell.btnUpload addTarget:self action:@selector(playLocalVideo:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"TitleCell";
        TitleCell *cell = (TitleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[TitleCell alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,[VideoModel iPad] ? 60 : 44)];
        }
        if (self.downDictionary.count > 0) {
            NSString *title;
            if ([[[self.downDictionary allKeys] objectAtIndex:section] isEqualToString:[NSString stringWithFormat:@"%ld",(long)Downloading]]) {
                title = @"  正在下载视频";
            }
            else if ([[[self.downDictionary allKeys] objectAtIndex:section] isEqualToString:[NSString stringWithFormat:@"%ld",(long)DownloadFinish]]) {
                title =  @"  已下载视频";
            }
            [cell initView:title];
            if (boolArray.count == 0) {
                [cell changeArrowWithUp:NO];
            }
            else{
                if ([boolArray[section] isEqual:@"1"])
                    [cell changeArrowWithUp:YES];
                else
                    [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath] ? YES : NO)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        return 120;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.downDictionary.allKeys.count > 0) {
        if (indexPath.row == 0) {
            self.selectIndex = indexPath;
            if ([boolArray[indexPath.section] isEqual: @"0"]) {
                boolArray[indexPath.section] = @"1";
                [self didSelectCellRowFirstDo:YES];
            }
            else{
                boolArray[indexPath.section] = @"0";
                [self didSelectCellRowFirstDo:NO];
            }
        }
        else{
            NSUInteger section = indexPath.section;
            NSInteger row = indexPath.row;
            if (section == 1) {
                NSString *key = [self.downDictionary.allKeys objectAtIndex:section];
                NSArray *arrs = [self.downDictionary objectForKey:key];
                VideoModel *model = [arrs objectAtIndex:row];
                [self startToPlay:[NSURL URLWithString:model.v_Url] PlayTime:model.v_PlayTime ID:model.v_Id];
            }
        }
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert{
    
    TitleCell *cell = (TitleCell *)[self.tableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.tableView beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    NSString *key = [self.downDictionary.allKeys objectAtIndex:section];
    NSUInteger contentCount = [[self.downDictionary objectForKey:key] count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if ([boolArray[section] isEqual: @"1"]){
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else{
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];
    
    if ([boolArray[section] isEqual: @"1"])
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 1000;
        sIndexPath = indexPath;
        [alert show];
    }
}


#pragma mark --下载视频操作
-(void) downLoadAction:(VideoModel *) model{
    NSURL *url = [NSURL URLWithString:model.v_Url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"path = %@",url);
    NSString *cachePath = [CACHEPATH stringByAppendingPathComponent:model.v_Url.lastPathComponent];
    NSLog(@"cachePath = %@",cachePath);
    //判断之前是否下载过 如果有下载重新构造Header
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSError *error ;
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:cachePath error:&error] fileSize];
        NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
        [request setValue:headerRange forHTTPHeaderField:@"Range"];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:cachePath append:YES];
    [downLoadInfos addObject:model];
    [mutableOperations addObject:operation];
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"download success");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *webPath = [WEBPATH stringByAppendingPathComponent:cachePath.lastPathComponent];
        [fileManager moveItemAtPath:cachePath toPath:webPath error:nil];
        model.v_State = DownloadFinish;
        model.v_Url = webPath;
        model.v_PlayTime = 0;
        [VideoModel updateInfoWhenUploadFinish:model];
        [self getDownLoadData];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail = %@",error);
        NSLog(@"下载失败！");
        model.errorIndex = 1;
        [self downFail:model];
    }];
    [operation start];
    
    __block float eachProgress = 0;
    __block NSInteger index = [mutableOperations indexOfObject:operation];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float eachBytes = bytesRead / 1024.0 / 1024.0;
        float totalSize = totalBytesExpectedToRead / 1024.0 / 1024.0;
        model.sumMemory = totalSize;
        eachProgress += eachBytes;
        model.downloadMemory = eachProgress;
        model.progress = eachProgress / totalSize * 100;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
        UploadCell *cell = (UploadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.lblSpeed.text = [NSString stringWithFormat:@"%.02fMB/%.02fMB",model.downloadMemory,model.sumMemory];
            cell.lblProgress.text = [NSString stringWithFormat:@"%d%%",(int)model.progress];
            [cell.progressView setProgress:model.downloadMemory/model.sumMemory];
        });
    }];
    
    [AFHTTPRequestOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } completionBlock:^(NSArray *operations) {
    }];
}

//下载失败操作
-(void)downFail:(VideoModel *) model{
    [Common showMessage:@"下载失败，请稍候再试" withView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [VideoModel updateInfoWhenUploadFail:model];
        [self getDownLoadData];
        [self.tableView reloadData];
    });
}

//暂停
-(void) pauseOrStartDownLoad:(UIButton *) sender{
    NSInteger index = sender.tag - 3000;
    AFHTTPRequestOperation *downLoadRequest = mutableOperations[index];
    VideoModel *model = [downLoadInfos objectAtIndex:index];
    if (![downLoadRequest isPaused]) {
        [downLoadRequest pause];
        [sender setTitle:@"继续下载" forState:UIControlStateNormal];
        [sender setImage:[UIImage redraw:[UIImage imageNamed:@"continue"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
        UploadCell *cell = (UploadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell initData:model];
    }
    else{
        [self downLoadAction:model];
        [sender setTitle:@"下载中" forState:UIControlStateNormal];
        [sender setImage:[UIImage redraw:[UIImage imageNamed:@"pause"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
    }
}

-(void)reDownLoad:(UIButton *) sender{
    NSInteger index = sender.tag - 3000;
    AFHTTPRequestOperation *downLoadRequest = mutableOperations[index];
    [downLoadRequest cancel];
    VideoModel *model = [downLoadInfos objectAtIndex:index];
    [self downLoadAction:model];
    [sender setTitle:@"下载中" forState:UIControlStateNormal];
    [sender setImage:[UIImage redraw:[UIImage imageNamed:@"pause"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
}

-(void)playLocalVideo:(UIButton *) sender{
    NSArray *arrs = [self.downDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)DownloadFinish]];
    NSInteger index = sender.tag - 3000;
    VideoModel *model = arrs[index];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isDown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self startToPlay:[NSURL fileURLWithPath:model.v_Url] PlayTime:model.v_PlayTime ID:model.v_Id];
}

//播放视频
-(void) startToPlay : (NSURL *) path PlayTime : (float) playTime ID : (NSString *) videoId {
    self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
    [[DealData dealDataClass]videoNotification:self withPlayer:self.playerViewController];
    [self.playerViewController.moviePlayer setInitialPlaybackTime:playTime];
    [[NSUserDefaults standardUserDefaults] setValue:videoId forKey:@"videoid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view.window.rootViewController presentMoviePlayerViewControllerAnimated:self.playerViewController];
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 1000) {
            NSInteger section = sIndexPath.section;
            NSInteger row = sIndexPath.row - 1;
            NSString *key = _downDictionary.allKeys[section];
            NSMutableArray *arrItems = [self.downDictionary objectForKey:key];
            VideoModel *item = [arrItems objectAtIndex:row];
            NSString *url = item.v_Url;
            NSString *tempPath;
            if ([VideoModel deleteVideoModel:item.v_Id]) {
                item.v_Id = [NSString stringWithFormat:@"%ld",(long)item.downLoadId];
                item.downLoadId = 0;
                [VideoModel updateDownLoad:item];
                if ([key isEqualToString:[NSString stringWithFormat:@"%ld",(long)Downloading]]) {
                    [downLoadInfos removeObjectAtIndex:row];
                    AFHTTPRequestOperation *operation = [mutableOperations objectAtIndex:row];
                    [operation cancel];
                    [mutableOperations removeObject:operation];
                    tempPath = CACHEPATH;
                }
                else
                    tempPath = WEBPATH;
                [arrItems removeObjectAtIndex:row];
                [Common deleteFile:[tempPath stringByAppendingPathComponent:url.lastPathComponent]];
                [self.tableView deleteRowsAtIndexPaths:@[sIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self getDownLoadData];
                [self.tableView reloadData];
            }
        }
    }
}


@end
