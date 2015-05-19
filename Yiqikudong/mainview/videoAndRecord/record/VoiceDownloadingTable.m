//
//  VoiceDownloadingTable.m
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "VoiceDownloadingTable.h"

@implementation VoiceDownloadingTable

@synthesize infoArray,info1Array;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
        self.layer.backgroundColor = colorref;
        
        self.tableHeaderView = ({
            UIView*view;
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
            view.layer.backgroundColor = colorref;
            UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, SCREENWIDTH, 33)];
            title.backgroundColor = [UIColor whiteColor];
            title.textColor = [UIColor grayColor];
            title.textAlignment = NSTextAlignmentCenter;
            title.text = [NSString stringWithFormat:@"可前往'%@'处下载",@"网络录音"];
            [view addSubview:title];
            view;
        });
        CGColorRelease(colorref);
        CGColorSpaceRelease(colorSpace);
    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markCell";
    
    //    VoiceInfo*info = infoArray[indexPath.row];
    if (indexPath.section ==0)
    {
        VoiceDownloadingCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell ==nil)
        {
            cell = [[VoiceDownloadingCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:infoArray[infoArray.count-1-indexPath.row]];
        }
        if (indexPath.row ==0)
        {
            [self voiceDownloading];
        }
        return cell;
    }else if (indexPath.section ==1)
    {
        VoiceDownloadCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        //    VoiceInfo*info = infoArray[indexPath.row];
        if (cell ==nil)
        {
            cell = [[VoiceDownloadCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:info1Array[info1Array.count-1-indexPath.row]];
        }
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return infoArray.count;
    }
    return info1Array.count;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 3000+indexPath.section*100+indexPath.row;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag%3000/100==1)
        {
            VoiceInfo*info = info1Array[alertView.tag-3100];
            NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
            [[DealData dealDataClass]deleteDownloadingVoice:url];
            
            NSFileManager*fileManager = [NSFileManager defaultManager];
            NSString*str = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voiceDownload"] stringByAppendingPathComponent:url];
            [fileManager removeItemAtPath:str error:nil];
            
            info1Array = (NSMutableArray*)[[DealData dealDataClass]getDownloadingVoiceData];
            [self reloadData];
        }
        
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        BOOL bool2 = (infoArray.count>0&&section==0)||(infoArray1.count>0&&section==0);
        if (bool2)
        {
            return 15;
        }
        return 0.0001;
    }
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BOOL bool1 = (info1Array.count>0&&section==1)||(info1Array1.count>0&&section==1);
    BOOL bool2 = (infoArray.count>0&&section==0)||(infoArray1.count>0&&section==0);    if (bool2)
    {
        return 36;
    }
    if (bool1)
    {
        return 36;
    }else
    {
        return 1;
    }
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BOOL bool1 = (info1Array.count>0&&section==1)||(info1Array1.count>0&&section==1);
    BOOL bool2 = (infoArray.count>0&&section==0)||(infoArray1.count>0&&section==0);
    if (bool1||bool2)
    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 1100+section;
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33)];
        title.backgroundColor = [UIColor whiteColor];
        title.textColor = [UIColor grayColor];
        title.textAlignment = NSTextAlignmentLeft;
        if (section ==0)
        {
            if (infoArray.count>0)
            {
                title.text = [NSString stringWithFormat:@"  正在下载录音(%lu)",(unsigned long)[infoArray count]];
            }else if (infoArray1.count>0)
            {
                title.text = [NSString stringWithFormat:@"  正在下载录音(%lu)",(unsigned long)[infoArray1 count]];
            }
        }else if (section ==1)
        {
            if (info1Array.count>0)
            {
                title.text = [NSString stringWithFormat:@"  已下载录音(%lu)",(unsigned long)[info1Array count]];
            }else if (info1Array1.count>0)
            {
                title.text = [NSString stringWithFormat:@"  已下载录音(%lu)",(unsigned long)[info1Array1 count]];
            }
        }
        [view addSubview:title];
        view.userInteractionEnabled = YES;
        
        
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREENWIDTH-50, 3, 40, 27);
        if (section == 0&&!flag)
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }else if (section == 0&&flag)
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }else if (section == 1&&!flag1)
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }else if (section == 1&&flag1)
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
        UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
        [btn addGestureRecognizer:tap];
        //        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+section;
        [view addSubview:btn];
        [view addGestureRecognizer:tap1];
        
        return view;
    }
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
-(void)btnAction:(UITapGestureRecognizer*)tap
{
    int btn = 0;
    if ([tap.view isKindOfClass:[UIButton class]])
    {
        btn = (int)(tap.view.tag -1000);
    }else if ([tap.view isKindOfClass:[UIView class]])
    {
        btn = (int)(tap.view.tag -1100);
    }
    if (btn == 0)
    {
        if (flag)
        {
            //            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 30, 18)] forState:UIControlStateNormal];
            flag = 0;
        }else
        {
            //            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 30, 18)] forState:UIControlStateNormal];
            flag = 1;
        }
    }else if (btn == 1)
    {
        if (flag1)
        {
            //            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 30, 18)] forState:UIControlStateNormal];
            flag1 = 0;
        }else
        {
            //            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 30, 18)] forState:UIControlStateNormal];
            flag1 = 1;
        }
    }
    
    [self dealData:btn];
    
}
-(void)dealData:(int)btn
{
    if (btn==1)
    {
        if (info1Array1.count>0)
        {
            info1Array = [info1Array1 mutableCopy];
            [info1Array1 removeAllObjects];
        }else
        {
            info1Array1 = [info1Array mutableCopy];
            [info1Array removeAllObjects];
        }
        [self reloadData];
    }else if (btn ==0)
    {
        
        if (infoArray1.count>0)
        {
            infoArray = [infoArray1 mutableCopy];
            //            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [infoArray1 removeAllObjects];
        }else
        {
            infoArray1 = [infoArray mutableCopy];
            //            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [infoArray removeAllObjects];
        }
        [self reloadData];
    }
}
-(void)voiceDownloading
{
    NSMutableArray*downloadArray = [[NSMutableArray alloc]init];
//    [array1 removeAllObjects];
    if (infoArray.count>0)
    {
        for (int i = 0; i<infoArray.count; i++)
        {
            VoiceInfo*info =infoArray[i];
//            NSString*urlStr = info.uploadUrl;
//            info.image = [self getVideoDownloadingList:info.uploadUrl];
            NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voiceDownload"];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:cachePath])
            {
                [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            AFHTTPRequestOperationManager*manager = [[AFHTTPRequestOperationManager alloc]init];
            NSError*error = nil;
            NSURLRequest*request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@",info.uploadUrl] parameters:nil error:&error];
            if (error)
            {
                NSLog(@"===%@",error);
            }
            unsigned long long downloadedBytes = 0;
            //获取已下载的文件长度
            NSString*title = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"]lastObject];
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
            downloadRequest.outputStream = [NSOutputStream outputStreamToFileAtPath:[cachePath stringByAppendingPathComponent:title] append:YES];
            NSLog(@"%@",title);
            //设置下载块，三个参数分别表示每次读取多少字节，已下载字节，总大小
            //        __block DownOrUploadView*video = self;

            __block UITableView*tableview = self;
            __block VoiceInfo*infoBlock = info;
            [downloadRequest setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                //                            NSLog(@"%lld========%lld+%lld=%lld",totalBytesRead,totalBytesExpectedToRead,downloadedBytes,totalBytesExpectedToRead+downloadedBytes);
                
                NSIndexPath*indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                VoiceDownloadingCell*cell = (VoiceDownloadingCell*)[tableview cellForRowAtIndexPath: indexPath];
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
                    [cell updateInfo:infoBlock];
                });
               
            }];
//            [[NSUserDefaults standardUserDefaults] setObject:@"下载中" forKey:@"downloadState"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            AFHTTPRequestOperation*operationRequest = downloadRequest;
            [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[DealData dealDataClass]saveDownloadVoice:infoBlock];
                [[DealData dealDataClass]deleteDownloadingVoice:[[[NSString stringWithFormat:@"%@",infoBlock.url] componentsSeparatedByString:@"/"] lastObject]];
                infoArray = (NSMutableArray*)[[DealData dealDataClass] getDownloadingVoiceData];
                info1Array = (NSMutableArray*)[[DealData dealDataClass] getDownloadVoiceData];
                [tableview reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [downloadRequest start];
            [downloadArray addObject:downloadRequest];
        }
        [AFHTTPRequestOperation batchOfRequestOperations:downloadArray progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            
        } completionBlock:^(NSArray *operations) {
            
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceInfo*info = info1Array[indexPath.row];
    int height;
    if (isPad)
    {
        height = 100;
        playView = [[VoicePlayView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-height-125, SCREENWIDTH, height) info:info];
    }else
    {
        height = 50;
        playView = [[VoicePlayView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-height-105, SCREENWIDTH, height) info:info];
    }
    [playView.starBtn addTarget:self action:@selector(starPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:playView];
    NSError*error;
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:info.url error:&error];
    [player prepareToPlay];
    NSLog(@"player.error===%@",error);
    player.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
    });
}
-(void)timer
{
    if (player.isPlaying)
    {
        //        int second = (int)player.currentTime%60;
        //        int mimute = (int)player.currentTime/60>60?(int)player.currentTime/60%60:(int)player.currentTime/60;
        //        int hour = (int)player.currentTime/60>60?(int)player.currentTime/60/60:00;
        dispatch_async(dispatch_get_main_queue(), ^{
            playView.timeLabel.attributedText = [playView getTimeStringWithCurrentTime:player.currentTime sumTime:player.duration];
            playView.progress.progress = player.currentTime/player.duration;
        });
    }
}

-(void)starPlay:(UIButton*)btn
{
    if (player.isPlaying)
    {
        [player stop];
        if (isPad)
        {
            [btn setImage:[UIImage imageNamed:@"voiceplay"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"voiceplay"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
        }
        
    }else
    {
        [player play];
        if (isPad)
        {
            [btn setImage:[UIImage imageNamed:@"voicestart"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"voicestart"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
        }
        
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
@end
