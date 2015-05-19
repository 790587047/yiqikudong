//
//  VoiceListView.m
//  ;
//
//  Created by BK on 15/2/25.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VoiceListView.h"
#import "Common.h"

@interface VoiceListView ()

@end

@implementation VoiceListView
@synthesize uploadingArray,baseView,kind;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backbutton.tintColor = WHITECOLOR;
    self.navigationItem.leftBarButtonItem = backbutton;
    
    self.title = @"录音传输列表";
    
    for (int i = 0; i<2; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREENWIDTH/2*i, TbarHeight, SCREENWIDTH/2, 40);
        if (i == 0)
        {
            [btn setTitle:@"网络录音" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-1, 10, 1, 20)];
            line.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:line];
            lastBtn = btn;
        }else
        {
            [btn setTitle:@"下载" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        btn.tag = 1100+i;
        [btn setBackgroundColor:WHITECOLOR];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, TbarHeight+40, SCREENWIDTH, SCREENHEIGHT-40-TbarHeight)];
    baseView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:baseView];
    
    [self initView];
}
-(void)initView
{
    if ([kind isEqualToString:@"上传"])
    {
        UIButton*btn = (UIButton*)[self.view viewWithTag:1100];
        [lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        lastBtn = btn;
        
        for (UIView*view in baseView.subviews)
        {
            [view removeFromSuperview];
        }
        
        if (uploadVoiceTable==nil)
        {
            uploadVoiceTable = [[UploadVoiceTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, baseView.frame.size.height) style:UITableViewStylePlain];
            uploadVoiceTable.infoUploadingArray = (NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
            uploadVoiceTable.infoUploadArray = (NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
            NSLog(@"%@",uploadVoiceTable.infoUploadArray);
            [baseView addSubview:uploadVoiceTable];
        }else
        {
            [baseView addSubview:uploadVoiceTable];
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"uploadVoiceView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUploadVoiceView) name:@"uploadVoiceView" object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"voicedownload" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicedownload:) name:@"voicedownload" object:nil];
    }else
    {
        for (UIView*view in baseView.subviews)
        {
            [view removeFromSuperview];
        }
        VoiceDownloadingTable*voiceDownloadingTable;
        if (isPad)
        {
            voiceDownloadingTable = [[VoiceDownloadingTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-125) style:UITableViewStylePlain];
        }else
        {
            voiceDownloadingTable = [[VoiceDownloadingTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-105) style:UITableViewStylePlain];
        }
        
        //        RecordView*recordView = [[RecordView alloc]init];
        voiceDownloadingTable.infoArray = (NSMutableArray*)[[DealData dealDataClass]getDownloadingVoiceData];
        voiceDownloadingTable.info1Array = (NSMutableArray*)[[DealData dealDataClass]getDownloadVoiceData];
        //        [recordView.view addSubview:table];
        [baseView addSubview:voiceDownloadingTable];
    }
}



-(void)btnAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"下载"])
    {
        [lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        lastBtn = btn;
        
        for (UIView*view in baseView.subviews)
        {
            [view removeFromSuperview];
        }
        self.navigationItem.rightBarButtonItem = nil;
        VoiceDownloadingTable*voiceDownloadingTable;
        if (isPad)
        {
            voiceDownloadingTable = [[VoiceDownloadingTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-125) style:UITableViewStylePlain];
        }else
        {
            voiceDownloadingTable = [[VoiceDownloadingTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-105) style:UITableViewStylePlain];
        }
        
        //        RecordView*recordView = [[RecordView alloc]init];
        voiceDownloadingTable.infoArray = (NSMutableArray*)[[DealData dealDataClass]getDownloadingVoiceData];
        voiceDownloadingTable.info1Array = (NSMutableArray*)[[DealData dealDataClass]getDownloadVoiceData];
        //        [recordView.view addSubview:table];
        [baseView addSubview:voiceDownloadingTable];
    }else if ([btn.titleLabel.text isEqualToString:@"网络录音"])
    {
        [lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        lastBtn = btn;
        
        for (UIView*view in baseView.subviews)
        {
            [view removeFromSuperview];
        }
        
        if (uploadVoiceTable==nil)
        {
            uploadVoiceTable = [[UploadVoiceTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, baseView.frame.size.height) style:UITableViewStylePlain];
//            uploadVoiceTable.infoUploadingArray = (NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
            uploadVoiceTable.infoUploadArray = (NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
            NSLog(@"%@",uploadVoiceTable.infoUploadArray);
            [baseView addSubview:uploadVoiceTable];
        }else
        {
            [baseView addSubview:uploadVoiceTable];
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"uploadVoiceView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUploadVoiceView) name:@"uploadVoiceView" object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"voicedownload" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicedownload:) name:@"voicedownload" object:nil];
    }
}
//下载数据更新
-(void)voicedownload:(NSNotification*)info
{
    //    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(0, 0, 40, 30);
    //    [btn setTitle:@"下载" forState:UIControlStateNormal];
    //    [btn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(selectedDownload) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    
    UIBarButtonItem*btn = [[UIBarButtonItem alloc]initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(selectedDownload)];
    btn.tintColor = WHITECOLOR;
    self.navigationItem.rightBarButtonItem = btn;
    
    NSDictionary *dict = [info userInfo];
    downloadInfo = [dict objectForKey:@"voicedownload"];
    
}
-(void)selectedDownload
{
    [[DealData dealDataClass]saveDownloadingVoice:downloadInfo];
    //    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    //    [alert show];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //        [alert dismissWithClickedButtonIndex:0 animated:YES];
    //        [self.navigationItem setRightBarButtonItem:nil];
    //    });
//    [self showMessage:@"添加成功"];
    [Common showMessage:@"添加成功" withView:self.view];
}

//推送到选择录音界面
-(void)pushUploadVoiceView
{
    [self.navigationController popViewControllerAnimated:YES];
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
