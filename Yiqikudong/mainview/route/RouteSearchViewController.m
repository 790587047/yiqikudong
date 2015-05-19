//
//  RouteSearchViewController.m
//  CAVmap
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "RouteSearchViewController.h"
#import "UIView+CustomActivity.h"
#import "UIImage+Redraw.h"
#import "KeyWordSearchModel.h"
@interface RouteSearchViewController ()
{
    UIView *activity;
}
@end

@implementation RouteSearchViewController

@synthesize selectPointText;
@synthesize textfield,tableview,recognizerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    self.view.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                   nil];
    [self initTextField];  // 初始化textfieldd
//    [self initView];  // 初始化视图
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealVoice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealVoice:) name:@"dealVoice" object:nil];
    
}

- (void)initView
{
    UIView *view = [[UIView alloc]initWithFrame:kFrame(10, 70, SCREENWIDTH-20, 40)];
    [UIView setLayerWithView:view];
    [self.view addSubview:view];
    
    // 分割线
    UIImageView *separa = [[UIImageView alloc]initWithFrame:kFrame((SCREENWIDTH-20)/2, 10, 1, 20)];
    separa.image = [UIImage imageNamed:@"Aboutpage_SeparatorLine_Vertical@2x"];
    [view addSubview:separa];
    
    NSArray *imageArr = @[[UIImage imageNamed:@"route_selptfrom_map"],[UIImage imageNamed:@"route_selptfrom_fav"]];
    NSArray *titleArr = @[@"地图选点",@"选点收藏"];
    
    for (int i = 0; i < imageArr.count; i++)
    {
        UIButton *btn = [UIButton packageButtonWithImage:imageArr[i]
                                                   Title:titleArr[i]
                                                   Frame:kFrame(0,0 , (SCREENWIDTH-20)/2, 30)];
        btn.frame = kFrame((SCREENWIDTH-20)/2*i-10, 5, (SCREENWIDTH-20)/2, 30);
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(pointOrCollection:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    
}

- (void)pointOrCollection:(UIButton *)sender
{
    if (sender.tag == 101)
    {
        MapSelectPointViewController *map = [[MapSelectPointViewController alloc]init];
        
        // 获取坐标
        [map realizeBlock:^(CLLocationCoordinate2D *coordinate) {
            NSLog(@"%f   %f",coordinate->longitude,coordinate->latitude);
            activity = [UIView creatCustomActivity];
            [self.view addSubview:activity];
            [[KeyWordSearchModel keyWordModel]geoCodeWithCoordinate:*coordinate andBlock:^(id result) {
 
                [activity removeFromSuperview];
                block(result);
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }];
        map.title = @"点击地图选点";
        [map addConfirmBtn];
        [self.navigationController pushViewController:map animated:YES];
    }
    else
    {
        
    }
}

#pragma mark - 初始化textfieldd

// nav搜索栏
- (void)initTextField
{
    textfield = [[BaseTextField alloc] initWithFrame:kFrame(50, 25, SCREENWIDTH-100, 30)];
    textfield.placeholder = selectPointText;
    textfield.font = [UIFont systemFontOfSize:14];
    [textfield becomeFirstResponder];
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.delegate = self;
    textfield.returnKeyType = UIReturnKeySearch;
    UIView *sV = [[UIView alloc]initWithFrame:kFrame(10, 0, 30, 30)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:kFrame(10,5, 18, 18)];
    imageV.image = [UIImage imageNamed:@"common_icon_searchbox_magnifier_2"];
    [sV addSubview:imageV];
    textfield.leftView = sV;
    textfield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.98];
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.view addSubview:textfield];
    [textfield addKeyboardBtn];
    
    UIButton *searchBtn = [UIButton blueSystemButtonWithButtonType:UIButtonTypeCustom title:nil frame:kFrame(SCREENWIDTH-40, 27.5, 30, 25)];
    [searchBtn setImage:[UIImage imageNamed:@"message_voice_background"] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
}

- (void)realizeBlock:(addressBlock)sender
{
    block = sender;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
    });
    [textfield.keyBoardBtn setImage:[UIImage imageNamed:@"keyboard_btn_hide7@2x"] forState:UIControlStateNormal];
    return YES;
}
-(void)timerAction
{
    if (![textfield.text isEqualToString:@""]&&![textBefore isEqualToString:textfield.text])
    {
//        [timer invalidate];
//        NSLog(@"==%@",textfield.text);
        dispatch_async(dispatch_get_main_queue(), ^{
            textBefore = textfield.text;
            [self searchRoute];
        });
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![timer isValid])
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [timer fire];
            [[NSRunLoop currentRunLoop]run];
        });
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textfield resignFirstResponder];
    [self searchRoute];
    return YES;
}
-(void)search
{
//    // 创建识别控件
//    if (tmpRecognizerViewController==nil)
//    {
//        tmpRecognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128) withTheme:[BDVRSConfig sharedInstance].theme];
//    }
//    // 全屏UI
//    if ([[BDVRSConfig sharedInstance].theme.name isEqualToString:@"全屏亮蓝"]) {
//        tmpRecognizerViewController.enableFullScreenMode = YES;
//    }
//    
//    tmpRecognizerViewController.delegate = self;
//    self.recognizerViewController = tmpRecognizerViewController;
//    
//    // 设置识别参数
//    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
//    
//    // 开发者信息，必须修改API_KEY和SECRET_KEY为在百度开发者平台申请得到的值，否则示例不能工作
//    paramsObject.apiKey = API_KEY;
//    paramsObject.secretKey = SECRET_KEY;
//    
//    // 设置是否需要语义理解，只在搜索模式有效
//    paramsObject.isNeedNLU = [BDVRSConfig sharedInstance].isNeedNLU;
//    
//    // 设置识别语言
//    paramsObject.language = EVoiceRecognitionLanguageChinese;
//    
//    // 设置识别模式，分为搜索和输入
//    paramsObject.recogPropList = @[[NSNumber numberWithInt:EVoiceRecognitionPropertyMap],[NSNumber numberWithInt:EVoiceRecognitionPropertySearch]];
//    
//    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
//    paramsObject.cityID = 1;
//    
//    // 开启联系人识别
//    paramsObject.enableContacts = YES;
//    
//    // 设置显示效果，是否开启连续上屏
//    if ([BDVRSConfig sharedInstance].resultContinuousShow)
//    {
//        paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
//    }
//    else
//    {
//        paramsObject.resultShowMode = BDRecognizerResultShowModeWholeShow;
//    }
//    
//    // 设置提示音开关，是否打开，默认打开
//    if ([BDVRSConfig sharedInstance].uiHintMusicSwitch)
//    {
//        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
//    }
//    else
//    {
//        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordForbidden;
//    }
//    //    paramsObject.isShowTipsOnStart = NO;
//    paramsObject.isShowTipAfter3sSilence = NO;
//    paramsObject.isShowHelpButtonWhenSilence = NO;
////    paramsObject.tipsTitle = @"可以使用如下指令记账";
////    paramsObject.tipsList = [NSArray arrayWithObjects:@"我要记账", @"买苹果花了十块钱", @"买牛奶五块钱", @"第四行滚动后可见", @"第五行是最后一行", nil];
////    
////    BDVoiceRecognitionClient
////    
////    
////    AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
////    //    AVAudioSessionCategoryPlayAndRecord
////    AVAudioSession*audio = [AVAudioSession sharedInstance];
////    NSError*error = nil;
////    BOOL success = [audio setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
////    NSLog(@"==%@",error);
////    if (!success||![device hasTorch])
////    {
////        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"打开录音器失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////        [alert show];
////    }else
////    {
//
//    [recognizerViewController startWithParams:paramsObject];
////    }
//

    [textfield resignFirstResponder];
    
    // 设置开发者信息
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    // 设置语音识别模式，默认是输入模式
    [[BDVoiceRecognitionClient sharedInstance] setPropertyList:@[[BDVRSConfig sharedInstance].recognitionProperty]];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    [[BDVoiceRecognitionClient sharedInstance] setCityID: 1];
    
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:[BDVRSConfig sharedInstance].isNeedNLU];
    
    // 开启联系人识别
    //    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"enable_contacts" withFlag:YES];
    
    // 设置识别语言
    [[BDVoiceRecognitionClient sharedInstance] setLanguage:[BDVRSConfig sharedInstance].recognitionLanguage];
    
    // 是否打开语音音量监听功能，可选
    if ([BDVRSConfig sharedInstance].voiceLevelMeter)
    {
        BOOL res = [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
        if (res == NO)  // 如果监听失败，则恢复开关值
        {
            [BDVRSConfig sharedInstance].voiceLevelMeter = YES;
        }
    }
    else
    {
        [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
    }
    
    // 设置播放开始说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:[BDVRSConfig sharedInstance].playStartMusicSwitch];
    // 设置播放结束说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:[BDVRSConfig sharedInstance].playEndMusicSwitch];
    
    // 创建语音识别界面，在其viewdidload方法中启动语音识别
//    BDVRCustomRecognitonViewController *tmpAudioViewController = [[BDVRCustomRecognitonViewController alloc] initWithNibName:nil bundle:nil];
    self.audioViewController = [[BDVRCustomRecognitonViewController alloc] initWithNibName:nil bundle:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:_audioViewController.view];
}

-(void)searchRoute
{
    [[KeyWordSearchModel keyWordModel]placeWithKeyWord:textfield.text andBlock:^(id result) {
        BMKSuggestionResult*result1 = (BMKSuggestionResult*)result;
        placeArray = [[NSArray alloc]initWithArray:result1.keyList];
        cityArray = [[NSArray alloc]initWithArray:result1.cityList];
        streetArray = [[NSArray alloc]initWithArray:result1.districtList];
        if (tableview==nil)
        {
            tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, SCREENWIDTH, SCREENHEIGHT-70) style:UITableViewStylePlain];
            tableview.delegate = self;
            tableview.dataSource = self;
            tableview.rowHeight = 60;
            [self.view addSubview:tableview];
            [self.view sendSubviewToBack:tableview];
        }else
        {
            [tableview reloadData];
        }
    }];
}

-(void)dealVoice:(NSNotification*)info
{
    NSArray*aResults = [[info userInfo]objectForKey:@"voice"];
//    NSLog(@"%@",aResults.firstObject);
//    for (id str in aResults)
//    {
//        NSLog(@"-=-=%@",str);
//    }
    if ([aResults.firstObject hasPrefix:@"去"]||[aResults.firstObject hasPrefix:@"到"])
    {
        NSMutableString*str = [NSMutableString stringWithString:aResults.firstObject];
        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
//        NSLog(@"成功了没==%@",str);
        textfield.text = str;
        //        UITableViewCell*cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        flag = 1;
    }else
    {
        textfield.text = aResults.firstObject;
        flag = 0;
    }
}
//#pragma mark - BDRecognizerViewDelegate语音识别控件代理
//-(void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults
//{
//    NSLog(@"%@",aResults.firstObject);
//    for (id str in aResults)
//    {
//        NSLog(@"-=-=%@",str);
//    }
//    if ([aResults.firstObject hasPrefix:@"去"]||[aResults.firstObject hasPrefix:@"到"])
//    {
//        NSMutableString*str = [NSMutableString stringWithString:aResults.firstObject];
//        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
//        NSLog(@"成功了没==%@",str);
//        textfield.text = str;
////        UITableViewCell*cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        flag = 1;
//    }else
//    {
//        textfield.text = aResults.firstObject;
//        flag = 0;
//    }
//}
//-(void)onError:(int)errorCode
//{
//    NSLog(@"%d",errorCode);
//}
//-(void)onComplete:(BDVRDataUploader *)dataUploader error:(NSError *)error
//{
//    NSLog(@"%@==%@",dataUploader,error);
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markCell";
    RouteSearchCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[RouteSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
    }
    cell.title.text = placeArray[indexPath.row];
    cell.subTitle.text = [NSString stringWithFormat:@"%@%@",cityArray[indexPath.row],streetArray[indexPath.row]];
    [cell.searchBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.searchBtn.tag = 1000+indexPath.row;
    if (indexPath.row==0)
    {
        if (flag)
        {
            [self tableView:tableview didSelectRowAtIndexPath:indexPath];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return placeArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[KeyWordSearchModel keyWordModel]geoCodeWithCity:cityArray[indexPath.row] address:placeArray[indexPath.row] andBlock:^(id result) {
//        BMKGeoCodeResult*result1 = (BMKGeoCodeResult*)result;
//        NSLog(@"%f%f",result1.location.latitude,result1.location.longitude);
        block(result);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)btnAction:(UIButton*)btn
{
    NSLog(@"%@",placeArray[btn.tag-1000]);
    textfield.text = placeArray[btn.tag-1000];
    [textfield resignFirstResponder];
    [self searchRoute];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [textfield resignFirstResponder];
    if ([timer isValid])
    {
        [timer invalidate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
