//
//  UploadVoiceTable.m
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "UploadVoiceTable.h"
#import "VoiceDownloadingCell.h"
#import "VoiceDownloadCell.h"
@implementation UploadVoiceTable
@synthesize infoUploadArray,infoUploadingArray;
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
//        infoUploadArray = [NSMutableArray arrayWithObjects:@"ssfga",@"dasd",nil];
//        infoUploadingArray = [NSMutableArray arrayWithObjects:@"sa",@"dasd",nil];
//        infoUpload1Array = [[NSMutableArray alloc]init];
//        infoUploading1Array = [[NSMutableArray alloc]init];
//        NSLog(@"%@",infoUploadArray);
        array1 = [[NSMutableArray alloc]init];
        array2 = [[NSMutableArray alloc]init];
        
        self.delegate = self;
        self.dataSource = self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
        self.tableHeaderView = ({
            UIView*view;
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 4)];
            
            view.layer.backgroundColor = colorref;
//            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            if (isPad)
//            {
//                btn.frame = CGRectMake(10, 0, 200, 80);
//                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"add"] Frame:CGRectMake(0, 0, 50, 50)] forState:UIControlStateNormal];
//                btn.titleLabel.font = [UIFont systemFontOfSize:30];
//                
//            }else
//            {
//                btn.frame = CGRectMake(10, 5, 120, 30);
//                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"add"] Frame:CGRectMake(0, 0, 25, 25)] forState:UIControlStateNormal];
//                btn.titleLabel.font = [UIFont systemFontOfSize:18];
//            }
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//            
//            [btn setTitle:@"上传录音" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [btn setTintColor:[UIColor redColor]];
//            [btn addTarget:self action:@selector(uploadBtn) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:btn];
            view;
        });
        
        self.layer.backgroundColor = colorref;
        CGColorRelease(colorref);
        CGColorSpaceRelease(colorSpace);
    }
    return self;
}
-(void)uploadBtn
{
//    NSLog(@"dsdsfgsdgd");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadVoiceView" object:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markCell";
    if (indexPath.section ==1)
    {
        VoiceDownloadCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        //    VoiceInfo*info = infoArray[indexPath.row];
        if (cell ==nil)
        {
            cell = [[VoiceDownloadCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:infoUploadArray[infoUploadArray.count-1-indexPath.row]];
        }
        return cell;
        
    }else if (indexPath.section ==0)
    {
        VoiceDownloadingCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        //    VoiceInfo*info = infoArray[indexPath.row];
        if (cell ==nil)
        {
            cell = [[VoiceDownloadingCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:infoUploadingArray[infoUploadingArray.count-1-indexPath.row]];
        }
        if (indexPath.row ==0&&manager.operationQueue.operationCount ==0)
        {
            NSLog(@"%lu",(unsigned long)manager.operationQueue.operationCount);
            [self uploadVoice];
        }
        return cell;
    }
    return nil;
}
-(void)uploadVoice
{
    if (infoUploadingArray.count>0)
    {
        for (int i = 0; i<infoUploadingArray.count; i++)
        {
            NSLog(@"-=-=-=");
            VoiceInfo*info = infoUploadingArray[i];
            NSURL*url = info.url;
            NSData*data = [NSData dataWithContentsOfURL:url];
//            NSString *urlString = @"http://test.17ll.com/upVideo2/upload.asp";
//            NSString *filename = @"strVideo";
//            NSMutableURLRequest*request= [[NSMutableURLRequest alloc] init];
//            [request setURL:[NSURL URLWithString:urlString]];
//            [request setHTTPMethod:@"POST"];
//            NSString *boundary = @"---------------------------14737809831466499882746641449";
//            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//            [request addValue:@"2z82" forHTTPHeaderField:@"strYZM"];
//            NSMutableData *postbody = [NSMutableData data];
//            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"strVideo\"; filename=\"%@.mp3\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
//            [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            [postbody appendData:[NSData dataWithData:data]];
//            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [request setHTTPBody:postbody];
//            NSError*error = nil;
//            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//            NSString*returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@===error =%@",returnString,error);
            
            if (manager==nil)
            {
                //                http://hzwkw.wicp.net/UploadAndDownload/
                manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://test.17ll.com/PHPUpVideo/"]];
            }
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            __block UploadVoiceTable*tableview = self;
            __block VoiceInfo*infoBlock = info;
            NSDictionary*parameters = @{@"yzm":@"2z82"};

            //  action
//            AFHTTPRequestOperation*uploadRequest = [manager POST:@"upload.asp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@===---%@",operation,responseObject);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"失败");
//            }];

            AFHTTPRequestOperation*uploadRequest = [manager POST:@"scsp.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:data name:@"fp" fileName:[[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject] mimeType:@"audio/mp3"];
//                audio/mp3 video/mpeg4
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@===---%@",operation,responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败");
            }];
            
            AFHTTPRequestOperation*operationRequest = uploadRequest;
            [uploadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSError*error = nil;
//                NSString*str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
//                NSLog(@"====%@",error);
                
                NSLog(@"获取到的数据为：%@===%@",[dict objectForKey:@"videoPath"],dict);
                NSLog(@"sadas成功");
                infoBlock.uploadUrl = [dict objectForKey:@"furl"];
                
                for (AFHTTPRequestOperation*operation1 in array2)
                {
                    if ([operation1 isEqual:operationRequest])
                    {
//                        NSUInteger a = [array2 indexOfObject:operation1];
                        [[DealData dealDataClass]deleteUploadVoice:[[[NSString stringWithFormat:@"%@",infoBlock.url] componentsSeparatedByString:@"/"] lastObject]];
                        [[DealData dealDataClass]saveUploadedVoice:infoBlock];
                        [[DealData dealDataClass]deleteVoice:[[[NSString stringWithFormat:@"%@",infoBlock.url] componentsSeparatedByString:@"/"] lastObject]];
                        infoUploadingArray = (NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
                        infoUploadArray = (NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
                        [tableview reloadData];
                        return;
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [uploadRequest setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"%lu,%lld,%lld",(unsigned long)bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
                NSIndexPath*indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                VoiceDownloadingCell*cell = (VoiceDownloadingCell*)[tableview cellForRowAtIndexPath: indexPath];
                unsigned long long a = totalBytesWritten+bytesWritten;
                unsigned long long b ;
                b = totalBytesExpectedToWrite+bytesWritten;
                float progress = (double)a/(double)b;
                infoBlock.progress = progress;
                infoBlock.sumMemory = b;
                infoBlock.downloadMemory = a;
//                cell.info = infoBlock;
                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.info = infoBlock;
                    [cell updateInfo:info];
//                    NSLog(@"%@",infoBlock.url);
                });
            }];
            [uploadRequest start];
            [array2 addObject:uploadRequest];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%lu==%lu",(unsigned long)infoUploadArray.count,(unsigned long)infoUploadingArray.count);
    if (section==0)
    {
        return infoUploadingArray.count;
    }
    
    return infoUploadArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if (editingStyle ==UITableViewCellEditingStyleDelete)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = 3000+indexPath.section*100+indexPath.row;
            [alert show];
        }
    }else if (indexPath.section ==0)
    {
        VoiceInfo*info = infoUploadingArray[indexPath.row];
        NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
        [[DealData dealDataClass]deleteUploadVoice:url];
        infoUploadingArray =(NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
        [self reloadData];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        if (alertView.tag%3000/100==1)
        {
            int a = alertView.tag%3100;
            VoiceInfo*info = infoUploadArray[a];
            NSLog(@"%@",infoUploadArray);
            NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
            [[DealData dealDataClass]deleteUploadedVoice:url];
            
            NSFileManager*fileManager = [NSFileManager defaultManager];
            NSString*str = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url];
            [fileManager removeItemAtPath:str error:nil];
            
            infoUploadArray =(NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BOOL bool1 = (infoUploadArray.count>0&&section==1)||(infoUpload1Array.count>0&&section==1);
    BOOL bool2 = (infoUploadingArray.count>0&&section==0)||(infoUploading1Array.count>0&&section==0);
    if (bool2)
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        BOOL bool2 = (infoUploadingArray.count>0&&section==0)||(infoUploading1Array.count>0&&section==0);
        if (bool2)
        {
            return 15;
        }
        return 0.0001;
    }
    return 0.0001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    BOOL bool1 = (infoUploadArray.count>0&&section==1)||(infoUpload1Array.count>0&&section==1);
//    BOOL bool2 = (infoUploadingArray.count>0&&section==0)||(infoUploading1Array.count>0&&section==0);
//    if (bool1||bool2)
//    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 1100+section;
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33)];
        title.backgroundColor = [UIColor whiteColor];
        title.textColor = [UIColor grayColor];
        title.textAlignment = NSTextAlignmentLeft;
        if (section ==0)
        {
            if (infoUploadingArray.count>0)
            {
                title.text = [NSString stringWithFormat:@"  正在上传录音(%lu)",(unsigned long)[infoUploadingArray count]];
            }else if (infoUploading1Array.count>0)
            {
                title.text = [NSString stringWithFormat:@"  正在上传录音(%lu)",(unsigned long)[infoUploading1Array count]];
            }
        }else if (section ==1)
        {
            if (infoUploadArray.count>0)
            {
                title.text = [NSString stringWithFormat:@"  网络录音(%lu)",(unsigned long)[infoUploadArray count]];
            }else if (infoUpload1Array.count>0)
            {
                title.text = [NSString stringWithFormat:@"  网络录音(%lu)",(unsigned long)[infoUpload1Array count]];
            }else
            {
                title.text = [NSString stringWithFormat:@"  网络录音(0)"];
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
//    }
//    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
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
        if (infoUpload1Array.count>0)
        {
            infoUploadArray = [infoUpload1Array mutableCopy];
            [infoUpload1Array removeAllObjects];
        }else
        {
            infoUpload1Array = [infoUploadArray mutableCopy];
            [infoUploadArray removeAllObjects];
        }
        [self reloadData];
    }else if (btn ==0)
    {
        
        if (infoUploading1Array.count>0)
        {
            infoUploadingArray = [infoUploading1Array mutableCopy];
//            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [infoUploading1Array removeAllObjects];
        }else
        {
            infoUploading1Array = [infoUploadingArray mutableCopy];
//            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [infoUploadingArray removeAllObjects];
        }
        [self reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==1)
    {
        VoiceInfo*info = infoUploadArray[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"voicedownload" object:nil userInfo:[NSDictionary dictionaryWithObject:info forKey:@"voicedownload"]];
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
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
        NSString*url=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:contenturl];
//         NSLog(@"%@==%@==%@",url,error,[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"]);
        if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@",url]])
        {
            player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:url] error:&error];
            NSLog(@"%@==%@",url,error);
        }
//        else
//        {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSData * audioData = [NSData dataWithContentsOfURL:info.uploadUrl];
//                //将数据保存到本地指定位置
//                NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
//                [audioData writeToFile:filePath atomically:YES];
//                
//                //播放本地音乐
//                NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
//                });
//            });
//        }
        
       
        [player prepareToPlay];
        player.delegate = self;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
            [timer fire];
            [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
        });
        
    }else if (indexPath.section ==0)
    {
        
    }
    
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
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"voiceplay"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
    }else
    {
        [player play];
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"voicestart"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
    }
}
@end
