//
//  VideoListViewController.m
//  YiQiWeb
//
//  Created by wendy on 15/1/15.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import "VideoListViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoModel.h"
#import "VideoCell.h"
#import "UploadCell.h"
#import "TitleCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DealData.h"
#import "Common.h"

//http://test.17ll.com/upVideo2/upload.asp
//http://test.17ll.com/PHPUpVideo/scsp.php
#define UPLOADURL @"http://test.17ll.com/PHPUpVideo/scsp.php"

@interface VideoListViewController ()

@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;
@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

// 全局指针
lame_t lame;

@implementation VideoListViewController{
    NSMutableArray *dataArray;
    NSIndexPath *sIndexPath;
    NSMutableArray *mutableOperations;
    NSMutableDictionary *uploadDictionary;
    NSInteger keyIndex;
    NSMutableArray *uploadProgreeInfos;//正在上传的数组信息
    NSMutableArray *boolArray;
    NSInteger uploadIndex;
    VideoModel *videoModel;
    ReminderView *indicator;
}

@synthesize downingView,voiceView;

-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem*btn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    btn.tintColor = WHITECOLOR;
    self.navigationItem.rightBarButtonItem = btn;
    [super viewWillAppear:animated];
    
//    if ([self.kind isEqualToString:@"录音"])
//    {
//        segment.selectedSegmentIndex = 1;
//        [self.dataView setHidden:YES];
//        [self.view addSubview:voiceView];
//        self.kind = @"";
//        [_btnDownLoadFinish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_btnDownLoading setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_btnUpload setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        //        voiceView.backgroundColor = [UIColor greenColor];
//        
//        for (UIView*view in voiceView.subviews)
//        {
//            [view removeFromSuperview];
//        }
//        
//        if (uploadVoiceTable==nil)
//        {
//            if (isPad)
//            {
//                uploadVoiceTable = [[UploadVoiceTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-125) style:UITableViewStylePlain];
//            }else
//            {
//                uploadVoiceTable = [[UploadVoiceTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-105) style:UITableViewStylePlain];
//            }
//            
//            uploadVoiceTable.infoUploadingArray = (NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
//            uploadVoiceTable.infoUploadArray = (NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
//            NSLog(@"%@",uploadVoiceTable.infoUploadArray);
//            [voiceView addSubview:uploadVoiceTable];
//        }else
//        {
//            [voiceView addSubview:uploadVoiceTable];
//        }
//        
//        
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"uploadVoiceView" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUploadVoiceView) name:@"uploadVoiceView" object:nil];
//        
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"voicedownload" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicedownload:) name:@"voicedownload" object:nil];
//    }
    
    [self reloadUploadData];
    
    }

-(void) reloadUploadData{
    //要是存在还没有完全上传完毕的，打开页面直接上传
    [self InitUploadInfo];
    if (uploadDictionary.count > 0) {
        [mutableOperations removeAllObjects];
        [uploadProgreeInfos removeAllObjects];
        NSArray *arrs = [uploadDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)Uploading]];
        if (arrs.count>0) {
            for (int i = 0; i <= arrs.count -1; i++) {
                VideoModel *model = [arrs objectAtIndex:i];
                uploadIndex = 1000;
                [self uploadAction:model];
            }
            boolArray[0] = @"1";
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频列表";
    
//    segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"视频",@"音频",nil]];
//    segment.frame = CGRectMake(0, 0, 100, 30);
//    segment.selectedSegmentIndex = 0;
//    segment.tintColor = [UIColor whiteColor];
//    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = segment;
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    backbutton.tintColor = WHITECOLOR;
    self.navigationItem.leftBarButtonItem = backbutton;
    
    //初始化
    dataArray = [[NSMutableArray alloc] init];
    mutableOperations = [[NSMutableArray alloc] init];
    uploadProgreeInfos = [[NSMutableArray alloc] init];
    boolArray = [[NSMutableArray alloc] init];
    
//    uploadIndex = 1000;
    
    [self initIndexView];
    
    //添加长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    whichBtn1 = 1;
    whichBtn2 = 1;
    [self initVoiceView];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealVoice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealVoice:) name:@"dealVoice" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"uploadVoiceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVoiceUpdate) name:@"uploadVoiceSuccess" object:nil];
    
}

-(void)initIndexView{
    UIColor *labelColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    
    CGFloat fontSize,btnHeight,lblTop,lblHeight,lblWidth,btnTop;
    if ([VideoModel iPad]) {
        fontSize = 30.0f;
        btnHeight = 60.0f;
        lblTop = 76.0f;
        lblHeight = 40.0f;
        lblWidth = 2.0f;
        btnTop = 64.0f;
        self.dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, SCREENWIDTH, SCREENHEIGHT - 125)];
    }
    else{
        fontSize = 17.0f;
        btnHeight = 30.0f;
        lblTop = 76.0f;
        lblHeight = 20.0f;
        lblWidth = 1.0f;
        btnTop = 70.0f;
        self.dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREENWIDTH, SCREENHEIGHT - 105)];
    }
    
    _btnDownLoadFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnDownLoadFinish setFrame:CGRectMake(0, btnTop, SCREENWIDTH/2.0-2, btnHeight)];
    [_btnDownLoadFinish setTitle:@"下载" forState:UIControlStateNormal];
    [_btnDownLoadFinish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnDownLoadFinish.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.view addSubview:_btnDownLoadFinish];
    
    UILabel *lblFirst = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0+1, lblTop, lblWidth, lblHeight)];
    [lblFirst setText:@""];
    lblFirst.backgroundColor = labelColor;
    [self.view addSubview:lblFirst];
    
    _btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnUpload setFrame:CGRectMake(SCREENWIDTH-SCREENWIDTH/2.0-2, btnTop, SCREENWIDTH/2.0-2, btnHeight)];
    [_btnUpload setTitle:@"上传" forState:UIControlStateNormal];
    [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnUpload.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.view addSubview:_btnUpload];

//    _btnDownLoadFinish = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnDownLoadFinish setFrame:CGRectMake(0, btnTop, SCREENWIDTH/3.0-2, btnHeight)];
//    [_btnDownLoadFinish setTitle:@"已下载" forState:UIControlStateNormal];
//    [_btnDownLoadFinish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [_btnDownLoadFinish.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
//    [self.view addSubview:_btnDownLoadFinish];
//    
//    UILabel *lblFirst = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/3.0+1, lblTop, lblWidth, lblHeight)];
//    [lblFirst setText:@""];
//    lblFirst.backgroundColor = labelColor;
//    [self.view addSubview:lblFirst];
//    
//    _btnDownLoading = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnDownLoading setFrame:CGRectMake(SCREENWIDTH/3.0+2, btnTop, SCREENWIDTH/3.0-2, btnHeight)];
//    [_btnDownLoading setTitle:@"正在下载" forState:UIControlStateNormal];
//    [_btnDownLoading setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_btnDownLoading.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
//    [self.view addSubview:_btnDownLoading];
    
//    UILabel *lblSecond = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/3.0*2+1, lblTop, lblWidth, lblHeight)];
//    [lblSecond setText:@""];
//    lblSecond.backgroundColor = labelColor;
//    [self.view addSubview:lblSecond];
    
//    _btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnUpload setFrame:CGRectMake(SCREENWIDTH-SCREENWIDTH/3.0-2, btnTop, SCREENWIDTH/3.0-2, btnHeight)];
//    [_btnUpload setTitle:@"上传" forState:UIControlStateNormal];
//    [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_btnUpload.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
//    [self.view addSubview:_btnUpload];
    
//    self.dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, SCREENWIDTH, SCREENHEIGHT - 125)];
    [self.view addSubview:_dataView];
    
    _finishDownView = [[UIView alloc] initWithFrame:self.dataView.bounds];
    [self.dataView addSubview:_finishDownView];
    
    if (self.isTakeVideoView) {
        [self showUploadView];
    }
    else
        [self showCollectionView];
    [_btnDownLoadFinish addTarget:self action:@selector(showCollectionView) forControlEvents:UIControlEventTouchUpInside];
//    [_btnDownLoading addTarget:self action:@selector(showDowningView) forControlEvents:UIControlEventTouchUpInside];
    [_btnUpload addTarget:self action:@selector(showUploadView) forControlEvents:UIControlEventTouchUpInside];
}

//长按按钮删除事件
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [longPress locationInView:self.collectionView];
        sIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        if (nil == sIndexPath) return;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

//录音基界面初始化
-(void)initVoiceView
{
    if (isPad)
    {
        voiceView = [[UIView alloc]initWithFrame:CGRectMake(0, 105+20, SCREENWIDTH, SCREENHEIGHT-105-20)];
    }else
    {
        voiceView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, SCREENWIDTH, SCREENHEIGHT-105)];
    }
    
 
    VoiceDownloadTable*table = [[VoiceDownloadTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-105) style:UITableViewStylePlain];
    table.infoArray = [[DealData dealDataClass]getDownloadVoiceData];
    //    [recordView.view addSubview:table];
    [voiceView addSubview:table];
}

- (void)buttonSayBegin:(id)sender
{
    if (mp3EncodeClient==nil)
    {
        mp3EncodeClient = [[Mp3EncodeClient alloc] init];
    }
    sayBeginBtn.hidden = YES;
    sayEndBtn.hidden = NO;
    [mp3EncodeClient start];
}

- (void)buttonSayEnd:(id)sender
{
    sayBeginBtn.hidden = NO;
    sayEndBtn.hidden = YES;
    [mp3EncodeClient stop];
}

-(void)dealVoice:(NSNotification*)info
{
    NSArray*aResults = [[info userInfo]objectForKey:@"voice"];
    textview.text = aResults.firstObject;
}

-(void)recordAction:(UIButton*)btn
{
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    if ([btn.titleLabel.text isEqualToString:@"录音"])
    {
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setActive:YES error:nil];
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 11025.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,[NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,nil];
        tmpFile = [NSURL fileURLWithPath:
                   [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@",
                     @"wangshuo"]]];
        NSLog(@"%@",tmpFile);
        NSError*error = nil;
        recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:setting error:&error];
        NSLog(@"%@",error);
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
        
        
    }else if ([btn.titleLabel.text isEqualToString:@"暂停"])
    {
        [btn setTitle:@"录音" forState:UIControlStateNormal];
        [audioSession setActive:NO error:nil];
        [recorder pause];
        [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
    }
    
    
}
- (void)audio_PCMtoMP3
{
    
    NSString*str = [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@",
                     @"wangshuo"]];
    NSLog(@"%@",str);
    NSString *mp3FileName = [str lastPathComponent];
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [NSHomeDirectory() stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([str cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
//        NSLog(@"==%s",[[NSHomeDirectory() stringByAppendingPathComponent:[str lastPathComponent]] cStringUsingEncoding:1]);
        if(pcm == NULL)
        {
            NSLog(@"file not found");
        }
        else
        {
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        str = mp3FilePath;
        NSLog(@"MP3生成成功: %@",str);
    }
    
}

-(void) InitCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(0 , 0);
    layout.footerReferenceSize = CGSizeMake(0 , 0);
    layout.minimumLineSpacing = 5.f;
    
    if (self.collectionView == nil) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.finishDownView.bounds collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
    [self.finishDownView addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"VideoCell"];
}

//加载数据
-(void) loadCollectionView{
    [dataArray removeAllObjects];
    dataArray = [VideoModel getAllVideoInfoByID:DownloadFinish];
    //    dataArray = (NSMutableArray*)[[DealData dealDataClass]getVideoData];
}

//已下载界面
-(void) showCollectionView{
//    UIBarButtonItem*btn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    btn.tintColor = WHITECOLOR;
//    self.navigationItem.rightBarButtonItem = btn;
//    if (segment.selectedSegmentIndex ==0)
//    {
        [_btnDownLoadFinish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_btnDownLoading setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
//        [self InitCollectionView];
//        [self loadCollectionView];
        //        [dataArray removeAllObjects];
        //        dataArray = (NSMutableArray*)[[DealData dealDataClass]getVideoData];
        
        if (self.uploadView != nil) {
            [self.uploadView removeFromSuperview];
        }
        if (self.downingView!=nil)
        {
            [self.downingView removeFromSuperview];
        }
        if (self.btnUploadVideo != nil) {
            [self.btnUploadVideo removeFromSuperview];
        }
        self.viewController = [[VideoDownLoadViewController alloc] init];
        self.finishDownView = self.viewController.view;
        [self.viewController.view setBackgroundColor:[UIColor whiteColor]];
        [self.dataView addSubview:self.finishDownView];
//    }else if (segment.selectedSegmentIndex ==1)
//    {
//        [_btnDownLoadFinish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_btnDownLoading setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        //        voiceView.backgroundColor = [UIColor redColor];
//        //        RecordView*recordView = [[RecordView alloc]init];
//        //        [voiceView addSubview:recordView.view];
//        for (UIView*view in voiceView.subviews)
//        {
//            [view removeFromSuperview];
//        }
//        VoiceDownloadTable*voiceDownloadTable;
//        if (isPad)
//        {
//            voiceDownloadTable = [[VoiceDownloadTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-125) style:UITableViewStylePlain];
//        }else
//        {
//            voiceDownloadTable = [[VoiceDownloadTable alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-105) style:UITableViewStylePlain];
//        }
//        
//        //        RecordView*recordView = [[RecordView alloc]init];
//        voiceDownloadTable.infoArray = [[DealData dealDataClass]getDownloadVoiceData];
//        //        [recordView.view addSubview:table];
//        [voiceView addSubview:voiceDownloadTable];
//        //        [voiceView addSubview:nil];
//        //        [voiceView addSubview:nil];
//#warning 录音功能
//    }
}

//正在下载界面
-(void) showDowningView{
    UIBarButtonItem*btn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    btn.tintColor = WHITECOLOR;
    self.navigationItem.rightBarButtonItem = btn;
    if (segment.selectedSegmentIndex ==0)
    {
        DownOrUploadView*video = [[DownOrUploadView alloc]init];
        self.downingView = video.view;
        [_btnDownLoadFinish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnDownLoading setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (self.uploadView != nil) {
            [self.uploadView removeFromSuperview];
        }
        if (self.finishDownView != nil) {
            [self.finishDownView removeFromSuperview];
        }
        [self.dataView addSubview:downingView];
    }else if (segment.selectedSegmentIndex ==1)
    {
        [_btnDownLoadFinish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnDownLoading setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        voiceView.backgroundColor = [UIColor blueColor];
        for (UIView*view in voiceView.subviews)
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
        //        [recordView.view addSubview:table];
        [voiceView addSubview:voiceDownloadingTable];
    }
}

- (void)showDownLoadView:(UIButton *) sender{
    [_btnDownLoadFinish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btnUpload setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (self.uploadView != nil) {
        [self.uploadView removeFromSuperview];
    }
    if (self.btnUploadVideo != nil) {
        [self.btnUploadVideo removeFromSuperview];
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)UploadFinish];
    NSArray *arrs = [uploadDictionary objectForKey:key];
    NSString *videoId = @"0";
    if (sender.tag >= 4000) {
        NSInteger index = sender.tag - 4000;
        VideoModel *item = arrs[index];
        item.v_State = Downloading;
        item.downLoadId = [item.v_Id integerValue];
        NSString *_id = item.v_Id;
        videoId = [VideoModel addVideoModel:item];
        item.v_Id = _id;
        item.downLoadId = [videoId integerValue];
        [VideoModel updateDownLoad:item];
        [self InitUploadInfo];
        [self.tableView reloadData];
    }
   
    VideoDownLoadViewController *viewController = [[VideoDownLoadViewController alloc] init];
    self.finishDownView = viewController.view;
    [self.dataView addSubview:self.finishDownView];
}

//上传界面
-(void) showUploadView{
    self.btnUploadVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([VideoModel iPad]) {
        [self.btnUploadVideo setFrame:CGRectMake(5, 3, 220, 80)];
        [self.btnUploadVideo setImage:[UIImage redraw:[UIImage imageNamed:@"add"] Frame:CGRectMake(0, 0, 50, 50)] forState:UIControlStateNormal];
        [self.btnUploadVideo.titleLabel setFont:[UIFont systemFontOfSize:30.0f]];
        self.uploadView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT-180)];
    }
    else{
        [self.btnUploadVideo setFrame:CGRectMake(5, 3, 110, 30)];
        [self.btnUploadVideo setImage:[UIImage redraw:[UIImage imageNamed:@"add"] Frame:CGRectMake(0, 0, 25, 25)] forState:UIControlStateNormal];
        [self.btnUploadVideo.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        self.uploadView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT-140)];
    }
    
    [self.btnUploadVideo setTitle:@"上传视频" forState:UIControlStateNormal];
    [self.btnUploadVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btnUploadVideo addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.dataView addSubview:self.btnUploadVideo];
    [self.dataView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
    [self.btnUploadVideo setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.btnUploadVideo setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.uploadView.bounds style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    [self.uploadView addSubview:self.tableView];
    
    [_btnDownLoadFinish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_btnDownLoading setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnUpload setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (self.finishDownView != nil) {
        [self.finishDownView removeFromSuperview];
    }
    if (self.downingView != nil) {
        [self.downingView removeFromSuperview];
    }
    [self.dataView addSubview:self.uploadView];
    [self InitUploadInfo];
    [self.tableView reloadData];
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
    [Common showMessage:@"添加成功" withView:self.view];
}
//更新音频界面
-(void)uploadVoiceUpdate
{
    uploadVoiceTable.infoUploadingArray = (NSMutableArray*)[[DealData dealDataClass]getUploadVoiceData];
    uploadVoiceTable.infoUploadArray = (NSMutableArray*)[[DealData dealDataClass]getUploadedVoiceData];
    NSLog(@"%@",uploadVoiceTable.infoUploadingArray);
    [uploadVoiceTable reloadData];
}
//推送到录音上传界面
-(void)pushUploadVoiceView
{
    UploadView*uploadVoiceView = [[UploadView alloc]init];
    [self.navigationController pushViewController:uploadVoiceView animated:YES];
}

#pragma mark -- collectionViewDateSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell * cell = (VideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    VideoModel  *model = [dataArray objectAtIndex:indexPath.row];
    [cell initData:model];
    [cell.btnPlay addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    //    cell.btnPlay.tag = [model.v_Id integerValue];
    cell.btnPlay.tag = indexPath.row;
    //    cell.tag = [model.v_Id integerValue];
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([VideoModel iPad])
        return CGSizeMake(SCREENWIDTH/3-15, SCREENWIDTH/3+30);
    else
        return CGSizeMake(98, 130);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([VideoModel iPad])
       return UIEdgeInsetsMake(10, 10, 10, 10);
    else
       return UIEdgeInsetsMake(2, 2, 2, 2);

}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell * cell = (VideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self prepareToPlay:(int)cell.tag];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark---UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 1000) {
            NSInteger section = sIndexPath.section;
            NSInteger row = sIndexPath.row - 1;
            NSString *key = uploadDictionary.allKeys[section];
            NSMutableArray *arrItems = [uploadDictionary objectForKey:key];
            VideoModel *item = [arrItems objectAtIndex:row];
            if ([VideoModel deleteVideoModel:item.v_Id]) {
                if ([key isEqualToString:[NSString stringWithFormat:@"%ld",(long)Uploading]]) {
                    [uploadProgreeInfos removeObjectAtIndex:row];
                    AFHTTPRequestOperation *operation = [mutableOperations objectAtIndex:row];
                    [operation pause];
                    [mutableOperations removeObject:operation];
                    //                    [mutableOperations removeObjectAtIndex:row];
                }
                [arrItems removeObjectAtIndex:row];
                
                [self.tableView deleteRowsAtIndexPaths:@[sIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self InitUploadInfo];
                [self.tableView reloadData];
            }
        }
        else if (alertView.tag == 1001){
            if ([[alertView textFieldAtIndex:0] text].length > 0) {
                videoModel.v_Name = [[alertView textFieldAtIndex:0] text];
            }
            else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                videoModel.v_Name = [formatter stringFromDate:[NSDate date]];
            }
            if (![VideoModel isExistsUploadVideoName:videoModel.v_Name]) {
                videoModel.downLoadId = 0;//未下载
                //添加数据
                NSString *Id = [VideoModel addVideoModel:videoModel];
                uploadIndex = 1000;
                boolArray[0] = @"1";
                videoModel.v_Id = Id;
                [self uploadAction:videoModel];
                [self InitUploadInfo];
                [self.tableView reloadData];
            }
            else{
                [Common showMessage:@"该视频名已存在，请重新输入" withView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存视频文件名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alert.tag = 1001;
                    [alert show];
                });
            }

        }
        else{
            VideoModel *item = [dataArray objectAtIndex:sIndexPath.row];
            if ([VideoModel deleteVideoModel:item.v_Id]) {
                [dataArray removeObjectAtIndex:sIndexPath.row];
                [self.collectionView deleteItemsAtIndexPaths:@[sIndexPath]];
            }
        }
    }
}

#pragma mark -- 视频播放

-(void) playVideo:(UIButton *) sender{
    [self prepareToPlay:(int)sender.tag];
}

-(void)playLocalVideo:(UIButton *) sender{
    NSString *key = uploadDictionary.allKeys[keyIndex];
    NSArray *arrs = [uploadDictionary objectForKey:key];
    NSInteger index = sender.tag - 3000;
    VideoModel *model = arrs[index];
    [self startToPlay:[NSURL URLWithString:model.v_Url] PlayTime:model.v_PlayTime ID:model.v_Id];
}

//播放上传后的视频
-(void)playUploadVideo:(UIButton *) sender{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)UploadFinish];
    NSArray *arrs = [uploadDictionary objectForKey:key];
    NSInteger index = sender.tag - 3000;
    VideoModel *model = arrs[index];
    [self startToPlay:[NSURL URLWithString:model.v_Url] PlayTime:model.v_PlayTime ID:model.v_Id];
}

-(void) prepareToPlay : (int) index{
    VideoModel *model = [dataArray objectAtIndex:index];
    
    //        NSString *path = [CACHEPATH stringByAppendingPathComponent:model.v_Url.lastPathComponent];
    if ([self fileIsExists:model.v_Url]) {
        [self startToPlay:[NSURL fileURLWithPath:model.v_Url] PlayTime:model.v_PlayTime ID:model.v_Id];
    }
    else{
        [Common showMessage:@"要播放的视频不存在" withView:self.view];
    }
}

//播放视频
-(void) startToPlay : (NSURL *) path PlayTime : (float) playTime ID : (NSString *) videoId {
    self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
    [[DealData dealDataClass]videoNotification:self withPlayer:self.playerViewController];
    [self.playerViewController.moviePlayer setInitialPlaybackTime:playTime];
    [[NSUserDefaults standardUserDefaults] setValue:videoId forKey:@"videoid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self presentMoviePlayerViewControllerAnimated:self.playerViewController];
    
}

//判断本地视频是否存在
-(BOOL) fileIsExists : (NSString *) path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return TRUE;
    }
    return FALSE;
}

//返回按钮事件
-(void) goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uploadVideo{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark --上传视频操作
-(void) uploadAction:(VideoModel *) model{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *videoName = [self getUploadVideoName];
    NSLog(@"url=%@",model.v_Url);
    
    NSDictionary *parameters = @{@"yzm": [self getVerificationCode]};
//    NSDictionary *parameters = @{@"strYZM": [self getVerificationCode]};
    
    AFHTTPRequestOperation *operation = [manager POST:UPLOADURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.v_Url]];
        //fp strVideo audio/mp3 video/mpeg4
        [formData appendPartWithFileData:videoData name:@"fp" fileName:[NSString stringWithFormat:@"%@.mp3",videoName] mimeType:@"video/mpeg4"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"back = %@",operation.responseString);
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",responseObject);
        //删除沙盒里的压缩视频
        [Common deleteFile:model.v_Url];
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *result = [dict objectForKey:@"fz"];
        if ([result isEqual: @"0"]) {
            model.v_Url = [dict objectForKey:@"furl"];
            NSLog(@"上传成功%@",model.v_Url);
            
            model.v_OperationTime = [self getCurrentDate:@"yyyy-MM-dd HH:mm:ss"];
            model.v_State = UploadFinish;
            [VideoModel updateInfoWhenUploadFinish:model];
            
            [mutableOperations removeObject:operation];
            [uploadProgreeInfos removeObject:model];
            
            //更新列表
            dispatch_async(dispatch_get_main_queue(), ^{
                [self InitUploadInfo];
                [self.tableView reloadData];
//                [self reloadUploadData];
            });
        }
        else{
            [self uploadFail:model];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            [self deleteFile:documentsDirectory];
        NSLog(@"operation error = %@",operation.responseString);
        NSLog(@"error = %@",error);
        [self uploadFail:model];
    }];
   
    if (uploadIndex == 1000) {
        [uploadProgreeInfos addObject:model];
        [mutableOperations addObject:operation];
    }
    else{
        [uploadProgreeInfos insertObject:model atIndex:uploadIndex];
        [mutableOperations insertObject:operation atIndex:uploadIndex];
        uploadIndex = 1000;
    }

    //    NSLog(@"mutableOperations=%ld",(unsigned long)mutableOperations.count);
    
    __block float eachProgress = 0;
    __block NSInteger index = [mutableOperations indexOfObject:operation];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float eachBytes = bytesWritten / 1024.0 / 1024.0;
        float totalSize = totalBytesExpectedToWrite / 1024.0 / 1024.0;
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

//生成验证码
-(NSString *)getVerificationCode{
    
    int k = arc4random() % 10;
    
    int x = 2 + arc4random() % 8;
    
    int y = 18/x;
    
    int z = 18 - x*y;
    
    return [NSString stringWithFormat:@"%d%d%d%d",x,k,y,z];
}

//上传失败操作
-(void)uploadFail:(VideoModel *) model{
    [Common showMessage:@"上传失败，请重新上传" withView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [VideoModel updateInfoWhenUploadFail:model];
        [self InitUploadInfo];
        [self.tableView reloadData];
    });
    model.errorIndex = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark -- UITableView
-(void) InitUploadInfo{
    [uploadDictionary removeAllObjects];
    uploadDictionary = [VideoModel getAllUploadVideoInfo:Uploading And:UploadFinish];
    NSArray *keys = uploadDictionary.allKeys;
    for (int i = 0; i < keys.count; i++) {
        [boolArray addObject:@"0"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return uploadDictionary.allKeys.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([boolArray[section] isEqual: @"1"]) {
        NSString *key = [uploadDictionary.allKeys objectAtIndex:section];
        NSArray *arrs = [uploadDictionary objectForKey:key];
        return arrs.count + 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        return [VideoModel iPad] ? 240 : 120;
    }
    return [VideoModel iPad] ? 60:44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    
    NSString *key = [uploadDictionary.allKeys objectAtIndex:section];
    NSArray *arrs = [uploadDictionary objectForKey:key];
    if (boolArray.count > 0 && [boolArray[section] isEqual: @"1"] && arrs.count > row) {
        
        VideoModel *model;
        if (uploadProgreeInfos.count > 0 && [key isEqualToString:[NSString stringWithFormat:@"%ld",(long)Uploading]])
            model = [uploadProgreeInfos objectAtIndex:row];
        
        if ([key isEqualToString:[NSString stringWithFormat:@"%ld",(long)UploadFinish]])
            model = [arrs objectAtIndex:row];
        
        static NSString *CellIdentifier = @"UploadCell";
        
        UploadCell *cell = (UploadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
            cell = [[UploadCell alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell initData:model];
        
        cell.btnUpload.tag = row + 3000;
        if (model.v_State == Uploading) {
            if (cell.btnUpload != nil && model.errorIndex == 1)
                [cell.btnUpload addTarget:self action:@selector(reUpload:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [cell.btnUpload addTarget:self action:@selector(playUploadVideo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDown addTarget:self action:@selector(showDownLoadView:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnDown.tag = 4000 + row;
        }
  
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"TitleCell";
        TitleCell *cell = (TitleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[TitleCell alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,[VideoModel iPad] ? 60 : 44)];
        }
        if (uploadDictionary.count > 0) {
            NSString *title;
            if ([[[uploadDictionary allKeys] objectAtIndex:section] isEqualToString:[NSString stringWithFormat:@"%ld",(long)Uploading]]) {
                title = @"  正在上传视频";
            }
            else if ([[[uploadDictionary allKeys] objectAtIndex:section] isEqualToString:[NSString stringWithFormat:@"%ld",(long)UploadFinish]]) {
                title =  @"  已上传视频";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (uploadDictionary.allKeys.count > 0) {
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
                NSString *key = [uploadDictionary.allKeys objectAtIndex:section];
                NSArray *arrs = [uploadDictionary objectForKey:key];
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
    NSString *key = [uploadDictionary.allKeys objectAtIndex:section];
    NSUInteger contentCount = [[uploadDictionary objectForKey:key] count];
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

-(void) pauseOrUploading : (UIButton *)sender {
    NSInteger tag = sender.tag - 3000;
    AFHTTPRequestOperation *operation = [mutableOperations objectAtIndex:tag];
    NSString *imgName,*buttonTitle;
    if ([operation isPaused]) {
        [operation start];
        buttonTitle = @"上传中";
        imgName = @"pause";
    }
    else{
        [operation pause];
        buttonTitle = @"继续上传";
        imgName = @"continue";
    }
    [sender.titleLabel setFont:[UIFont systemFontOfSize:[VideoModel iPad] ? 26.0f : 13.0f]];
    [sender setImage:[UIImage redraw:[UIImage imageNamed:imgName] Frame:[VideoModel iPad]?CGRectMake(0, 0, 20, 23):CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
    [sender setTitle:buttonTitle forState:UIControlStateNormal];
}

//重新上传
-(void) reUpload : (UIButton *)sender {
    NSInteger tag = sender.tag - 3000;
    uploadIndex = tag;
    VideoModel *item = [uploadProgreeInfos objectAtIndex:tag];
    [mutableOperations removeObjectAtIndex:tag];
    [uploadProgreeInfos removeObjectAtIndex:tag];
    [sender removeFromSuperview];
    [self uploadAction:item];
    item.errorIndex = 0;
    [self.tableView reloadData];
}

//时间戳+随机数生成上传视频名称
-(NSString *)getUploadVideoName {
    NSString *currentDate = [self getCurrentDate:@"yyyyMMddHHmmss"];
    NSString *randomStr = [[NSMutableString alloc] init] ;
    for (int i = 0; i < 4; i++) {
        long random = arc4random()%100000;
        randomStr = [randomStr stringByAppendingString:[NSString stringWithFormat:@"%ld",random]];
    }
    NSString *videoName = [NSString stringWithFormat:@"%@%@",currentDate,randomStr];
    return videoName;
}

//获取当前时间
-(NSString *)getCurrentDate : (NSString *) dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}

#pragma mark-- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
            
            VideoModel *model = [[VideoModel alloc] init];
            
            NSURL *pathUrl = [info valueForKey:UIImagePickerControllerMediaURL];
            //            NSLog(@"nsurl = %@",pathUrl);
            
            // 上传文件时，是文件不允许被覆盖，文件重名
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *videoName = [NSString stringWithFormat:@"%@.mp4",str];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Compress"];
            if (![fileManager fileExistsAtPath:documentsDirectory]) {
                [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:videoName];
            NSURL *tempUrl = [NSURL fileURLWithPath:documentsDirectory];
            NSLog(@"tempUrl=%@",tempUrl);
            
            indicator = [ReminderView reminderView];
            [self.view addSubview:indicator];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //压缩视频
                [self lowQuailtyWithInputURL:pathUrl outputURL:tempUrl blockHandler:^(AVAssetExportSession *session){
                    if(session.status == AVAssetExportSessionStatusCompleted){
                        NSLog(@"success!");
                        model.v_timeScale = [Common getVideoLength:tempUrl];
                        model.v_Url = [NSString stringWithFormat:@"%@",tempUrl];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [indicator removeFromSuperview];
                            if (model.v_Url.length > 0) {
                                UIImage *image = [Common getImage:pathUrl];
                                model.v_imageData = UIImageJPEGRepresentation(image, 1);
                                model.sumMemory = [self getVideoFileSize:tempUrl.path];
                                
                                [Common deleteFile:pathUrl.path];
                                
//                                model.v_Name = self.txtTitle.text;
                                model.v_State = Uploading;
                                
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                // 设置时间格式
                                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                model.v_OperationTime = [formatter stringFromDate:[NSDate date]];
                                
                                model.v_PlayTime = 0.00f;
                                model.downloadMemory = 0.00f;
                                
                                videoModel = model;
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存视频文件名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                                alert.tag = 1001;
                                [alert show];
                            }
                            else{
                                [Common deleteFile:pathUrl.path];
                                [self showFailMessage];
                            }
                        });
                    }else if (session.status == AVAssetExportSessionStatusFailed){
                        NSLog(@"error = %@",session.error);
                        [Common deleteFile:pathUrl.path];
                        [self showFailMessage];
                    }
                    else
                    {
                        NSLog(@"压缩视频失败！");
                        [self showFailMessage];
                    }
                }];
            });
        }
    }];
}

//压缩视频
- (void)lowQuailtyWithInputURL:(NSURL*)inputURL
                     outputURL:(NSURL*)outputURL
                  blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    //输出格式
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = TRUE;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}

//获取视频文件的大小
-(CGFloat) getVideoFileSize : (NSString *) path{
    NSError *error;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    unsigned long long length = [fileAttributes fileSize];
    float fileSize = length / 1024.0 / 1024.0;
    return fileSize;
}

-(void) showFailMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Common showMessage:@"出现错误，请重新选择" withView:self.view];
        [indicator removeFromSuperview];
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
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
