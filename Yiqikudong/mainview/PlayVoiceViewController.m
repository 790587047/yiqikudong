//
//  PlayVoiceViewController.m
//  Yiqikudong
//http://www.open-open.com/lib/view/open1429578290276.html
//  Created by wendy on 15/3/11.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "PlayVoiceViewController.h"
#import "UIImage+Redraw.h"
#import "UILabel+StringFrame.h"
#import "RecordingView.h"
#import "AppDelegate.h"
#import "VoiceHistoryModel.h"
#import "VoiceCollectModel.h"
#import "CommentListViewController.h"
#import "UserModel.h"

@interface PlayVoiceViewController ()

@end

@implementation PlayVoiceViewController{
    AppDelegate *appDelegate;
    BOOL isTheEnd;
    int currentTime;
    NSURL *voiceUrl;
    NSString *userId;//默认为登录者的id
    UserModel *user;
}

+(PlayVoiceViewController*)playVoiceView{
    static PlayVoiceViewController*playVoiceView = nil;
    if (playVoiceView==nil)
    {
        playVoiceView = [[PlayVoiceViewController alloc]init];
    }
    return playVoiceView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    user = [[UserModel alloc] init];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    isTheEnd = false;
    currentTime = 0;
    
    //读取最后一次播放的内容

    if (_model == nil) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"VoiceModel"] != nil) {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"VoiceModel"];
            _model = (VoiceObject *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"playCurrentTime"] != nil) {
                currentTime = [[NSUserDefaults standardUserDefaults] floatForKey:@"playCurrentTime"];
            }
            [self getVoiceUrl];
        }
    }
    else{
        [self getVoiceUrl];
        NSString *lastVoiceUrl;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LastVoiceUrl"] != nil) {
            lastVoiceUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastVoiceUrl"];
        }
        if (lastVoiceUrl.length>0) {
            if ([_model.voiceUrl.lastPathComponent isEqualToString:lastVoiceUrl]) {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"playCurrentTime"] != nil) {
                    currentTime = [[NSUserDefaults standardUserDefaults] floatForKey:@"playCurrentTime"];
                }
            }else{
                currentTime = 0;
                if (self.player.rate == 1) {
                    [self.player pause];
                }
                [self.player replaceCurrentItemWithPlayerItem:[self getPlayItem:voiceUrl]];
            }
        }
        if (self.player.rate == 1) {
            [self removeNotification];
            [self.player replaceCurrentItemWithPlayerItem:[self getPlayItem:voiceUrl]];
        }
    }
    [self loadUserInfo];
    [self initView];
    if (_model.voiceType == 2) {
        [self setupUI];
        _imgShowRecord.hidden = YES;
    }
    else
        _imgShowRecord.hidden = NO;

    //    _mp3Arrays = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"mp3/"];
    
    [self saveLastInfo];
    [self addNotification];
    
    if (!self.isHome) {
        if (self.player.rate == 0) {
            [self playVoice];
        }else{
            [_btnPlay setImage:[UIImage imageNamed:@"voicePause"] forState:UIControlStateNormal];
            [_btnPlay setSelected:NO];
            [self addSliderObserver];
        }
    }
    else{
        if (currentTime > 0) {
            CMTime curTime = CMTimeMakeWithSeconds(currentTime, 1);
            [self.player seekToTime:curTime];
        }
    }
}

-(void)initView{
    UIImageView *bgImageView = (UIImageView *)[self.view viewWithTag:100];
    if (bgImageView==nil)
    {
        bgImageView= [[UIImageView alloc] initWithFrame:self.view.bounds];
        NSString *imageName;
        if (CGRectGetWidth(self.view.frame) == 320 && CGRectGetHeight(self.view.frame) == 480) {
            imageName = @"playVoicebgImage@2x";
        }else
            imageName = @"playVoicebgImage-568h@2x";
        bgImageView.tag = 100;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]]];
        [self.view addSubview:bgImageView];
    }
    
    /** 上面导航**/
    if (btnBack==nil){
        btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setFrame:CGRectMake(20, 35, 30, 20)];
        [btnBack setImage:[UIImage imageNamed:@"playBack"] forState:UIControlStateNormal];
//        [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:btnBack];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(btnBack.frame.origin.x-5, btnBack.frame.origin.y-3, 50, 35)];
    [backView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [backView addGestureRecognizer:recognizer];
    
    if (_lblTitle==nil) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 150, 30)];
        [_lblTitle setTextColor:[UIColor whiteColor]];
        [_lblTitle setText:_model.voiceName];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setFont:[UIFont boldSystemFontOfSize:20.0f]];
        _lblTitle.center = CGPointMake(self.view.center.x, _lblTitle.center.y);
        [self.view addSubview:_lblTitle];
    }
    else{
        [_lblTitle setText:_model.voiceName];
    }
    
    if (btnRecord==nil){
        btnRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRecord setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [btnRecord setFrame:CGRectMake(SCREENWIDTH - 60, 35, 45, 27)];
        [btnRecord addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRecord];
    }
    
    //显示图片
    if (_imgShowRecord==nil){
        _imgShowRecord = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_lblTitle.frame) + 15, SCREENWIDTH * 0.6, (SCREENHEIGHT / 2 - CGRectGetMaxY(_lblTitle.frame))*0.65)];
    }
    if([_model.picPath hasSuffix:@"png"]||[_model.picPath hasSuffix:@"jpg"]||[_model.picPath hasSuffix:@"jpeg"]||[_model.picPath hasSuffix:@"gif"]){
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.picPath]];
        [_imgShowRecord setImage:[UIImage imageWithData:imageData]];
    }
    else if(_model.voicePic != nil){
        [_imgShowRecord setImage:[UIImage imageWithData:_model.voicePic]];
    }
    else{
        _imgShowRecord.image = [UIImage imageNamed:@"voiceDefault"];
    }
    _imgShowRecord.center = CGPointMake(self.view.center.x, _imgShowRecord.center.y);
    [self.view addSubview:_imgShowRecord];
    
    /**中间播放控件**/
    if (_playView==nil){
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80*(SCREENWIDTH/320))];
        [_playView setBackgroundColor:[UIColor colorWithRed:133.0/255.0 green:138.0/255.0 blue:164.0/255 alpha:1.0]];
        _playView.alpha = .3f;
        _playView.center = self.view.center;
        [self.view addSubview:_playView];
        
        //播放暂停按钮
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPlay setFrame:CGRectMake(0, 0, 50, 50)];
        _btnPlay.center = self.view.center;
        [_btnPlay setImage:[UIImage imageNamed:@"voicePlay2"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(voicePlay:) forControlEvents:UIControlEventTouchUpInside];
        [_btnPlay setSelected:YES];
        [self.view addSubview:_btnPlay];
        
        //循环按钮
        _btnCircle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCircle setFrame:CGRectMake(40, 30, 25, 20)];
        [_btnCircle setImage:[UIImage imageNamed:@"voiceCircle"] forState:UIControlStateNormal];
        _btnCircle.center = CGPointMake(SCREENWIDTH/6-10, _btnPlay.center.y);
        [_btnCircle setBackgroundColor:[UIColor clearColor]];
        [_btnCircle addTarget:self action:@selector(circlePlay:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCircle setSelected:NO];
        [self.view addSubview:_btnCircle];
        
        //前一首按钮
        UIButton *btnPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPrevious setFrame:CGRectMake(0, 30, 40, 40)];
        [btnPrevious setImage:[UIImage imageNamed:@"voiceBefore"] forState:UIControlStateNormal];
        btnPrevious.center = CGPointMake(SCREENWIDTH/5+SCREENWIDTH/10, _btnPlay.center.y);
        [btnPrevious addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnPrevious];
        
        //后一首按钮
        UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNext setFrame:CGRectMake(SCREENWIDTH-btnPrevious.frame.origin.x - btnPrevious.frame.size.width,btnPrevious.frame.origin.y, 40, 40)];
        [btnNext setImage:[UIImage imageNamed:@"voiceAfter"] forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNext];
        
        //收藏按钮
        UIButton *btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLike setFrame:CGRectMake(SCREENWIDTH - _btnCircle.frame.origin.x - _btnCircle.frame.size.width, _btnCircle.frame.origin.y, 20, 20)];
        if ([VoiceCollectModel isExistsCollectUrl:_model.voiceUrl]) {
            [btnLike setImage:[UIImage imageNamed:@"voiceLike2"] forState:UIControlStateNormal];
            [btnLike setSelected:NO];
        }
        else{
            [btnLike setImage:[UIImage imageNamed:@"voiceLike"] forState:UIControlStateNormal];
            [btnLike setSelected:YES];
        }
        [btnLike addTarget:self action:@selector(voiceAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLike];
    }

    if (_curLabel==nil){
        _curLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_playView.frame) - 25, 40, 20)];
        [_curLabel setTextColor:[UIColor whiteColor]];
        [_curLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [_curLabel setText:currentTime > 0 ? [self timeToString:(int)currentTime] : @"00:00"];
        [self.view addSubview:_curLabel];
    }

    if (_duLabel==nil){
        _duLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - CGRectGetWidth(_curLabel.frame) - 10, _curLabel.frame.origin.y, 40, 20)];
        [_duLabel setTextColor:[UIColor whiteColor]];
        [_duLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [self.view addSubview:_duLabel];
    }
    [_duLabel setText:_model.voiceSumTime.length > 0 ? _model.voiceSumTime : @"00:00"];

    if (_slider==nil){
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playView.frame), SCREENWIDTH, 3)];
        _slider.minimumTrackTintColor = [UIColor orangeColor];
        _slider.maximumTrackTintColor = WHITECOLOR;
        [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        _slider.continuous = NO;
        _slider.minimumValue = 0;
    }
    NSArray *arrTime = [_model.voiceSumTime componentsSeparatedByString:@":"];
    if (arrTime.count == 2) {
        NSInteger seconds = [arrTime[0] integerValue]*60+[arrTime[1] integerValue];
        _slider.maximumValue = seconds;
        _slider.value = currentTime;
    }
    else
        _slider.value = 0 ;
    [self.view addSubview:_slider];

    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_slider.frame)+5, SCREENWIDTH, SCREENHEIGHT - 50 - CGRectGetMaxY(_slider.frame))];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollview];
    
    CGFloat h = 0;
    //头像
    //    _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, _progressView.frame.origin.y + 30, 70, 70)];
    _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 70, 70)];
    [_imgHead setImage:[UIImage imageNamed:@"touxiang"]];
    [scrollview addSubview:_imgHead];
    
    h = CGRectGetHeight(_imgHead.frame)+20;
    
    _lblName = [[UILabel alloc] initWithFrame:CGRectMake(_imgHead.frame.origin.x + _imgHead.frame.size.width + 10, _imgHead.frame.origin.y + _imgHead.frame.size.height/4, 100, 25)];
    [_lblName setText:@"蜗牛"];
    [_lblName setTextColor:[UIColor whiteColor]];
    [_lblName setFont:[UIFont boldSystemFontOfSize:19.0f]];
    [_lblName setTextAlignment:NSTextAlignmentLeft];
    [scrollview addSubview:_lblName];
    
    _lblDate = [[UILabel alloc] initWithFrame:CGRectMake(_lblName.frame.origin.x, _lblName.frame.origin.y + _lblName.frame.size.height, 100, 25)];
    [_lblDate setText:@"2015-01-01"];
    [_lblDate setTextAlignment:NSTextAlignmentLeft];
    [_lblDate setTextColor:[UIColor colorWithRed:76.0/255.0 green:75.0/255.0 blue:76.0/255.0 alpha:1.0]];
    [_lblDate setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [scrollview addSubview:_lblDate];
    
    //关注按钮
    _btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnAttention setFrame:CGRectMake(SCREENWIDTH - 100, _lblName.frame.origin.y, 80, 35)];
    [_btnAttention setImage:[UIImage imageNamed:@"voiceFollow"] forState:UIControlStateNormal];
    [_btnAttention setSelected:YES];
    [_btnAttention addTarget:self action:@selector(voiceFollow:) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:_btnAttention];
    
    //关注按钮要是自己的就不显示
    if (_model.userId != userId) {
        _btnAttention.hidden = YES;
    }
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_imgHead.frame.origin.x + _imgHead.frame.size.width / 2, _imgHead.frame.origin.y + _imgHead.frame.size.height + 15, 10, 10)];
    arrowImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrow" ofType:@"png"]];
    [scrollview addSubview:arrowImg];
    
    h = h + CGRectGetHeight(arrowImg.frame);
    
    _lblInfo = [UILabel new];
    [_lblInfo setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:61.0/255.0 blue:68.0/255.0 alpha:1.0]];
    [_lblInfo setTextColor:[UIColor whiteColor]];
    [_lblInfo.layer setCornerRadius:5.0f];
    [_lblInfo.layer setMasksToBounds:YES];
    [scrollview addSubview:_lblInfo];
    [_lblInfo setText:@"生活就像海洋,只有意志坚强的人,才能到达彼岸.生活就像海洋,只有意志坚强的人,才能到达彼岸."];
    _lblInfo.font = [UIFont fontWithName:nil size:15.0f];
    CGSize size = [_lblInfo boundingRectWithSize:CGSizeMake(SCREENWIDTH*0.9, 0)];
    _lblInfo.numberOfLines = 0;
    [self resetContent:_lblInfo];
    [_lblInfo setFrame:CGRectMake(_imgHead.frame.origin.x, arrowImg.frame.origin.y + arrowImg.frame.size.height, size.width, size.height+20)];
    _lblInfo.center = CGPointMake(self.view.center.x, _lblInfo.center.y);
    
    h = h + CGRectGetHeight(_lblInfo.frame);
    
    [scrollview setContentSize:CGSizeMake(SCREENWIDTH, h + 50)];
    
    //评论按钮
    UIButton *btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnComment setFrame:CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH/3-2, 50)];
    [self setButton:btnComment imageName:@"comment" buttonTitle:@"评论"];
    [btnComment addTarget:self action:@selector(goToCommentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    //喜欢按钮
    UIButton *btnEnjoy = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEnjoy setFrame:CGRectMake(btnComment.frame.size.width + 1, SCREENHEIGHT - 50, SCREENWIDTH/3-2, 50)];
    [self setButton:btnEnjoy imageName:@"enjoy" buttonTitle:@"喜欢"];
    
    //讨厌按钮
    UIButton *btnHate = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHate setFrame:CGRectMake(btnComment.frame.size.width * 2 + 2, SCREENHEIGHT - 50, SCREENWIDTH/3-2, 50)];
    [self setButton:btnHate imageName:@"hate" buttonTitle:@"讨厌"];
}

//设置label
- (void)resetContent:(UILabel *) label{
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString : label.text];
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    paragraphStyle.headIndent = 10;//左缩进
    paragraphStyle.firstLineHeadIndent = 10;//首行缩进
    paragraphStyle.tailIndent = -5; //右缩进
    
    [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange (0 , [label.text length ])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

//设置button
-(void) setButton:(UIButton *)sender imageName:(NSString *) name buttonTitle:(NSString *) title{
    [sender setTitle:title forState:UIControlStateNormal];
    [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [sender setImage:[UIImage redraw:[UIImage imageNamed:name] Frame:CGRectMake(0, 0, 23, 23)] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor blackColor]];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:sender];
}

-(void) getVoiceUrl{
    if (_model.downloadFlag) {
        //已下载的播放本地
        voiceUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",WEBPATH,_model.voiceUrl.lastPathComponent]];
    }
    else{
        voiceUrl = [NSURL URLWithString:_model.voiceUrl];
    }
}

//记录上一次播放的音频信息
-(void) saveLastInfo{
    if (_model != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_model] forKey:@"VoiceModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//返回按钮
-(void) goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//录制按钮
-(void)recordAction{
    RecordingView *recordView = [[RecordingView alloc]init];
    [self presentViewController:recordView animated:YES completion:nil];
}

//循环播放按钮
-(void)circlePlay:(UIButton *) sender{
    if (!sender.selected) {
        [sender setImage:[UIImage imageNamed:@"voiceCircle2"] forState:UIControlStateNormal];
        [sender setSelected:YES];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"voiceCircle"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
}

//播放按钮事件
-(void) voicePlay:(UIButton *) sender{
    
    if (_model.voiceUrl == nil) {
        [Common showMessage:@"没有要播放的音频" withView:self.view];
        return;
    }
    if (self.player.rate == 0){
        [self playVoice];
    }
    //正在播放
    else  if (self.player.rate == 1) {
        [sender setImage:[UIImage imageNamed:@"voicePlay2"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [self.player pause];
    }
}

//保存播放历史到数据库
-(void) saveVoiceInfo{

    VoiceHistoryModel *item = [[VoiceHistoryModel alloc] init];
    item.voiceAuthor        = _model.voiceAuthor;
    item.voiceClassId       = _model.voiceClassId;
    item.voiceName          = _model.voiceName;
    item.voicePic           = _model.voicePic;
    item.voiceSumTime       = _model.voiceSumTime;
    item.voiceType          = _model.voiceType;
    item.total              = _model.total;
    item.voiceUrl           = _model.voiceUrl;
    item.picPath            = _model.picPath;
    item.playSumCount       = _model.playSumCount;
    item.createTime         = [Common getCurrentDate:@"yyyy-MM-dd"];
    item.userId             = _model.userId;
    [VoiceHistoryModel insertHistory:item];
}

/**
 *  初始化播放器
 *
 *  @return 播放器对象
 */
-(AVPlayer *)player{
    if (!appDelegate.audioPlayer) {
        AVPlayerItem *playerItem = [self getPlayItem:voiceUrl];
        appDelegate.audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//        [self addSliderObserver];
    }
    return appDelegate.audioPlayer;
}

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param url 视频rul
 *
 *  @return AVPlayerItem对象
 */
-(AVPlayerItem *)getPlayItem:(NSURL *)url{
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

/**
 *  创建播放器层
 */
-(void) setupUI{
    UIView *playView = [[UIView alloc] initWithFrame:_imgShowRecord.frame];
    [self.view addSubview:playView];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playLayer.videoGravity = AVLayerVideoGravityResize;
    playLayer.frame = CGRectMake(0, 0, playView.frame.size.width, playView.frame.size.height);
    [playView.layer addSublayer:playLayer];
}

//音频播放
-(void) playVoice{
    
    [_btnPlay setImage:[UIImage imageNamed:@"voicePause"] forState:UIControlStateNormal];
    [_btnPlay setSelected:NO];
    
    [self saveVoiceInfo];
    
    self.player.volume = 1.0f;
    if (isTheEnd) {
        [self.player seekToTime:kCMTimeZero];
    }
    else{
        if (currentTime > 0) {
            CMTime curTime = CMTimeMakeWithSeconds(currentTime, 1);
            [self.player seekToTime:curTime];
        }
    }
    [self.player play];
    [self addSliderObserver];
}

//上一首
-(void) previous : (UIButton *) sender{
    if (_mp3Arrays.count > 0) {
        if (appDelegate.currentIndex == 0){
            [Common showMessage:@"已经是第一首" withView:self.view];
            return;
        }
        
        if (appDelegate.currentIndex > 0){
            appDelegate.currentIndex--;
            _slider.value = 0;
        }else
            appDelegate.currentIndex = 0;
        [self playVoice];
    }
    else{
        [Common showMessage:@"没有音频，请先下载再播放" withView:self.view];
    }
}

//下一首
-(void) next:(UIButton *) sender{
    if (_mp3Arrays.count > 0) {
        if (appDelegate.currentIndex == _mp3Arrays.count - 1){
           [Common showMessage:@"已经是最后一首" withView:self.view];
            return;
        }
        
        if (appDelegate.currentIndex < _mp3Arrays.count - 1){
            appDelegate.currentIndex ++;
            _slider.value = 0;
        }else
            appDelegate.currentIndex = 0;
        
        [self playVoice];
    }
    else{
        [Common showMessage:@"没有音频，请先下载再播放" withView:self.view];
    }
}

-(NSString *) timeToString : (int) time{
    return [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
}

//slider改变值后改变播放进度
- (void)sliderValueChange:(id)sender {

    UISlider *currSlider = (UISlider *) sender;
    _curLabel.text = [self timeToString:currSlider.value];
    
    [self.player pause];
    CMTime newTime = CMTimeMakeWithSeconds(_slider.value, 1);
    [self.player seekToTime:newTime];
    [self.player play];
    [self addSliderObserver];
    
    [_btnPlay setImage:[UIImage imageNamed:@"voicePause"] forState:UIControlStateNormal];
    [_btnPlay setSelected:NO];
}

//收藏按钮事件
-(void) voiceAttention : (UIButton *) sender{
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"voiceLike2"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [self collectAction];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"voiceLike"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [self unCollectAction];
    }
}

//关注按钮事件
-(void) voiceFollow:(UIButton *) sender{
    if (sender.selected) {//关注
//        [sender setImage:[UIImage imageNamed:@"voiceFollow2"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
        NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
        [self followOrNo:postPath];
    }
    else{//取消关注
//        [sender setImage:[UIImage imageNamed:@"voiceFollow"] forState:UIControlStateNormal];
//        [sender setSelected:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消关注吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

/**
 *  关注操作
 */
-(void) followOrNo:(NSString *)postPath{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%@",_model.userId],@"myUserId":user.userId};
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"message = %@",operation.responseString);
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
            if ([result isEqual: @"1"]) {
                _isFollow = [[dictionary objectForKey:@"isFollow"] boolValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //判断是否被关注
                    if (_isFollow) {
                        [_btnAttention setImage:[UIImage imageNamed:@"voiceFollow2"] forState:UIControlStateNormal];
                        [_btnAttention setSelected:NO];
                        [Common showMessage:@"关注成功" withView:self.view];
                    }
                    else{
                        [_btnAttention setImage:[UIImage imageNamed:@"voiceFollow"] forState:UIControlStateNormal];
                        [_btnAttention setSelected:YES];
                        [Common showMessage:@"取消关注成功" withView:self.view];
                    }
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail = %@",error);
            NSLog(@"failure = %@",operation);
            [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
        }];
    });

}

//请求用户信息
-(void) loadUserInfo{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%@",_model.userId]};
    
    NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"message = %@",operation.responseString);
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
            if ([result isEqual: @"1"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //用户信息
                    user.userName = [dictionary objectForKey:@"userName"];
                    user.userImagePic = [dictionary objectForKey:@"userImaage"];
                    user.userDescription = [dictionary objectForKey:@"description"];
                    //http://www.cocoachina.com/bbs/read.php?tid-299327.html
                    _isFollow = [[dictionary objectForKey:@"isFollow"] boolValue];
                    //判断是否被关注
                    if (_isFollow) {
                        [_btnAttention setImage:[UIImage imageNamed:@"voiceFollow2"] forState:UIControlStateNormal];
                        [_btnAttention setSelected:NO];
                    }
                    else{
                        [_btnAttention setImage:[UIImage imageNamed:@"voiceFollow"] forState:UIControlStateNormal];
                        [_btnAttention setSelected:YES];
                    }
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail = %@",error);
            NSLog(@"failure = %@",operation);
            [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
        }];
    });
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    _curLabel.text = _duLabel.text;
    _slider.value = _slider.maximumValue;
    [self removeNotification];
    if (!_btnCircle.selected) {
        [self.player pause];
        [_btnPlay setImage:[UIImage imageNamed:@"voicePlay2"] forState:UIControlStateNormal];
        [_btnPlay setSelected:YES];
        isTheEnd = true;
    }
    else{
        [self.player pause];
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
    [self addNotification];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopAnimation" object:nil];
}

#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addSliderObserver{
    AVPlayerItem *playerItem = self.player.currentItem;
    UISlider *curSlider = self.slider;
    UILabel *lblCurrent = self.curLabel;
    UILabel *lblDuration = self.duLabel;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(playerItem.duration);
//        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
            curSlider.value = current;
            lblCurrent.text = [NSString stringWithFormat:@"%02d:%02d", (int)current / 60, (int)current % 60];
            if (!isnan(total)) {
                curSlider.maximumValue = total;
                lblDuration.text = [NSString stringWithFormat:@"%02d:%02d", (int)total / 60, (int)total % 60];
            }
        }
    }];
}

-(void)dealloc{
    [self removeNotification];
}

#pragma mark -- 收藏
/**
 *  收藏按钮操作事件
 *
 */
-(void) collectAction{
    VoiceObject *obj = _model;
    VoiceCollectModel *model = [[VoiceCollectModel alloc] init];
    model.voiceUrl           = obj.voiceUrl;
    model.voiceType          = obj.voiceType;
    model.voiceSumTime       = obj.voiceSumTime;
    model.voicePic           = obj.voicePic;
    model.voiceName          = obj.voiceName;
    model.voiceClassId       = obj.voiceClassId;
    model.picPath            = obj.picPath;
    model.voiceAuthor        = obj.voiceAuthor;
    model.playSumCount       = obj.playSumCount;
    model.total              = obj.total;
    model.createTime         = [Common getCurrentDate:@"yyyy-MM-dd"];
    [VoiceCollectModel addVoiceCollectInfo:model];
    [Common showMessage:@"收藏成功" withView:self.view];
}

//取消收藏
-(void) unCollectAction{
    [VoiceCollectModel deleteVoiceCollect:_model.voiceUrl];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:voiceUrl.lastPathComponent forKey:@"LastVoiceUrl"];
//    if (self.player.rate == 1) {
        [[NSUserDefaults standardUserDefaults] setFloat:CMTimeGetSeconds(self.player.currentItem.currentTime) forKey:@"playCurrentTime"];
//    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.player.rate==1)
    {
        if (_model != nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"startAnimation" object:nil userInfo:[NSDictionary dictionaryWithObject:_model forKey:@"image"]];
        }
    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stopAnimation" object:nil];
    }
}

/**
 *  跳到评论页面
 */
-(void) goToCommentViewController{
    CommentListViewController *viewController = [[CommentListViewController alloc] init];
    viewController.voiceId = _model.voiceId;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:^{
    }];
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
        [self followOrNo:postPath];
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
