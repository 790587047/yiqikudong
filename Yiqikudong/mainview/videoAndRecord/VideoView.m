//
//  VideoView.m
//  YiQiWeb
//
//  Created by BK on 14/12/23.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "VideoView.h"

@interface VideoView ()

@end

@implementation VideoView
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频下载列表";
    array1 = [[NSMutableArray alloc]init];
    array2 = [[NSMutableArray alloc]init];
    array3 = [[NSMutableArray alloc]init];
    array4 = [NSMutableArray arrayWithObjects:@"http://119.188.2.50/data2/video04/2013/04/27/00ab3b24-74de-432b-b703-a46820c9cd6f.mp4",@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4",nil];
    array5 = [[NSMutableArray alloc]init];
    array6 = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self getVideoList];

        [self getVideoDownloadingList:array4];
        dispatch_async(dispatch_get_main_queue(), ^{
            ReminderView*reminder = [ReminderView reminderViewWithTitle:@"正在读取中"];
            [reminder removeFromSuperview];
            [location reloadData];
        });
    });
    
    //collectionView的布局 决定元素如何摆放 FlowLayout是collectionView 已经写好的一种布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //每行3个 每个间隔10像素 得到元素的大小
    float width = (SCREENWIDTH - 50) / 3;
    float height = width;
    //设置元素的大小
    layout.itemSize = CGSizeMake(width, height);
    //设置元素相隔距离
    layout.minimumInteritemSpacing = 12;
    //设置行距
    layout.minimumLineSpacing = 10;
    //设置区头大小
    layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 20);
    //设置每个分区距离边界的位置  分别代表 上 左 下 右
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    
    //初始化collectionView
    location = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:layout];
    //设置代理
    location.delegate = self;
    location.dataSource = self;
    //这里很独特 你需要在这里注册你要重用的cell和区头
    [location registerClass:[CollectionReusableCell class] forCellWithReuseIdentifier:@"LOCATION"];
    //UICollectionElementKindSectionHeader 是系统默认的区头格式
    [location registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    location.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:location];
    
    UIButton*btnBack = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"返回" target:self action:@selector(backAction)];
    [btnBack setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    ReminderView*reminder = [ReminderView reminderViewWithTitle:@"正在读取中"];
    [self.view addSubview:reminder];
}
//获取视频时间长度
-(CGFloat) getVideoLength:(NSURL *)movieURL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;//视频的总时长，单位秒
//    NSLog(@"%@====%f",movieURL,second);
    return second;
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取已下载视频列表
-(void)getVideoList
{
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"shipin"];
    NSArray *array = [[NSFileManager defaultManager]subpathsAtPath:filePath];
    for (NSString*str in array)
    {
        if (![str hasSuffix:@"DS_Store"])
        {
            NSString*videoPath = [filePath stringByAppendingPathComponent:str];
            //            NSLog(@"%@",videoPath);
            NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath] options:opts];
            //            AVURLAsset*urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:@"http://119.188.2.50/data2/video04/2013/04/27/00ab3b24-74de-432b-b703-a46820c9cd6f.mp4"] options:opts];
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
            [array1 addObject:image];
            [array3 addObject:videoPath];
            //            [array5 addObject:[self getVideoLength:videoPath]];
        }
    }
}
#pragma mark 获取正在下载视频列表
-(void)getVideoDownloadingList:(NSArray*)array
{
    for (NSString*url in array)
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
        [array2 addObject:image];
//        [array4 addObject:url];
    }
    
    
//    http://119.188.2.50/data2/video04/2013/04/27/00ab3b24-74de-432b-b703-a46820c9cd6f.mp4
    
}

#pragma mark - collectionView delegate

//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
//区内元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return array2.count;
    }
    else
    {
        return array1.count;
    }
}
//重用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LOCATION" forIndexPath:indexPath];
    cell.image.frame = CGRectMake(0, 0, (SCREENWIDTH - 50)/3, (SCREENWIDTH - 50) / 3);
    
    if (indexPath.section == 0)
    {
        [cell.btn addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn.tag = 1000+indexPath.row+100*indexPath.section;
//        int num = (int)[self getVideoLength:[NSURL URLWithString:array4[indexPath.row]]];
//        int second = num%60;
//        int minute = (num/60)>1?(num/60):0;
//        NSLog(@"%d==%d",num,minute);
//        cell.timeLabel.text = [NSString stringWithFormat:@"%d:%d",minute,second];
        cell.timeLabel.hidden = NO;
        if (![cell.timeLabel.text hasSuffix:@"%"])
        {
            cell.timeLabel.text = @"";
        }
        cell.image.image = array2[indexPath.row];
        cell.progressLabel.hidden = NO;
        cell.backdroundLabel.hidden = NO;
    }
    if (indexPath.section == 1)
    {
        [cell.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn.tag = 1000+indexPath.row+100*indexPath.section;
        
        int num = (int)[self getVideoLength:[NSURL fileURLWithPath:array3[indexPath.row]]];
        int second = num%60;
        int minute = (num/60)>1?(num/60):0;
        cell.timeLabel.hidden = NO;
        cell.timeLabel.text = [NSString stringWithFormat:@"%d:%d",minute,second];
        cell.image.image = array1[indexPath.row];
        
        cell.progressLabel.hidden = YES;
        cell.backdroundLabel.hidden = YES;
    }
    return cell;
}

//播放按钮
-(void)btnAction:(UIButton*)btn
{
    int flag = (btn.tag-1000)%1000/100==0?0:1;

    MPMoviePlayerViewController*movie = nil;
    if (flag)
    {
        movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:array3[(btn.tag-1000)%100]]];
    }else
    {
        movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:array4[(btn.tag-1000)%100]]];
    }
    movie.moviePlayer.initialPlaybackTime = [[DealData dealDataClass]selectVideo:[NSString stringWithFormat:@"%@",movie.moviePlayer.contentURL]];
    movie.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [[DealData dealDataClass]videoNotification:self withPlayer:movie];
    
    [self presentMoviePlayerViewControllerAnimated:movie];
}

//重用区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableView *view = nil;
    if (indexPath.section == 0)
    {
        if([kind isEqual:UICollectionElementKindSectionHeader])
        {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
            view.titleLabel.text = @"正在下载";
        }
        return view;
    }else
    {
        if([kind isEqual:UICollectionElementKindSectionHeader])
        {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
            view.titleLabel.text = @"已下载";
        }
        return view;
    }
}

//选中后 重载视图
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1000+100*indexPath.section+indexPath.row;
    if (indexPath.section ==1)
    {
        [self btnAction:btn];
    }else if (indexPath.section ==0)
    {
        [self videoPlay:btn];
    }
}

- (void)videoPlay:(UIButton*)btn
{
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSLog(@"webPath = %@",webPath);
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:array4[(btn.tag-1000)%100]]];
    NSError*error = nil;
    NSURLRequest*request = [manager.requestSerializer requestWithMethod:@"GET" URLString:array4[(btn.tag-1000)%100] parameters:nil error:&error];
    if (error)
    {
        NSLog(@"%@",error);
    }
    ReminderView*reminderView = [ReminderView reminderViewWithTitle:@"正在加载中"];
    [self.view addSubview:reminderView];
//
    unsigned long long downloadedBytes = 0;
    //        if ([[NSFileManager defaultManager] fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]]) {
    //获取已下载的文件长度
    NSString*title = [[array4[(btn.tag-1000)%100] componentsSeparatedByString:@"/"]lastObject];
    downloadedBytes = [self fileSizeForPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]]];
    NSLog(@"%lld",downloadedBytes);
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
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"download"]!=nil)
    {
//        [reminderView removeFromSuperview];
        [self play:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]]];
        
    }else
    {
        NSLog(@"%@",downloadRequest);
        if (downloadRequest!=nil)
        {
            [downloadRequest pause];
        }
        downloadRequest = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        
        //设置下载保存路径
        downloadRequest.outputStream = [NSOutputStream outputStreamToFileAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]] append:YES];
        
        //设置下载块，三个参数分别表示每次读取多少字节，已下载字节，总大小
        __block VideoView*video = self;
        __block BOOL isplay = isplaying;
        __block UICollectionView*collectionView = location;
//        __block AFHTTPRequestOperation*requestOperation = downloadRequest;
        NSLog(@"%u",isplay);
        [downloadRequest setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//            NSLog(@"%lld========%lld+%lld=%lld",totalBytesRead,totalBytesExpectedToRead,downloadedBytes,totalBytesExpectedToRead+downloadedBytes);
           
            NSIndexPath*indexPath = [NSIndexPath indexPathForRow:(int)(btn.tag%1000/100) inSection:btn.tag%1000%100];
            CollectionReusableCell*cell = (CollectionReusableCell*)[collectionView cellForItemAtIndexPath:indexPath];
            unsigned long long a = totalBytesRead+downloadedBytes;
            unsigned long long b = totalBytesExpectedToRead+downloadedBytes;
            float progress = (double)a/(double)b;
            
//            cell.progress.progress =progress;
//            NSLog(@"%f==%f ===%lld==%lld",cell.progress.progress,progress,a,b);
            if (progress ==1)
            {
                cell.timeLabel.hidden = YES;
                cell.backdroundLabel.hidden = YES;
                cell.progressLabel.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.progressLabel.frame = CGRectMake(0, 75, progress*90, 15);
                cell.timeLabel.text = [NSString stringWithFormat:@"%.1f%@",progress*100,@"%"];
            });
            
            if (!isplay&&totalBytesRead>1000000)
            {
                isplay = !isplay;
                [video play:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]]];
//                [cell.progress setProgressWithDownloadProgressOfOperation:requestOperation animated:YES];
            }
            if (!isplay&&downloadedBytes>100000)
            {
                isplay = !isplay;
                [video play:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]]];
            }
        }];
        [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//           NSLog(@"-=----==%@",responseObject);
//           [reminderView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setObject:@"下载完毕" forKey:@"download"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
//            [reminderView removeFromSuperview];
        }];
        //                if (!downloadRequest.isExecuting)
        //                {
        [downloadRequest start];
        //                }
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

-(void)playDidFinish:(NSNotification*)info
{
    MPMoviePlayerViewController*player = [info object];
//    [player dismissMoviePlayerViewControllerAnimated];
    if (player.moviePlayer)
    {
        
    }
    ReminderView*reminder = [ReminderView reminderViewWithTitle:@"正在加载中"];
    [reminder removeFromSuperview];
    isplaying = NO;
//    [downloadRequest pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
//    NSLog(@"===");
    return UIInterfaceOrientationPortrait;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
