//
//  DownOrUploadView.m
//  YiQiWeb
//
//  Created by BK on 14/12/26.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "DownOrUploadView.h"

@interface DownOrUploadView ()

@end

@implementation DownOrUploadView
@synthesize tableList,array4;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"无下载" forKey:@"downloadState"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    // Do any additional setup after loading the view.

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    self.view.layer.backgroundColor = colorref;
    if (tableList == nil)
    {
        tableList = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREENWIDTH-14, SCREENHEIGHT) style:UITableViewStylePlain];
        tableList.delegate = self;
        tableList.dataSource = self;
        tableList.layer.backgroundColor = colorref;
        tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableList];
    }
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    array1 = [[NSMutableArray alloc]init];
    array2 = [[NSMutableArray alloc]init];
    array3 = [[NSMutableArray alloc]init];
    array4 = [[NSMutableArray alloc]initWithObjects:@"http://119.188.2.50/data2/video04/2013/04/27/00ab3b24-74de-432b-b703-a46820c9cd6f.mp4",@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4", nil];
//    array4 = [[NSMutableArray alloc]init];
//    http://119.188.2.50/data2/video04/2013/04/27/00ab3b24-74de-432b-b703-a46820c9cd6f.mp4
//    http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4
    if (array4.count>0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //        [self getVideoDownloadingList:array4];
            
            [self downloadVideo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ReminderView*reminder = [ReminderView reminderViewWithTitle:@"正在读取中"];
                [reminder removeFromSuperview];
                //            [tableList reloadData];
            });
        });
    }else
    {
        
    }
    
    
    UIButton*btnBack = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"返回" target:self action:@selector(backAction)];
    [btnBack setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    ReminderView*reminder = [ReminderView reminderViewWithTitle:@"正在读取中"];
    [self.view addSubview:reminder];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"downloadingState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopDownload) name:@"downloadingState" object:nil];
}
-(void)stopDownload
{
//    if (![downloadRequest isPaused])
//    {
//        [downloadRequest pause];
//    }
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 获取正在下载视频列表
-(UIImage*)getVideoDownloadingList:(NSString*)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset*urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(90, 90);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage*image = [[UIImage alloc]initWithCGImage:img];
    //            NSLog(@"%@",UIImagePNGRepresentation(image));
    if (error != nil)
    {
        NSLog(@"=%@",error);
    }
    //            NSLog(@"%@",str);
    return image;
        //        [array4 addObject:url];
    //    http://119.188.2.50/data2/video04/2013/04/27/00ab3b24-74de-432b-b703-a46820c9cd6f.mp4
}
-(void)downloadVideo
{
    NSMutableArray*downloadArray = [[NSMutableArray alloc]init];
    [array1 removeAllObjects];
    if (array4.count>0)
    {
        for (int i = 0; i<array4.count; i++)
        {
            NSString*urlStr = array4[i];
            VideoInfo*info = [[VideoInfo alloc]init];
            info.image = [self getVideoDownloadingList:array4[i]];
            NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:cachePath])
            {
                [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            AFHTTPRequestOperationManager*manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:urlStr]];
            NSError*error = nil;
            NSURLRequest*request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlStr parameters:nil error:&error];
            if (error)
            {
                NSLog(@"%@",error);
            }
            unsigned long long downloadedBytes = 0;
            //获取已下载的文件长度
            NSString*title = [[urlStr componentsSeparatedByString:@"/"]lastObject];
            downloadedBytes = [self fileSizeForPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]]];
//            NSLog(@"%lld",downloadedBytes);
            if (downloadedBytes>0)
            {
                NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
                NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                request = mutableURLRequest;
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"download"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            AFHTTPRequestOperation*downloadRequest = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            //        }
            //设置下载保存路径
            downloadRequest.outputStream = [NSOutputStream outputStreamToFileAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]] append:YES];
            
            //设置下载块，三个参数分别表示每次读取多少字节，已下载字节，总大小
            //        __block DownOrUploadView*video = self;
            __block BOOL isplay = isplaying;
            __block UITableView*tableview = tableList;
            __block VideoInfo*infoBlock = info;
            [downloadRequest setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                //                            NSLog(@"%lld========%lld+%lld=%lld",totalBytesRead,totalBytesExpectedToRead,downloadedBytes,totalBytesExpectedToRead+downloadedBytes);
                
                NSIndexPath*indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                DownloadCell*cell = (DownloadCell*)[tableview cellForRowAtIndexPath: indexPath];
                unsigned long long a = totalBytesRead+downloadedBytes;
                unsigned long long b ;
                b = totalBytesExpectedToRead+downloadedBytes;
                float progress = (double)a/(double)b;
                infoBlock.progress = progress;
                infoBlock.sumMemory = b;
                infoBlock.downloadMemory = a;
                cell.info = infoBlock;
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.info = infoBlock;
                    [cell data:infoBlock];
                });
                if (!isplay&&totalBytesRead>1000000)
                {
                    isplay = !isplay;
                }
                if (!isplay&&downloadedBytes>100000)
                {
                    isplay = !isplay;
                    
                }
            }];
            [[NSUserDefaults standardUserDefaults] setObject:@"下载中" forKey:@"downloadState"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            AFHTTPRequestOperation*operationRequest = downloadRequest;
            [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                for (AFHTTPRequestOperation*operation in array3)
                {
                    if ([operation isEqual:operationRequest])
                    {
                        NSUInteger a = [array3 indexOfObject:operation];
                        info.url = [array4 objectAtIndex:a];
                        [[DealData dealDataClass]saveVideo:info];
                        [array4 removeObjectAtIndex:a];
                        [array3 removeObjectAtIndex:a];
                        [array1 removeObjectAtIndex:a];
                        [tableview reloadData];
                        return;
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"下载完毕" forKey:@"download"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"downloadState"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [downloadRequest start];
            [downloadArray addObject:downloadRequest];
            [array1 addObject:info];
            
        }
        array3 = downloadArray;
        [AFHTTPRequestOperation batchOfRequestOperations:downloadArray progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            
        } completionBlock:^(NSArray *operations) {
            
        }];
    }
}

//获取已下载的文件大小
- (unsigned long long)fileSizeForPath:(NSString *)path
{
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

-(void)play:(NSString*)cachePath
{
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:cachePath]];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //    playerViewController.moviePlayer.initialPlaybackTime = 20;
    playerViewController.moviePlayer.initialPlaybackTime = [[DealData dealDataClass]selectVideo:[NSString stringWithFormat:@"%@",playerViewController.moviePlayer.contentURL]];
    [[DealData dealDataClass]videoNotification:self withPlayer:playerViewController];
    
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark  = @"cellMark";
    DownloadCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[DownloadCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-14, 70)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (array1.count) {
        VideoInfo*info = array1[indexPath.row];
        if (info)
        {
//            NSLog(@"%f",info.progress);
            [cell data:info];
        }
    }
//    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 50, 70);
//    btn.backgroundColor = [UIColor blackColor];  
//    [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    cell.editingAccessoryType = UITableViewCellAccessoryNone;
//    cell.editingAccessoryView = btn;
    cell.downloadingBtn.tag = 2000+indexPath.section*100+indexPath.row;
    [cell.downloadingBtn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
    //        [cell.downloadingBtn setTitle:@"nima" forState:UIControlStateNormal];
//    NSLog(@"cishu");
    cell.deleteBtn.tag = 1000+indexPath.section*100+indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//暂停继续按钮
-(void)stateAction:(UIButton*)btn
{
//    NSLog(@"===-大多数,%d",btn.tag/100%10);
    VideoInfo*info = array1[btn.tag/100%10];
    AFHTTPRequestOperation*downloadRequest = array3[btn.tag/100%10];
    if (!info.state)
    {
        [downloadRequest pause];
        info.state = !info.state;
        [btn setTitle:@"继续下载" forState:UIControlStateNormal];
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"continue"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
        NSIndexPath*indexPath = [NSIndexPath indexPathForRow:0 inSection:btn.tag/100%10];
        DownloadCell*cell = (DownloadCell*)[tableList cellForRowAtIndexPath: indexPath];
        [cell data:info];
//        [tableList reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:@"无下载" forKey:@"downloadState"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else
    {

        for (AFHTTPRequestOperation*operation in array3)
        {
            if (!operation.isPaused)
            {
                [operation pause];
            }
        }
        [self downloadVideo];
        info.state = !info.state;
        [btn setTitle:@"下载中" forState:UIControlStateNormal];
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"pause"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"下载中" forKey:@"downloadState"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.1 * NSEC_PER_SEC) ), dispatch_get_main_queue(), ^{
            for (int i = 0; i<array3.count; i++)
            {
                NSIndexPath*indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                DownloadCell*cell = (DownloadCell*)[tableList cellForRowAtIndexPath:indexPath];
                UIButton*button = cell.downloadingBtn;
                NSLog(@"%@",button.titleLabel.text);
                if ([button.titleLabel.text isEqualToString:@"继续下载"])
                {
                    AFHTTPRequestOperation*downloadRequest1 = array3[button.tag/100%10];
                    [downloadRequest1 pause];
                }
            }
        });
    }
//    [tableList reloadData];
    NSIndexPath*indexPath = [NSIndexPath indexPathForRow:btn.tag%100 inSection:(int)(btn.tag%1000/100)];
    DownloadCell*cell = (DownloadCell*)[tableList cellForRowAtIndexPath:indexPath];
    [cell data:info];
}

//正在下载界面删除下载
-(void)deleteVideo:(UIButton*)btn
{
    VideoInfo*info = array1[btn.tag%100];
    info = nil;
    [tableList reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array4.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 3000+indexPath.section;
        [alert show];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"删除");
        AFHTTPRequestOperation*operation = array3 [alertView.tag-3000];
        [operation pause];
        [array4 removeObjectAtIndex:alertView.tag-3000];
        [array3 removeObjectAtIndex:alertView.tag-3000];
        [array1 removeObjectAtIndex:alertView.tag-3000];
        [tableList reloadData];

    }

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-10, 10)];
    view.alpha = 0;
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-10, 10)];
    view.alpha = 0;
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    flag = 0;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (AFHTTPRequestOperation*downloadRequest in array3)
    {
        [downloadRequest pause];
    }
    for (int i = 0; i<array3.count; i++)
    {
        NSIndexPath*indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        DownloadCell*cell = (DownloadCell*)[tableList cellForRowAtIndexPath:indexPath];
        [cell.downloadingBtn setTitle:@"继续下载" forState:UIControlStateNormal];
        [cell.downloadingBtn setImage:[UIImage redraw:[UIImage imageNamed:@"continue"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
        
    }
//    if (![downloadRequest isPaused])
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"下载中" forKey:@"downloadState"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
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
