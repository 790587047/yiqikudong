//
//  MineView.m
//  亿启FM
//
//  Created by BK on 15/3/3.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "MineView.h"
#import "Common.h"
#import "AFNetworking.h"
#import "VoiceObject.h"
#import "MyVoiceCell.h"
#import "DownloadingVoiceCell.h"
#import "PlayVoiceViewController.h"

@interface MineView ()

@end

@implementation MineView{
    NSMutableArray *mutableOperations;//上传
    NSMutableArray *mutableDownOperations; //下载
    NSMutableArray *downloadingInfos; //存储正在下载的数据
    NSMutableArray *downloadInfos; //已下载
    NSIndexPath    *sIndexPath;
}

@synthesize voiceTable,kind;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    voiceArray = [[NSMutableArray alloc]init];
    
    
    mutableOperations     = [[NSMutableArray alloc] init];
    mutableDownOperations = [[NSMutableArray alloc] init];
    downloadingInfos      = [[NSMutableArray alloc] init];
    downloadInfos         = [[NSMutableArray alloc] init];
    
    [self createFileDictionary];
    
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    if (myBtn==nil||downloadBtn==nil)
    if (myBtn==nil&&downloadBtn==nil)
    {
        [self initItem:0];
        if ([kind isEqualToString:@"正在下载"]) {
            [self InitDownloadingVoice];
        }
        else if ([kind isEqualToString:@"我的声音"]) {
            [self InitMyVoice];
        }
        else if([kind isEqualToString:@"已下载"]){
            [self InitDownloadedInfo];
        }
    }
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nav_mine" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nav_mine) name:@"nav_mine" object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nav_mine_download" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nav_mine_download) name:@"nav_mine_download" object:nil];
    }
    return self;
}
-(void)nav_mine
{
    //    UIButton*btn = (UIButton*)[self.navigationController.view viewWithTag:1002];
    if (myBtn==nil)
    {
        [self initItem:1];
    }
    [self selectKindVoice:myBtn];
    NSLog(@"myBtn==%@",myBtn);
    //    kind = @"我的声音";
    //    [self InitMyVoice];
}
-(void)nav_mine_download
{
    //    UIButton*btn = (UIButton*)[self.navigationController.view viewWithTag:1002];
    if (downloadBtn==nil)
    {
        [self initItem:0];
    }
    [self selectKindVoice:downloadBtn];
    NSLog(@"downloadBtn==%@",downloadBtn);
    //    kind = @"我的声音";
    //    [self InitMyVoice];
}
-(void)initItem:(int)flag
{
    
    NSMutableArray*itemArray = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (SCREENWIDTH==375)
        {
            btn.frame = CGRectMake(0, 0, SCREENWIDTH/4+10, 40);
        }else if (SCREENWIDTH==320)
        {
            btn.frame = CGRectMake(0, 0, SCREENWIDTH/4+5, 40);
        }else if (SCREENWIDTH==414)
        {
            btn.frame = CGRectMake(0, 0, SCREENWIDTH/4+10, 40);
        }
        btn.tag = 1000+i;
        [btn setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1] forState:UIControlStateNormal];
        if (i==0)
        {
            [btn setTitle:@"已下载" forState:UIControlStateNormal];
            if (kind == nil) {
                kind = @"已下载";
                lastButton = btn;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([kind  isEqual: @"已下载"])
            {
                lastButton = btn;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }else if (i==1)
        {
            [btn setTitle:@"我的声音" forState:UIControlStateNormal];
            myBtn = btn;
            if ([kind  isEqual: @"我的声音"]) {
                lastButton = btn;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }else if (i==2)
        {
            downloadBtn = btn;
            [btn setTitle:@"正在下载" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(selectKindVoice:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [itemArray addObject:item];
        if (i!=2)
        {
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
            label.backgroundColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
            UIBarButtonItem*itemlabel = [[UIBarButtonItem alloc]initWithCustomView:label];
            [itemArray addObject:itemlabel];
        }
    }
    self.navigationItem.leftBarButtonItems = itemArray;
//    voiceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-flag*TbarHeight) style:UITableViewStylePlain];
    voiceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, TbarHeight*flag, SCREENWIDTH, SCREENHEIGHT-flag*TbarHeight) style:UITableViewStylePlain];
    voiceTable.delegate = self;
    voiceTable.dataSource = self;
    voiceTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    voiceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    voiceTable.tableFooterView = [UIView new];
    [self.view addSubview:voiceTable];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    });
//    if ([kind isEqualToString:@"正在下载"]) {
//        [self InitDownloadingVoice];
//    }
//    else if ([kind isEqualToString:@"我的声音"]) {
//        [self InitMyVoice];
//    }
//    else if([kind isEqualToString:@"已下载"]){
//        [self InitDownloadedInfo];
//    }
}

//获取已下载列表
-(void) InitDownloadedInfo{
    [downloadInfos removeAllObjects];
    downloadInfos = [VoiceObject getDownLoadedInfo];
    [voiceTable reloadData];
}

//加载我的声音
-(void) InitMyVoice{
    [mutableOperations removeAllObjects];
    [voiceArray removeAllObjects];
    voiceArray = [VoiceObject getAllVoiceUploadInfo];
    if (voiceArray.count > 0) {
        for (int i = 0; i < voiceArray.count; i++) {
            VoiceObject *model = [voiceArray objectAtIndex:i];
            if (model.uploadingFlag) {
                [self uploadVoiceAction:model];
            }
        }
    }
    [voiceTable reloadData];
}

//获取正在下载列表
-(void) InitDownloadingVoice{
    [mutableDownOperations removeAllObjects];
    [downloadingInfos removeAllObjects];
    downloadingInfos = [VoiceObject getDownloadingInfo];
    if (downloadingInfos.count > 0) {
        for (int i = 0; i < downloadingInfos.count; i++) {
            VoiceObject *obj = [downloadingInfos objectAtIndex:i];
            [self downLoadVoiceAction:obj];
        }
    }
    [voiceTable reloadData];
}

-(void)selectKindVoice:(UIButton*)btn
{
    [lastButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1] forState:UIControlStateNormal];
    lastButton = btn;
    [btn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    if ([btn.titleLabel.text isEqualToString:@"已下载"])
    {
        kind = @"已下载";
        [self InitDownloadedInfo];
    }else if ([btn.titleLabel.text isEqualToString:@"我的声音"])
    {
        kind = @"我的声音";
        [self InitMyVoice];
    }else if ([btn.titleLabel.text isEqualToString:@"正在下载"])
    {
        kind = @"正在下载";
        [self InitDownloadingVoice];
    }
}

#pragma mark table代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:@"已下载"]){
        static NSString*mark = @"downlistCell";
        DownloadingVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell==nil){
            cell = [[DownloadingVoiceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        VoiceObject *model = [downloadInfos objectAtIndex:indexPath.section];
        [cell downLoadingInfo:model];
        
        [cell.btnPlay addTarget:self action:@selector(goToPlayVoiceView:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPlay.tag = 20000 + indexPath.section;
        
        return cell;
    }
    else if ([kind isEqualToString:@"我的声音"]) {
        VoiceObject *model = [voiceArray objectAtIndex:indexPath.section];
        static NSString *mark = @"listCell";
        MyVoiceCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell==nil)
        {
            cell = [[MyVoiceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
        }
        
        [cell uploadInfo:model];
        
        [cell.downloadBtn addTarget:self action:@selector(gotoDownload:) forControlEvents:UIControlEventTouchUpInside];
        cell.downloadBtn.tag = 10000 + indexPath.section;
        
        [cell.btnPlay addTarget:self action:@selector(goToPlayVoiceView:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPlay.tag = 20000 + indexPath.section;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if ([kind isEqualToString:@"正在下载"]){
        static NSString *mark = @"downloadListCell";
        DownloadingVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell==nil)
        {
            cell = [[DownloadingVoiceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        VoiceObject *model = [downloadingInfos objectAtIndex:indexPath.section];
        [cell downLoadingInfo:model];
        
        return cell; 
    }
    else
        return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([kind isEqualToString:@"已下载"]) {
        return downloadInfos.count;
    }
    else if ([kind isEqualToString:@"我的声音"]) {
        return voiceArray.count;
    }
    else if([kind isEqualToString:@"正在下载"]){
        return downloadingInfos.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:@"我的声音"]) {
        VoiceObject *item = [voiceArray objectAtIndex:indexPath.section];
        if (item.uploadingFlag) {
            return 130;
        }
    }
    else if([kind isEqualToString:@"正在下载"]){
        return 150;
    }
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        sIndexPath = indexPath;
        [alert show];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goToPlayView:indexPath.section];
}

-(void) goToPlayView:(NSInteger) index{
    VoiceObject *obj;
    if ([kind isEqualToString:@"我的声音"]) {
        obj = [voiceArray objectAtIndex:index];
    }
    else if ([kind isEqualToString:@"已下载"]){
        obj = [downloadInfos objectAtIndex:index];
    }
    PlayVoiceViewController *viewController = [[PlayVoiceViewController alloc] init];
    viewController.model = obj;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSUInteger section = [sIndexPath section];
        if ([kind isEqualToString:@"已下载"]) {
            VoiceObject *obj = [downloadInfos objectAtIndex:section];
            obj.downloadFlag = 0;
            obj.downloadingFlag = 0;
            if ([VoiceObject updateDownloadState:obj]) {
                [Common deleteFile:[NSString stringWithFormat:@"%@/%@",WEBPATH,obj.voiceUrl.lastPathComponent]];
                [downloadInfos removeObjectAtIndex:section];
                [voiceTable deleteSections:[NSIndexSet indexSetWithIndex:sIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([kind isEqualToString:@"我的声音"]) {
            VoiceObject *obj = [voiceArray objectAtIndex:section];
            if ([VoiceObject deleteVoiceInfo:obj.voiceId]) {
                if (obj.uploadingFlag) {
                    AFHTTPRequestOperation *operation = [mutableOperations objectAtIndex:section];
                    [operation pause];
                    [mutableOperations removeObject:operation];
                    [Common deleteFile:obj.voiceUrl];
                }
                [voiceArray removeObjectAtIndex:section];
                [voiceTable deleteSections:[NSIndexSet indexSetWithIndex:sIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([kind isEqualToString:@"正在下载"]){
            VoiceObject *obj = [downloadingInfos objectAtIndex:section];
            obj.downloadFlag = 0;
            obj.downloadingFlag = 0;
            if ([VoiceObject updateDownloadState:obj]) {
                if (obj.uploadingFlag) {
                    [Common deleteFile:[NSString stringWithFormat:@"%@/%@",CACHEPATH,obj.voiceUrl.lastPathComponent]];
                    AFHTTPRequestOperation *operation = [mutableDownOperations objectAtIndex:section];
                    [operation pause];
                    [mutableDownOperations removeObject:operation];
                }
                [downloadingInfos removeObjectAtIndex:section];
                [voiceTable deleteSections:[NSIndexSet indexSetWithIndex:sIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

//跳到播放页面
-(void) goToPlayVoiceView:(UIButton *) sender{
    NSInteger index = sender.tag - 20000;
    [self goToPlayView:index];
}

#pragma mark --
#pragma mark -- 上传
//上传操作
-(void) uploadVoiceAction:(VoiceObject *) obj{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSData *imageData = obj.voicePic;
    
    NSDictionary *params = @{@"tid":[NSString stringWithFormat:@"%ld",(long)obj.voiceClassId],@"title":obj.voiceName,@"uid":@"1"};
    
    NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
    
    NSString *name = obj.voiceUrl.lastPathComponent;
    
    NSString *path = [NSString stringWithFormat:@"Documents/voicePath/%@",name];
    NSURL *url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:path]];
//    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:obj.voiceUrl]];

//    NSURL* url = [[NSBundle mainBundle] URLForResource:@"小苹果" withExtension:@"mp3"];
    
    NSData *videoData = [NSData dataWithContentsOfURL:url];
    NSString *picName = [NSString stringWithFormat:@"%@.jpg",[[name componentsSeparatedByString:@"."] firstObject]];
    
    AFHTTPRequestOperation *operation = [manager POST:postPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"pic" fileName:picName mimeType:@"image/jpeg"];
        }
        if (obj.voiceType == 0) {//audio/mpeg
            [formData appendPartWithFileData:videoData name:@"dat" fileName:name mimeType:@"audio/mp3"];
        }
        else{
            [formData appendPartWithFileData:videoData name:@"dat" fileName:name mimeType:@"video/mpeg4"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"back = %@",operation.responseString);
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        long result = [[dict objectForKey:@"suc"] integerValue];
        if (result == 1) {
            [Common deleteFile:obj.voiceUrl];
            obj.voiceClassId = [[dict objectForKey:@"tid"] integerValue];
            obj.voiceName = [dict objectForKey:@"title"];
            obj.voiceUrl = [dict objectForKey:@"videoPath"];
            obj.picPath = [dict objectForKey:@"picpath"];
            obj.uploadingFlag = 0;
            [VoiceObject updateUploadedInfo:obj];
            
//            NSLog(@"===========%ld",[mutableOperations indexOfObject:operation]);
            [mutableOperations removeObject:operation];
    
            dispatch_async(dispatch_get_main_queue(), ^{
                [voiceArray removeAllObjects];
                voiceArray = [VoiceObject getAllVoiceUploadInfo];
                [voiceTable reloadData];
            });
        }
        else{
            [Common showMessage:@"上传失败，请稍候再试" withView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation error = %@",operation.responseString);
        NSLog(@"error = %@",error);
        [Common showMessage:@"操作失败，请稍候再试" withView:self.view];
    }];
    
    [mutableOperations addObject:operation];
    
    __block NSInteger index = [mutableOperations indexOfObject:operation];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float uploadSize = totalBytesWritten / 1024.0 / 1024.0;
        float totalSize = totalBytesExpectedToWrite / 1024.0 / 1024.0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        MyVoiceCell *cell = (MyVoiceCell *)[voiceTable cellForRowAtIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.lblSpeed.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",uploadSize,totalSize];
            [cell.progressView setProgress:uploadSize / totalSize];
        });
    }];
    
    [AFHTTPRequestOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } completionBlock:^(NSArray *operations) {
    }];
}


#pragma mark -- 
#pragma mark -- 下载
//下载
-(void) gotoDownload:(UIButton *) sender{
    NSInteger index = sender.tag - 10000;
    VoiceObject *obj = [voiceArray objectAtIndex:index];
    obj.downloadTime = [Common getCurrentDate:@"yyyy-MM-dd HH:mm:ss"];
    obj.downloadingFlag = 1;
    if ([VoiceObject updateDownloadingState:obj]) {
        [sender setImage:[UIImage imageNamed:@"voiceDownloaded"] forState:UIControlStateNormal];
        sender.enabled = NO;
        [self downLoadVoiceAction:obj];
        [Common showMessage:@"已加入下载列表" withView:self.view];
    }
    else
        [Common showMessage:@"下载失败，请稍候再试" withView:self.view];
}

//下载操作
-(void) downLoadVoiceAction:(VoiceObject *) obj{
    NSURL *url = [NSURL URLWithString:obj.voiceUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"path = %@",url);
    NSString *cachePath = [CACHEPATH stringByAppendingPathComponent:obj.voiceUrl.lastPathComponent];
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
    [mutableDownOperations addObject:operation];
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"download success");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *webPath = [WEBPATH stringByAppendingPathComponent:cachePath.lastPathComponent];
        [fileManager moveItemAtPath:cachePath toPath:webPath error:nil];
        obj.downloadFlag = 1;//下载完成
        obj.downloadingFlag = 0;
        obj.downloadTime = [Common getCurrentDate:@"yyyy-MM-dd HH:mm:ss"];
        [VoiceObject updateDownLoadedState:obj];
        dispatch_async(dispatch_get_main_queue(), ^{
            [downloadingInfos removeAllObjects];
            downloadingInfos = [VoiceObject getDownloadingInfo];
            [voiceTable reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail = %@",error);
        NSLog(@"下载失败！");
    }];
    [operation start];
    
    if ([kind isEqualToString:@"正在下载"]) {
        __block NSInteger index = [mutableDownOperations indexOfObject:operation];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float eachBytes = totalBytesRead / 1024.0 / 1024.0;
            float totalSize = totalBytesExpectedToRead / 1024.0 / 1024.0;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            DownloadingVoiceCell *cell = (DownloadingVoiceCell *)[voiceTable cellForRowAtIndexPath:indexPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.lblprogress.text = [NSString stringWithFormat:@"%.02fMB/%.02fMB",eachBytes,totalSize];
                [cell.progressView setProgress:eachBytes/totalSize];
            });
        }];
    }
    
    [AFHTTPRequestOperation batchOfRequestOperations:mutableDownOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } completionBlock:^(NSArray *operations) {
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
