//
//  LocalVoiceView.m
//  YiQiWeb
//
//  Created by BK on 15/1/8.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "LocalVoiceView.h"
#import "UploadView.h"
#import "Common.h"

@interface LocalVoiceView ()

@end

@implementation LocalVoiceView
@synthesize tableview;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    localVoiceArray = [[DealData dealDataClass]getVoiceData];
    uploadedArray = [[DealData dealDataClass]getUploadedVoiceData];
    uploadingArray = [[DealData dealDataClass]getUploadVoiceData];
    [tableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    voicesArray = [[NSMutableArray alloc]init];
    numArray = [[NSMutableArray alloc]init];
    array1 = [[NSMutableArray alloc]init];
    array2 = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    localVoiceArray = [[DealData dealDataClass]getVoiceData];
    uploadedArray = [[DealData dealDataClass]getUploadedVoiceData];
    uploadingArray = [[DealData dealDataClass]getUploadVoiceData];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    tableview.layer.backgroundColor = WHITECOLOR.CGColor;
    [self.view addSubview:tableview];

    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50)];
    view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:view];
    for (int i =0; i<2; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0)
        {
            btn.frame = CGRectMake(10, 8, 80, 34);
            [btn setTitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setTitle:@"传输列表" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            btn.layer.borderColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1].CGColor;
            btn.layer.borderWidth = 1;
        }else if (i==1)
        {
            btn.frame = CGRectMake(SCREENWIDTH-90, 8, 80, 34);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"上传" forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor redColor]];
            [btn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        btn.layer.cornerRadius = 5;
        
    }
    
    self.view.layer.backgroundColor = colorref;
    self.title = @"录音大厅";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backbutton.tintColor = WHITECOLOR;
    self.navigationItem.leftBarButtonItem = backbutton;
    
//    UIBarButtonItem*allBtn = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
//    allBtn.tintColor = WHITECOLOR;
//    self.navigationItem.rightBarButtonItem = allBtn;
    
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
}
-(void)rightBarAction:(UIBarButtonItem*)btn
{
    if ([btn.title  isEqualToString:@"全选"])
    {
        btn.title = @"全不选";
        [voicesArray removeAllObjects];
        [numArray removeAllObjects];
        
        for (int i=0; i<localVoiceArray.count; i++)
        {
            [voicesArray addObject:localVoiceArray[i]];
            [numArray addObject:[NSNumber numberWithInt:i]];
        }
        [tableview reloadData];
    }else if ([btn.title  isEqualToString:@"全不选"])
    {
        btn.title = @"全选";
        [voicesArray removeAllObjects];
        [numArray removeAllObjects];
        [tableview reloadData];
    }
}

-(void)listAction:(UIButton*)btn
{
    VoiceListView*voiceListView = [[VoiceListView alloc]init];
    voiceListView.kind = @"上传";
    [self.navigationController pushViewController:voiceListView animated:YES];
}
-(void)uploadAction:(UIButton*)btn
{
    if (voicesArray.count>0)
    {
        if (voicesArray.count<4)
        {
            for (VoiceInfo*info in voicesArray)
            {
                [[DealData dealDataClass]saveUploadVoice:info];
            }
            localVoiceArray = [[DealData dealDataClass]getVoiceData];
            uploadedArray = [[DealData dealDataClass]getUploadedVoiceData];
            uploadingArray = [[DealData dealDataClass]getUploadVoiceData];
            [tableview reloadData];
        }else
        {
            ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"同时上传的录音数量上限,请稍等候其他上传完成再添加"];
            [self.view addSubview:remiderView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:0.5];//动画运行时间
                remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
                [UIView commitAnimations];//提交动画
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [remiderView removeFromSuperview];
                });
            });
        }
        
//        VoiceListView*voiceListView = [[VoiceListView alloc]init];
//        voiceListView.kind = @"上传";
//        [self.navigationController pushViewController:voiceListView animated:YES];
    }else
    {
        [Common showMessage:@"请选择要上传的录音" withView:self.view];
//        ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"请选择要上传的录音"];
//        [self.view addSubview:remiderView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationDuration:0.5];//动画运行时间
//            remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//            [UIView commitAnimations];//提交动画
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [remiderView removeFromSuperview];
//            });
//        });
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markCell";
    if (indexPath.section ==0) {
        LocalVoiceCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
        if (cell==nil)
        {
            cell = [[LocalVoiceCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) info:localVoiceArray[localVoiceArray.count-1-indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.image.image = [UIImage imageNamed:@"quan"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSNumber*number in numArray)
            {
                if (number.integerValue == indexPath.row)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
                        cell.image.image = [UIImage imageNamed:@"nike"];
                    });
                }
            }
        });
        return cell;
    }else if (indexPath.section==1)
    {
        VoiceDownloadingCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        //    VoiceInfo*info = infoArray[indexPath.row];
        if (cell ==nil)
        {
            cell = [[VoiceDownloadingCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:uploadingArray[uploadingArray.count-1-indexPath.row]];
        }
        if (indexPath.row ==0&&manager.operationQueue.operationCount ==0)
        {
            NSLog(@"%lu",(unsigned long)manager.operationQueue.operationCount);
            [self uploadVoice];
        }
        return cell;
    }else if (indexPath.section ==2)
    {
        VoiceDownloadCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
        if (cell==nil)
        {
            cell = [[VoiceDownloadCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:uploadedArray[uploadedArray.count-1-indexPath.row]];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;
}
-(void)uploadVoice
{
    if (uploadingArray.count>0)
    {
        for (int i = 0; i<uploadingArray.count; i++)
        {
            NSLog(@"-=-=-=");
            VoiceInfo*info = uploadingArray[i];
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
//            __block UITableView*tableView = tableview; 
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
                        localVoiceArray = [[DealData dealDataClass]getVoiceData];
                        uploadingArray = (NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
                        uploadedArray = (NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
                        [tableview reloadData];
                        return;
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [uploadRequest setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"%lu,%lld,%lld",(unsigned long)bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
                NSIndexPath*indexPath = [NSIndexPath indexPathForRow:i inSection:1];
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
    if (section==0)
    {
        return localVoiceArray.count;
    }else if (section==1)
    {
        return uploadingArray.count;
    }else if (section==2)
    {
        return uploadedArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0||section==1)
    {
        return 3;
    }
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0||section==1)
    {
        //        if (localVoiceArray.count>0)
        //        {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 3)];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
        view.layer.backgroundColor = colorref;
        CGColorRelease(colorref);
        CGColorSpaceRelease(colorSpace);
        return view;
        //        }
    }
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 3)];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    view.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
//        if (uploadedArray.count>0)
//        {
            return 36;
//        }
//        return 0;
    }else if (section==1)
    {
//        if (uploadingArray.count>0)
//        {
            return 36;
//        }else
//        {
//            return 0;
//        }
    }else if (section==2)
    {
//        if (uploadedArray.count>0)
//        {
            return 36;
//        }
    }
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//        if (localVoiceArray.count>0)
//        {
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
    //        view.backgroundColor = [UIColor lightGrayColor];
    view.tag = 1100+section;
    UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33)];
    title.backgroundColor = [UIColor whiteColor];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentLeft;
    if (section==0)
    {
        if (localVoiceArray.count>0)
        {
            title.text = [NSString stringWithFormat:@"  未上传录音(%lu)",(unsigned long)[localVoiceArray count]];
        }else if (localVoiceArray1.count>0)
        {
            title.text = [NSString stringWithFormat:@"  未上传录音(%lu)",(unsigned long)[localVoiceArray1 count]];
        }else
        {
            title.text = [NSString stringWithFormat:@"  未上传录音(0)"];
        }
        
    }else if (section==1)
    {
        if (uploadingArray.count>0)
        {
            title.text = [NSString stringWithFormat:@"  正在上传录音(%lu)",(unsigned long)[uploadingArray count]];
        }else if (uploadingArray1.count>0)
        {
            title.text = [NSString stringWithFormat:@"  正在上传录音(%lu)",(unsigned long)[uploadingArray1 count]];
        }else
        {
            title.text = [NSString stringWithFormat:@"  正在上传录音(0)"];
        }
    }else if (section==2)
    {
        if (uploadedArray.count>0)
        {
            title.text = [NSString stringWithFormat:@"  已上传录音(%lu)",(unsigned long)[uploadedArray count]];
        }else if (uploadedArray1.count>0)
        {
            title.text = [NSString stringWithFormat:@"  已上传录音(%lu)",(unsigned long)[uploadedArray1 count]];
        }else
        {
            title.text = [NSString stringWithFormat:@"  已上传录音(0)"];
        }
    }
    [view addSubview:title];
    view.userInteractionEnabled = YES;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    view.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREENWIDTH-50, 3, 40, 27);
    
    if (section==0)
    {
        if (localVoiceArray.count>0||localVoiceArray.count>0)
        {
            if (section == 0&&!flag)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
            }else if (section == 0&&flag)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
            }
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }
    }else if (section==1)
    {
        if (uploadingArray.count>0||uploadingArray1.count>0)
        {
            if (section == 1&&!flag1)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
            }else if (section == 1&&flag1)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
            }
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }
    }else if (section==2)
    {
        if (uploadedArray.count>0||uploadedArray1.count>0)
        {
            if (section == 2&&!flag2)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
            }else if (section == 2&&flag2)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
            }
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 25, 15)] forState:UIControlStateNormal];
        }
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
    }else if (btn == 2)
    {
        if (flag2)
        {
            //            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"DownAccessory"] Frame:CGRectMake(0, 0, 30, 18)] forState:UIControlStateNormal];
            flag2 = 0;
        }else
        {
            //            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"UpAccessory"] Frame:CGRectMake(0, 0, 30, 18)] forState:UIControlStateNormal];
            flag2 = 1;
        }
    }
    
    [self dealData:btn];
}
-(void)dealData:(int)btn
{
    if (btn==1)
    {
        if (uploadingArray1.count>0)
        {
            uploadingArray = [uploadingArray1 mutableCopy];
            [uploadingArray1 removeAllObjects];
        }else
        {
            uploadingArray1 = [uploadingArray mutableCopy];
            [uploadingArray removeAllObjects];
        }
        [tableview reloadData];
    }else if (btn ==0)
    {
        
        if (localVoiceArray1.count>0)
        {
            localVoiceArray = [localVoiceArray1 mutableCopy];
            //            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [localVoiceArray1 removeAllObjects];
        }else
        {
            localVoiceArray1 = [localVoiceArray mutableCopy];
            //            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [localVoiceArray removeAllObjects];
        }
        [tableview reloadData];
    }else if (btn ==2)
    {
        
        if (uploadedArray1.count>0)
        {
            uploadedArray = [uploadedArray1 mutableCopy];
            //            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [uploadedArray1 removeAllObjects];
        }else
        {
            uploadedArray1 = [uploadedArray mutableCopy];
            //            NSLog(@"%@==%@",infoUploadingArray,infoUploading1Array);
            [uploadedArray removeAllObjects];
        }
        [tableview reloadData];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 10000+indexPath.section*1000+indexPath.row;
        NSLog(@"%ld,%lu",(long)alert.tag%10000/1000,alert.tag);
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        if (alertView.tag%10000/1000==0)
        {
            VoiceInfo*info = localVoiceArray[alertView.tag-10000];
            NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
            [[DealData dealDataClass]deleteVoice:url];
            NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:voicePath])
            {
                [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *mp3FilePath = [voicePath stringByAppendingPathComponent:url];
            [fileManager removeItemAtPath:mp3FilePath error:nil];
            
            localVoiceArray = [[DealData dealDataClass]getVoiceData];
            [tableview reloadData];
        }else if (alertView.tag%10000/1000==1)
        {
            VoiceInfo*info = uploadingArray[alertView.tag-11000];
            NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
            [[DealData dealDataClass]deleteUploadVoice:url];
            
            uploadingArray = [[DealData dealDataClass]getUploadVoiceData];
            [tableview reloadData];
        }else if (alertView.tag%10000/1000==2)
        {
            VoiceInfo*info = uploadedArray[alertView.tag-12000];
            NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
            [[DealData dealDataClass]deleteUploadedVoice:url];
            
            NSFileManager*fileManager = [NSFileManager defaultManager];
            NSString*str = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url];
            [fileManager removeItemAtPath:str error:nil];
            
            uploadedArray = [[DealData dealDataClass]getUploadedVoiceData];
            [tableview reloadData];
        }
//        NSLog(@"%d",alertView.tag%10000/1000);
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        LocalVoiceCell*cell = (LocalVoiceCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.backgroundColor isEqual:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]])
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.image.image = [UIImage imageNamed:@"quan"];
            //        UIImageView*view = (UIImageView*)[cell.contentView viewWithTag:13000+indexPath.row];
            //        view.image = [UIImage imageNamed:@"quan"];
            int a = 0,b = 0,c = 0;
            for (VoiceInfo*info in voicesArray)
            {
                a++;
                if ([info isEqual:localVoiceArray[indexPath.row]])
                {
                    b = a;
                    c = 1;
                }
            }
            if (c==1)
            {
                [voicesArray removeObjectAtIndex:b-1];
                [numArray removeObjectAtIndex:b-1];
            }
            UIBarButtonItem*allBtn = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
            allBtn.tintColor = WHITECOLOR;
            self.navigationItem.rightBarButtonItem = allBtn;
            
            
        }else
        {
            cell.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
            [voicesArray addObject:localVoiceArray[indexPath.row]];
            [numArray addObject:[NSNumber numberWithInteger:indexPath.row]];
            //        cell.accessoryType=UITableViewCellAccessoryCheckmark;
            //        UIImageView*view = (UIImageView*)[cell.contentView viewWithTag:13000+indexPath.row];
            //        view.image = [UIImage imageNamed:@"nike"];
            cell.image.image = [UIImage imageNamed:@"nike"];
        }
    }else if (indexPath.section ==1)
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
//            NSLog(@"%@",[playView getTimeStringWithCurrentTime:player.currentTime sumTime:player.duration]);
            playView.timeLabel.attributedText = [playView getTimeStringWithCurrentTime:player.currentTime sumTime:player.duration];
            if (player.currentTime/player.duration>0.99||player.duration-player.currentTime<0.3)
            {
                playView.progress.progress = 1;
                int height;
                if (SCREENWIDTH>320)
                {
                    height = 21;
                }else
                {
                    height = 18;
                }
                [playView.starBtn setImage:[UIImage redraw:[UIImage imageNamed:@"voiceplay"] Frame:CGRectMake(0, 0, height, height)] forState:UIControlStateNormal];
            }else
            {
                playView.progress.progress = player.currentTime/player.duration;
            }
        });
    }
}
-(void)selectedUpload
{
//    CMTime startTrimTime = CMTimeMakeWithSeconds(2, 1);
//    
//    CMTime endTrimTime = CMTimeMakeWithSeconds(2+3, 1);
//    
//    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTrimTime, endTrimTime);
//    exportSession.timeRange = exportTimeRange;
//    NSLog(@"%@",selectedIndexPath);
    if ([self.kind isEqualToString:@"录音"])
    {
        UploadView*upload = [[UploadView alloc]init];
        upload.kind = self.kind;
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:upload animated:YES];
//        NSDictionary*dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:localVoiceArray[selectedIndexPath.row],@"local", nil] forKeys:[NSArray arrayWithObjects:@"selectedVoice", @"local",nil]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadVoice" object:nil userInfo:dict];
    }
//    {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadVoice" object:nil userInfo:[NSDictionary dictionaryWithObject:localVoiceArray[selectedIndexPath.row] forKey:@"selectedVoice"]];
    });
}

-(void)starPlay:(UIGestureRecognizer*)btn
{
    int height;
    if (SCREENWIDTH>320)
    {
        height = 21;
    }else
    {
        height = 18;
    }
    if (player.isPlaying)
    {
        [player stop];
        [playView.starBtn setImage:[UIImage redraw:[UIImage imageNamed:@"voiceplay"] Frame:CGRectMake(0, 0, height, height)] forState:UIControlStateNormal];
    }else
    {
        [player play];
        [playView.starBtn setImage:[UIImage redraw:[UIImage imageNamed:@"voicestart"] Frame:CGRectMake(0, 0, height, height)] forState:UIControlStateNormal];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
