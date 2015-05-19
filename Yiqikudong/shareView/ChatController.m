//
//  ChatController.m
//  Yiqikudong
//
//  Created by BK on 15/3/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ChatController.h"
#import "AppDelegate.h"
#import "lame.h"
#import "Statics.h"

#define padding 20
@interface ChatController ()

@end

// 全局指针
lame_t lame;

@implementation ChatController
@synthesize tView,messageTextView,chatWithUser,msgArray,sendUserID,receiverUserID,maxID,chatID,chatUserImage,ID;
- (void)viewDidLoad {
    [super viewDidLoad];
     faceArray = [[NSArray alloc]initWithObjects:@"[微笑]",@"[撇嘴]",@"[色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[睡]",@"[大哭]",
                  @"[尴尬]",@"[发怒]",@"[调皮]",@"[龇牙]",@"[惊讶]",@"[难过]",@"[酷]",@"[冷汗]",@"[抓狂]",@"[吐]",@"[偷笑]",@"[可爱]",@"[白眼]",@"[傲慢]",
                  @"[饥饿]",@"[困]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[大兵]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘...]",@"[晕]",@"[折磨]",@"[衰]",@"[骷髅]",
                  @"[敲打]",@"[再见]",@"[擦汗]",@"[抠鼻]",@"[鼓掌]",@"[糗大了]",@"[坏笑]",@"[左哼哼]",@"[右哼哼]",@"[哈欠]",@"[鄙视]",@"[委屈]",@"[快哭了]",
                  @"[阴险]",@"[亲亲]",@"[吓]",@"[可怜]",@"[菜刀]",@"[西瓜]",@"[啤酒]",@"[篮球]",@"[乒乓]",@"[咖啡]",@"[饭]",@"[猪头]",@"[玫瑰]",@"[凋谢]",
                  @"[示爱]",@"[爱心]",@"[心碎]",@"[蛋糕]",@"[闪电]",@"[炸弹]",@"[刀]",@"[足球]",@"[瓢虫]",@"[便便]",@"[月亮]",@"[太阳]",@"[礼物]",
                  @"[强]",@"[弱]",@"[握手]",@"[胜利]",@"[抱拳]",@"[勾引]",@"[拳头]",@"[差劲]",@"[爱你]",@"[NO]",@"[OK]",@"[爱情]",@"[飞吻]",@"[淘气]",@"[惊呆]",@"[咆哮]",@"[转圈]",nil];
     
     
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    flagRecord = NO;
    finishRecord = NO;
    cancalRecord = NO;
     messages = [NSMutableArray array];
     messegePage = 1;
    // Do any additional setup after loading the view.
    tView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40)];
    tView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UISwipeGestureRecognizer*swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    swipe.delegate = self;
    [tView addGestureRecognizer:swipe];
    UISwipeGestureRecognizer*swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe)];
    swipe1.direction = UISwipeGestureRecognizerDirectionDown;
    swipe1.delegate = self;
    [tView addGestureRecognizer:swipe1];
//    tView.backgroundColor = [UIColor whiteColor];
     [tView addHeaderWithTarget:self action:@selector(headerLoadMore)];
     tView.scrollsToTop = YES;
    [self.view addSubview:tView];
    
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40)];
    baseView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//     baseView.alpha = 0;
     baseView.layer.borderWidth = 1;
    baseView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1].CGColor;
    [self.view addSubview:baseView];
    
    messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, 4, SCREENWIDTH-120, 32)];
    messageTextView.layer.cornerRadius = 3;
    messageTextView.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
    messageTextView.layer.borderWidth = 1;
    messageTextView.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:messageTextView];
    messageTextView.delegate = self;
     messageTextView.scrollsToTop = NO;
//    messageTextView.borderStyle = UITextBorderStyleLine;
//     if (SCREENWIDTH>320)
//     {
//          [messageTextView becomeFirstResponder];
//     }
    
    
    voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(4, 6, 28, 28);
    voiceBtn.backgroundColor = [UIColor clearColor];
    [voiceBtn setImage:[UIImage imageNamed:@"Fav_Search_Voice"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(voiceSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:voiceBtn];
    
    faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.frame = CGRectMake(messageTextView.frame.origin.x+messageTextView.frame.size.width+4, 6, 28, 28);
    [faceBtn setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:faceBtn];
    
    self.title = chatWithUser;
    
    
    AppDelegate *del = [self appDelegate];
    del.messageDelegate = self;
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(SCREENWIDTH-40, 5, 35, 30);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sendBtn.layer.backgroundColor = [UIColor colorWithRed:75/255.0 green:195/255.0 blue:43/255.0 alpha:1].CGColor;
    sendBtn.layer.cornerRadius = 3;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:sendBtn];
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(SCREENWIDTH-40, 6, 28, 28);
    [moreBtn setImage:[UIImage imageNamed:@"ql_talk_pic10"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn addTarget:self action:@selector(moreButton) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:moreBtn];
    [moreBtn setHidden:YES];
    
    UIBarButtonItem *btnback = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    btnback.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnback;
    
     if (imagePicker == nil) {
          imagePicker = [[UIImagePickerController alloc] init];
     }
//    10152357
    
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //创建url连接
//            //    NSURL*url = [[NSURL alloc]initWithString:@"http://www.xinquanxinyuan.com/test/gold_seed/app/newslist.php"];
//            NSURL*url = [[NSURL alloc]initWithString:@"http://192.168.0.136:82/apply/chat/APP_PrivateChat_CheckNew.asp"];
//            //创建可变链接请求
//            NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
//            //设置http请求方式
//            [request setHTTPMethod:@"POST"];
//            //设置http请求body
//            //    NSString*bodyStr = [NSString stringWithFormat:@"page=1&per=%d&type=1&subid=0",10];
//            //    UIImage*image = [UIImage imageNamed:@"添加图片.jpg"];
//            //    NSData*data2 = UIImageJPEGRepresentation(image, 1);
//            //    NSData*data1 = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"喜欢你" ofType:@"mp3"]]];
//            NSString*bodyStr = [NSString stringWithFormat:@"SendID=1&ReceiverId=10&ChatMaxId=10152357"];
//            [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
//            //response响应信息
//            NSHTTPURLResponse*response = nil;
//            //错误信息
//            NSError*error = nil;
//            //开始post同步请求
//            NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
//            NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"strResult = %@",strResult);
//            NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
//            if ([[[strResult objectFromJSONString] objectForKey:@"code"] isEqualToString:@"ok"])
//            {
//                NSURL*url = [[NSURL alloc]initWithString:@"http://192.168.0.136:82/apply/chat/APP_PrivateChat_GetMessage.asp"];
//                //创建可变链接请求
//                NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
//                //设置http请求方式
//                [request setHTTPMethod:@"POST"];
//                //设置http请求body
//                //    NSString*bodyStr = [NSString stringWithFormat:@"page=1&per=%d&type=1&subid=0",10];
//                //    UIImage*image = [UIImage imageNamed:@"添加图片.jpg"];
//                //    NSData*data2 = UIImageJPEGRepresentation(image, 1);
//                //    NSData*data1 = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"喜欢你" ofType:@"mp3"]]];
//                NSString*bodyStr = [NSString stringWithFormat:@"SendID=1&ReceiverId=10&ChatMaxId=10152357"];
//                [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
//                //response响应信息
//                NSHTTPURLResponse*response = nil;
//                //错误信息
//                NSError*error = nil;
//                //开始post同步请求
//                NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//                NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
//                NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"strResult = %@",strResult);
//                NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
//            }
//        });
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        if ([ChatDealClass getNewMessegesID:@"10152357" sendID:@"1" eceiverID:@"10"])
//        {
//            NSLog(@"%@",[ChatDealClass getNewMessegesID:@"10152357" sendID:@"1" eceiverID:@"10"]);
//        }else
//        {
//            NSLog(@"0");
//        }
//    });
}
//头部下拉加载
-(void)headerLoadMore
{
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
          messegePage++;
          //          [ceremonyImage removeAllObjects];
          //          [self data:page];
          //          NSLog(@"1%@",messages);
          NSInteger oldCnt = [messages count];
          messages = [[ChatDealClass dealDataClass]getMsgData:chatID withPage:messegePage];
          //          NSLog(@"2%@",messages);
          NSInteger newCnt  = [messages count];
          [tView reloadData];
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newCnt - oldCnt inSection:0];
          [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
          // 结束加载更多记录状态
          [tView headerEndRefreshing];
     });
}
//加载更多的聊天记录
-(void)loadMore
{
//     [tView headerBeginRefreshing];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
          messegePage++;
//          [ceremonyImage removeAllObjects];
//          [self data:page];
//          NSLog(@"1%@",messages);
          NSInteger oldCnt = [messages count];
          messages = [[ChatDealClass dealDataClass]getMsgData:chatID withPage:messegePage];
//          NSLog(@"2%@",messages);
          NSInteger newCnt  = [messages count];
          
          [tView reloadData];
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newCnt - oldCnt inSection:0];
          [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
          loadMoreFlag = 0;
//          [tView headerEndRefreshing];
     });
}
//表情按钮
-(void)faceAction:(UIButton*)btn
{
    [messageTextView setHidden:NO];
    [moreView setHidden:YES];
    [voiceRecordBtn setHidden:YES];
    flag2 = 0;
    if (flag1)
    {
        flag1 = 0;
        [btn setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
        [messageTextView becomeFirstResponder];
    }else
    {
         [messageTextView resignFirstResponder];
        kbSize = CGSizeMake(SCREENWIDTH, 150);
        [btn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        flag1 = 1;
        cursorPosition = [messageTextView selectedRange];
        
        if (flag==0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                baseView.frame = CGRectMake(0, SCREENHEIGHT-190, SCREENHEIGHT, 40);
                tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-150-40);
                if (messages.count>0)
                {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
                    [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            });
        }else
        {
            baseView.frame = CGRectMake(0, SCREENHEIGHT-190, SCREENHEIGHT, 40);
            tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-150-40);
            if (messages.count>0)
            {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
                [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        if (flag)
        {
            flag = 0;
            [voiceBtn setImage:[UIImage imageNamed:@"Fav_Search_Voice"] forState:UIControlStateNormal];
        }
        if (faceView==nil)
        {
            
//            ,@"[磕头]",@"[乐乐]",@"[跳绳]",@"[886]",@"[high]",@"[得意]",@"[献吻]",@"[左太极]",@"[右太极]"
//            NSLog(@"%lu",faceArray.count);
            faceView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH, 150)];
            [self.view addSubview:faceView];
            
            faceScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
            faceScroll.contentSize = CGSizeMake(SCREENWIDTH*4, 150);
            faceScroll.delegate = self;
            faceScroll.pagingEnabled = YES;
             faceScroll.scrollsToTop = NO;
            faceScroll.panGestureRecognizer.delaysTouchesBegan = YES;
            faceScroll.backgroundColor = baseView.backgroundColor;
            faceScroll.showsHorizontalScrollIndicator = NO;
            [faceView addSubview:faceScroll];
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-20, 132, 40, 18)];
            pageControl.numberOfPages = 4;
            pageControl.currentPage = 0;
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            [faceView addSubview:pageControl];
            for (int i = 0; i<4; i++)
            {
                for (int j = 0; j<23; j++)
                {
                    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(((SCREENWIDTH-320)/7+40)*(j%8)+i*SCREENWIDTH+5, j/8*40+10, 30, 30);
                    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"e%d",23*i+j+1]] forState:UIControlStateNormal];
                    btn.tag = 1000+i*23+j;
                    [btn addTarget:self action:@selector(face:) forControlEvents:UIControlEventTouchUpInside];
                    [faceScroll addSubview:btn];
                }
                UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(((SCREENWIDTH-320)/7+40)*7+i*SCREENWIDTH, 2*40+5, 40, 40*79/71);
                [btn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7@2x"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(deleteFace) forControlEvents:UIControlEventTouchUpInside];
                [faceScroll addSubview:btn];
            }
        }else
        {
            [faceView setHidden:NO];
        }
    }
}
-(void)face:(UIButton*)btn
{
    if (![messageTextView.text isEqualToString:@""])
    {
        NSInteger index = cursorPosition.location;
        NSMutableString *content = [[NSMutableString alloc] initWithString:messageTextView.text];
        [content insertString:faceArray[btn.tag-1000] atIndex:index];
        messageTextView.text = content;
    }else
    {
        messageTextView.text = [NSString stringWithFormat:@"%@%@",messageTextView.text,faceArray[btn.tag-1000]];
    }

    NSString*str = faceArray[btn.tag-1000];
    cursorPosition = NSMakeRange(cursorPosition.location+str.length, cursorPosition.length+str.length);
    [sendBtn setHidden:NO];
    [moreBtn setHidden:YES];
}
-(void)deleteFace
{
    NSInteger index = cursorPosition.location;
    NSString* s = [messageTextView.text substringWithRange:NSMakeRange(0,index)];
    NSString* t = [messageTextView.text substringWithRange:NSMakeRange(index, messageTextView.text.length-index)];
//    NSLog(@"%@===%@",[messageTextView.text substringWithRange:NSMakeRange(0,index)],t);
    if([s length]<=0)
        return;
    int n=-1;
    if( [s characterAtIndex:[s length]-1] == ']'){
        for(int i=(int)[s length]-1;i>=0;i--){
            if( [s characterAtIndex:i] == '[' ){
                n = i;
                break;
            }
        }
    }
    NSString* u;
    if(n>=0)
        u = [s substringWithRange:NSMakeRange(0,n)];
    else
        u = [s substringToIndex:[s length]-1];
    
    messageTextView.text = [NSString stringWithFormat:@"%@%@",u,t];
    messageTextView.selectedRange = NSMakeRange(u.length,0);
     cursorPosition = NSMakeRange(n, n);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@""])
    {
        cursorPosition = [messageTextView selectedRange];
        [self deleteFace];
        if ([messageTextView.text isEqualToString:@""])
        {
            [sendBtn setHidden:YES];
            [moreBtn setHidden:NO];
        }else
        {
            [sendBtn setHidden:NO];
            [moreBtn setHidden:YES];
        }
        return NO;
    }
    return YES;
}
#pragma mark scroll代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x/SCREENWIDTH;
}
#pragma mark 录音按钮
-(void)voiceSelectAction:(UIButton*)btn
{
    kbSize = CGSizeMake(SCREENWIDTH, 0);
    flag2 = 0;
    [moreView setHidden:YES];
    [faceView setHidden:YES];
    if (flag)
    {
        flag = 0;
        [btn setImage:[UIImage imageNamed:@"Fav_Search_Voice"] forState:UIControlStateNormal];
        [messageTextView setHidden:NO];
        [messageTextView becomeFirstResponder];
        
    }else
    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
        baseView.frame = CGRectMake(0, SCREENHEIGHT-40, SCREENHEIGHT, 40);
        tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40);
        if (messages.count>0)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
            [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
//        [UIView commitAnimations];
        
        [btn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        flag = 1;
        [messageTextView resignFirstResponder];
        if (flag1)
        {
            flag1 = 0;
            [faceBtn setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
        }
        if (voiceRecordBtn==nil)
        {
            voiceRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            voiceRecordBtn.frame = messageTextView.frame;
            voiceBtn.backgroundColor = [UIColor whiteColor];
            [voiceRecordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
            [voiceRecordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            voiceRecordBtn.layer.cornerRadius = 3;
            voiceRecordBtn.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
            voiceRecordBtn.layer.borderWidth = 1;
            [voiceRecordBtn addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
            [voiceRecordBtn addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
            [voiceRecordBtn addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
            [voiceRecordBtn addTarget:self action:@selector(recordCancelReminder) forControlEvents:UIControlEventTouchDragOutside];
            [voiceRecordBtn addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDragInside];
//            UILongPressGestureRecognizer*press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(record)];
//            [voiceRecordBtn addGestureRecognizer:press];
            [baseView addSubview:voiceRecordBtn];
        }else
        {
            voiceRecordBtn.frame = messageTextView.frame;
            [voiceRecordBtn setHidden:NO];
        }
        if (![messageTextView.text isEqualToString:@""])
        {
            [messageTextView setHidden:YES];
        }
        [voiceRecordBtn bringSubviewToFront:baseView];
        [messageTextView sendSubviewToBack:baseView];
        voiceBtn.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark 开始录制声音
-(void)recordStart
{
    [voiceRecordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    voiceRecordBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:[ReminderView reminderViewTitle:@"手指上滑，取消发送" withLevel:@"1" withFlag:YES]];
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    if (!flagRecord)
    {
        NSError*error1 = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
        NSLog(@"error1 = %@",error1);
        [audioSession setActive:YES error:nil];
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 11025.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,[NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,nil];
        if (!cancalRecord)
        {
            filname = [self updateLabel];
            cancalRecord = YES;
        }
        
        tmpvoiceFile = [NSURL fileURLWithPath:
                   [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%@",
                     filname]]];

        NSError*error = nil;
        recorder = [[AVAudioRecorder alloc] initWithURL:tmpvoiceFile settings:setting error:&error];
        NSLog(@"%@",error);
        recorder.meteringEnabled = YES;
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            timerVoice = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerVoice) userInfo:nil repeats:YES];
            [timerVoice fire];
            [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [recorder record];
        });
        flagRecord = YES;
    }
}

#pragma mark 结束录制声音
-(void)recordEnd
{
    [voiceRecordBtn setTitle:@"按住 开始" forState:UIControlStateNormal];
    voiceRecordBtn.backgroundColor = [UIColor whiteColor];
    [[ReminderView reminderViewTitle:@"手指上滑，取消发送" withLevel:@"1" withFlag:YES] removeFromSuperview];
    [timerVoice invalidate];
    [recorder stop];
    flagRecord = NO;
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    finishRecord = YES;
    [messageTextView setHidden:NO];
    [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
} 
#pragma mark 取消录音
-(void)recordCancel
{
    [voiceRecordBtn setTitle:@"按住 开始" forState:UIControlStateNormal];
    voiceRecordBtn.backgroundColor = [UIColor whiteColor];
    [[ReminderView reminderViewTitle:@"松开手指，取消发送" withLevel:@"1" withFlag:YES] removeFromSuperview];
    [timerVoice invalidate];
     [recorder stop];
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    flagRecord = NO;
    cancalRecord = NO;
}
-(void)recordCancelReminder
{
    [ReminderView reminderViewTitle:@"松开手指，取消发送" withLevel:@"1" withFlag:YES];
}
#pragma mark 录音用到的方法
-(void)timerVoice
{
    if (recorder.isRecording)
    {
        sumTime = recorder.currentTime;
        [recorder updateMeters];//刷新音量数据
        int level = 1;
        if (-[recorder peakPowerForChannel:0]>35)
        {
            level = 1;
        }else
        {
            level = 7-(int)((-[recorder peakPowerForChannel:0])/5);
        }
        [ReminderView reminderViewTitle:@"手指上滑，取消发送" withLevel:[NSString stringWithFormat:@"%d",level] withFlag:NO];
    }
}
-(NSString*)updateLabel {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    int y = (int)[dd year];
    int m =  (int)[dd month];
    int d =  (int)[dd day];
    
    int hour =  (int)[dd hour];
    int min =  (int)[dd minute];
    int sec =  (int)[dd second];
    
    
    return [NSString stringWithFormat:@"%d-%d-%d-%d-%d-%d",y,m,d,hour,min,sec];
}
- (void)audio_PCMtoMP3
{
    NSString*str = [NSTemporaryDirectory() stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@",
                     filname]];
    //    NSLog(@"%@",str);
    NSString *mp3FileName = [str lastPathComponent];
    mp3FileName = [mp3FileName stringByAppendingString:@".MP3"];
    NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:voicePath])
    {
        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *mp3FilePath = [voicePath stringByAppendingPathComponent:mp3FileName];
    NSLog(@"%@",mp3FilePath);
    
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
        if (finishRecord)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendVoice:str];
                finishRecord = NO;
                cancalRecord = NO;
            });
        }
    }
}
#pragma mark 发送录音
-(void)sendVoice:(NSString*)voicePath
{
    NSURL *tempUrl = [NSURL fileURLWithPath:voicePath];
    NSData*data = [NSData dataWithContentsOfURL:tempUrl];

    [ChatDealClass sendMessege:data withSumtime:[NSString stringWithFormat:@"%d",sumTime] type:@"sound" sendID:sendUserID receiverID:receiverUserID isGroup:0 withBlock:^(AFHTTPRequestOperation *operation) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSError*error=nil;
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
         NSLog(@"服务器返回的数据为：%@==%@",[dict objectForKey:@"msg"],error);
    }];
    MsgObject*info = [[MsgObject alloc]init];
    info.content = tempUrl;
    info.fromUserId = sendUserID;
    info.time = [Statics getCurrentTime];
    info.type = @"sound";
     info.timeLen = [NSString stringWithFormat:@"%d",sumTime];
    [messages addObject:info];
    NSLog(@"tempUrl==%@",tempUrl);
    //重新刷新tableView
    [self.tView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark 开始输入文本
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [messageTextView setHidden:NO];
    flag = 0;
    flag1 = 0;
    flag2 = 0;
    [faceBtn setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"Fav_Search_Voice"] forState:UIControlStateNormal];
//    [sendBtn setHidden:NO];
    [moreBtn setHidden:YES];
    [voiceRecordBtn setHidden:YES];
    [moreView setHidden:YES];
    [faceView setHidden:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [sendBtn setHidden:YES];
    [moreBtn setHidden:NO];
    
//    [voiceRecordBtn setHidden:NO];
}
//只让tableview上的手势有效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}
-(void)swipe
{
     kbSize = CGSizeMake(SCREENWIDTH, 0);
     swipeflag = 1;
    [messageTextView resignFirstResponder];
    [moreView setHidden:YES];
    [faceView setHidden:YES];
    baseView.frame = CGRectMake(0, SCREENHEIGHT-40, SCREENHEIGHT, 40);
    tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40);
//    if (messages.count>0)
//    {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
//        [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//      NSLog(@"%f==%f==%f",tView.contentOffset.y,tView.contentSize.height,tView.frame.size.height);
     if (scrollFlag ==0)
     {
          scrollY = tView.contentOffset.y;
     }
     scrollFlag++;
     if (scrollFlag==3)
     {
          tView.contentOffset = CGPointMake(tView.contentOffset.x, scrollY);
     }
     if (tView.contentOffset.y+tView.frame.size.height>tView.contentSize.height)
     {
          swipeflag = 0;
          [swipeBtn setHidden:YES];
     }
     if (tView.contentOffset.y<=-64)
     {
          if (loadMoreFlag==0)
          {
               loadMoreFlag = 1;
               [self loadMore];
          }
          
     }
}
-(void)backAction:(UIBarButtonItem*)btn
{
     [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天界面"];
     [[NSUserDefaults standardUserDefaults]synchronize];
    NSNotification *notification = [NSNotification notificationWithName:@"CaptureView" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
     
//     dispatch_async(dispatch_get_global_queue(0, 0), ^{
          NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
          NSFileManager *fileManager=[NSFileManager defaultManager];
          if(![fileManager fileExistsAtPath:voicePath])
          {
               [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
          }
          NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:voicePath] objectEnumerator];
//          NSString* fileName;
//     NSLog(@"%@==%@",fileName,childFilesEnumerator.allObjects);
          for (NSString* fileName in childFilesEnumerator.allObjects) {
               NSLog(@"%@==%@",fileName,childFilesEnumerator);
               if ([fileName rangeOfString:@"-"].location !=NSNotFound) {
                    NSString* fileAbsolutePath = [voicePath stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:fileAbsolutePath error:nil];
               }
          }
//          while ([(fileName = [childFilesEnumerator nextObject]) rangeOfString:@"-"].location !=NSNotFound){
//               NSLog(@"%@==%@",fileName,childFilesEnumerator);
//               NSString* fileAbsolutePath = [voicePath stringByAppendingPathComponent:fileName];
//               [fileManager removeItemAtPath:fileAbsolutePath error:nil];
//          }
     
//     });
}

#pragma mark 请求数据，更新列表
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[NSUserDefaults standardUserDefaults]setObject:chatWithUser forKey:@"聊天界面"];
     [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop]run];
    });

//     queue = dispatch_queue_create("chatqueue", DISPATCH_QUEUE_CONCURRENT);
//     dispatch_async(queue, ^{
//          [self talkTimer];
//     });
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
          talkTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(talkTimer) userInfo:nil repeats:YES];
          [talkTimer fire];
          [[NSRunLoop currentRunLoop]run];
     });
//     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.56 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//          [messageTextView resignFirstResponder];
//     });

     
     messages = [[ChatDealClass dealDataClass]getMsgData:chatID withPage:messegePage];
     [tView reloadData];
//     tView.contentOffset = CGPointMake(tView.contentOffset.x, tView.contentOffset.y-40);
     if (messages.count>0)
     {
          
          NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
          [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//          [tView scrollRectToVisible:CGRectMake(tView.frame.origin.x, tView.frame.origin.y, SCREENWIDTH, tView.frame.size.height) animated:YES];
          
//          [tView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
     }
   
}
#pragma mark 离开界面，暂停各种计时器
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
//     if ([talkTimer isValid]) {
          [talkTimer invalidate];
//     }
     
    [timerVoice invalidate];
    [voicePlayTimer invalidate];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
     
     [[ChatDealClass dealDataClass]sendMSGID:ID];
}
-(void)talkTimer
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//         [NSThread sleepForTimeInterval:2];
         NSDictionary*dict1 = [ChatDealClass getNewMessegesID:maxID sendID:sendUserID receiverID:receiverUserID];
//     NSLog(@"%@",dict1);
         if (dict1)
         {
              NSMutableArray*array = [ChatDealClass dictionary:dict1 withSendID:sendUserID];
              if (array) {
                   NSLog(@"%@",dict1);
                   for (NSDictionary*dict in array) {
                        MsgObject*info = [[MsgObject alloc]init];
                        info.chatID = chatID;
                        if ([[dict objectForKey:@"sender"]isEqualToString:@"you"])
                        {
                             info.fromUserId = sendUserID;
                             info.toUserId = receiverUserID;
                        }else
                        {
                             info.fromUserId = receiverUserID;
                             info.toUserId = sendUserID;
                        }
                        info.type = [dict objectForKey:@"type"];
                        
                        info.content = [dict objectForKey:@"msg"];
                        //                 NSLog(@"=content=%@",[dict objectForKey:@"msg"]);
                        info.time = [dict objectForKey:@"time"];
                        info.messageId = [dict objectForKey:@"id"];
                        info.timeLen = [dict objectForKey:@"TimeSu"];
//                        NSLog(@"info.timeLen=%@",[dict objectForKey:@"TimeSu"]);
                        [[ChatDealClass dealDataClass]saveMsg:info];
                   }
              }
              messages = [[ChatDealClass dealDataClass]getMsgData:chatID withPage:messegePage];
//              MsgObject*info = [messages lastObject];
              //         NSLog(@"%@",info.content);
              dispatch_async(dispatch_get_main_queue(), ^{
                   [tView reloadData];
                   MsgObject*info = [messages lastObject];
                   [[ChatDealClass dealDataClass]sendMSGID:ID];
//                   NSLog(@"%@",info.messageId);
                   if (messages.count>0)
                   {
                        if (!swipeflag)
                        {
                             NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
                             [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        }else
                        {
                             if (swipeBtn==nil)
                             {
                                  swipeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                  swipeBtn.frame = CGRectMake(SCREENWIDTH-100, SCREENHEIGHT-75, 115, 30);
                                  [swipeBtn setTitle:@"有新消息" forState:UIControlStateNormal];
                                  [swipeBtn setTitleColor:[UIColor colorWithRed:79/255.0 green:139/255.0 blue:103/255.0 alpha:1] forState:UIControlStateNormal];
                                  [swipeBtn addTarget:self action:@selector(swipeNew) forControlEvents:UIControlEventTouchUpInside];
                                  swipeBtn.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
                                  swipeBtn.layer.cornerRadius = 15;
                                  [self.view addSubview:swipeBtn];
                             }else
                             {
                                  [swipeBtn setHidden:NO];
                             }
                        }
                   }
              });
              MsgObject*info1 = messages[messages.count-1];
              maxID = info1.messageId;
              //        NSLog(@"%@",info1.content);
              [[ChatDealClass dealDataClass]changeManMaxID:maxID chatID:chatID];
              if ([info1.content hasSuffix:@"mp4"]||[info1.content hasSuffix:@"MP4"]||[info1.type isEqualToString:@"video"])
              {
                   [[ChatDealClass dealDataClass]changeManMsg:@"[视频]" chatID:chatID];
              }else if([info1.content hasSuffix:@"mp3"]||[info1.content hasSuffix:@"MP3"]||[info1.type isEqualToString:@"sound"])
              {
                   [[ChatDealClass dealDataClass]changeManMsg:@"[声音]" chatID:chatID];
              }else if([info1.content hasSuffix:@"png"]||[info1.content hasSuffix:@"jpg"]||[info1.type isEqualToString:@"img"])
              {
                   [[ChatDealClass dealDataClass]changeManMsg:@"[图片]" chatID:chatID];
              }else{
                   [[ChatDealClass dealDataClass]changeManMsg:info1.content chatID:chatID];
              }
              [[ChatDealClass dealDataClass]changeManTime:info1.time chatID:chatID];
         }
//    });
//    dispatch_barrier_async(queue, ^{
//         [NSThread sleepForTimeInterval:2];
//         [self talkTimer];
//         [NSThread sleepForTimeInterval:2];
//    });
}
-(void)swipeNew
{
     NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
     [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     [swipeBtn setHidden:YES];
}
-(void)timerAction
{
    if ([messageTextView.text isEqualToString:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sendBtn setHidden:YES];
            [moreBtn setHidden:NO];
        });
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sendBtn setHidden:NO];
            [moreBtn setHidden:YES];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:messageTextView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGRect rect = [messageTextView.text boundingRectWithSize:CGSizeMake(messageTextView.frame.size.width-10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//            NSLog(@"%f",rect.size.height);
            if (rect.size.height<20)
            {
                baseView.frame = CGRectMake(0, SCREENHEIGHT-kbSize.height-rect.size.height*2-5, SCREENWIDTH, rect.size.height*2+5);
                messageTextView.frame = CGRectMake(40, 4, SCREENWIDTH-120, rect.size.height*2-3);
            }else if(rect.size.height<60)
            {
                baseView.frame = CGRectMake(0, SCREENHEIGHT-kbSize.height-rect.size.height-25, SCREENWIDTH, rect.size.height+25);
                messageTextView.frame = CGRectMake(40, 4, SCREENWIDTH-120, rect.size.height+15);
            }else
            {
                baseView.frame = CGRectMake(0, SCREENHEIGHT-kbSize.height-90, SCREENWIDTH, 90);
                messageTextView.frame = CGRectMake(40, 4, SCREENWIDTH-120, 80);
            }
        });
    }
}
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
//    NSLog(@"keyboard changed, keyboard width = %f, height = %f",kbSize.width,kbSize.height);
    //在这里调整UI位置
    baseView.frame = CGRectMake(0, SCREENHEIGHT-40-kbSize.height, SCREENHEIGHT, 40);
    tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-kbSize.height-40);
    if (messages.count>0)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
        [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)keyboardWillHide:(NSNotification*)notification{
    //在这里调整UI位置
     kbSize = CGSizeMake(SCREENWIDTH, 0);
//     NSLog(@"keyboard changed, keyboard width = %f, height = %f",kbSize.width,kbSize.height);
    baseView.frame = CGRectMake(0, SCREENHEIGHT-kbSize.height-40, SCREENHEIGHT, 40);
    tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-kbSize.height-40);
    
     
    if (messages.count>0)
    {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
//        [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark 发送文本的方法
- (void)sendButton{

    //本地输入框中的信息
    NSMutableString*message = (NSMutableString*)self.messageTextView.text;
     NSLog(@"1%@",message);
     NSRange range = NSMakeRange(0, [message length]);
    message = (NSMutableString*)[message stringByReplacingOccurrencesOfString:@"\"" withString:@"“" options:NSCaseInsensitiveSearch range:range];
     NSLog(@"2%@",message);
    baseView.frame = CGRectMake(0, SCREENHEIGHT-kbSize.height-40, SCREENWIDTH, 40);
    messageTextView.frame = CGRectMake(40, 4, SCREENWIDTH-120, 32);
    if (message.length > 0) {
        self.messageTextView.text = @"";
        //        [self.messageTextView resignFirstResponder];
        
        MsgObject*infotext = [[MsgObject alloc]init];
        infotext.content = message;
        infotext.fromUserId = sendUserID;
        infotext.time = [Statics getCurrentTime];
        infotext.type = @"text";
        [messages addObject:infotext];
        
        //重新刷新tableView
        [self.tView reloadData];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
        [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([ChatDealClass sendMessege:message sendID:sendUserID receiverID:receiverUserID isGroup:0])
            {
                NSLog(@"1");
            }else
            {
                NSLog(@"0");
            }
        });
    }
    cursorPosition = NSMakeRange(0, 0);
}
#pragma mark 发送图片的方法
-(void)sendImage:(UIImage*)image
{
    NSData*data = UIImagePNGRepresentation(image);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [ChatDealClass sendMessege:data withSumtime:nil type:@"img" sendID:sendUserID receiverID:receiverUserID isGroup:0 withBlock:^(AFHTTPRequestOperation *operation) {
              NSString *html = operation.responseString;
              NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
              NSError*error=nil;
              id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
              NSLog(@"服务器返回的数据为：%@==%@",dict,error);
         }];
//    });
    
    MsgObject*infoimg = [[MsgObject alloc]init];
    infoimg.content = [data base64Encoding];
    infoimg.fromUserId = sendUserID;
    infoimg.time = [Statics getCurrentTime];
    infoimg.type = @"img";
    
    [messages addObject:infoimg];
    //重新刷新tableView
    [self.tView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}
#pragma mark 发送视频的方法
-(void)playvideo:(NSNotification*)info
{
    NSDictionary*dict = [info userInfo];
//    NSLog(@"%@",[dict objectForKey:@"videourl"]);
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
    
    [[Photo alloc] lowQuailtyWithInputURL:[dict objectForKey:@"videourl"] outputURL:tempUrl blockHandler:^(AVAssetExportSession *session){
        if(session.status == AVAssetExportSessionStatusCompleted){
            NSLog(@"success!");
            NSData*data = [NSData dataWithContentsOfURL:tempUrl];
//            NSLog(@"data=%@",data);
            if (data.length > 0) {
                MsgObject*infovideo = [[MsgObject alloc]init];
                infovideo.content = tempUrl;
                infovideo.fromUserId = sendUserID;
                infovideo.time = [Statics getCurrentTime];
                infovideo.type = @"video";
                [messages addObject:infovideo];
                
//                [[ChatDealClass dealDataClass]saveMsg:infovideo];
                //重新刷新tableView
                [self.tView reloadData];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
                [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                [self removeRecordView];
//                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                      [ChatDealClass sendMessege:data withSumtime:nil type:@"video" sendID:sendUserID receiverID:receiverUserID isGroup:0 withBlock:^(AFHTTPRequestOperation *operation) {
                           NSString *html = operation.responseString;
                           NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                           NSError*error=nil;
                           id dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                           NSLog(@"服务器返回的数据为：%@==%@",dict,error);
                      }];
//                 });
            }
        }else if (session.status == AVAssetExportSessionStatusFailed){
            NSLog(@"error = %@",session.error);
        }else
        {
            NSLog(@"压缩视频失败！");
        }
    }];
}
-(void)moreButton
{
    [messageTextView setHidden:NO];
    [faceView setHidden:YES];
    if (flag2)
    {
        flag2 = 0;
        [messageTextView becomeFirstResponder];
        [moreView setHidden:YES];
    }else
    {
        flag2 = 1;
        flag = 0;
        flag1 = 0;
        [messageTextView resignFirstResponder];
        [faceBtn setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageNamed:@"Fav_Search_Voice"] forState:UIControlStateNormal];
        [voiceRecordBtn setHidden:YES];
        
        baseView.frame = CGRectMake(0, SCREENHEIGHT-140, SCREENHEIGHT, 40);
        tView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-100-40);
        if (messages.count>0)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
            [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        if (moreView==nil)
        {
            moreView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-100, SCREENWIDTH, 100)];
            moreView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            [self.view addSubview:moreView];
            NSArray*moreArrayTitle = [NSArray arrayWithObjects:@"最近联系人",@"发送图片",@"小视频",@"聊天清除",nil];
            NSArray*moreArrayImage = [NSArray arrayWithObjects:@"ql_pic5.jpg",@"ql_pic1.jpg",@"sharemore_video@2x",@"ql_pic4.jpg",nil];
            for (int i =0; i<[moreArrayImage count]; i++)
            {
                UIButton*btn;
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                UILabel*titleLabel;
                if (SCREENWIDTH>320)
                {
                    btn.frame = CGRectMake(20+(SCREENWIDTH-20)/5*i, 15, (SCREENWIDTH-20)/5-18, (SCREENWIDTH-20)/5-18);
                    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, (SCREENWIDTH-20)/5-3, (SCREENWIDTH-20)/5-18, 30)];
                     [btn setImage:[UIImage redraw:[UIImage imageNamed:moreArrayImage[i]] Frame:CGRectMake(0, 0, (SCREENWIDTH-20)/5-18, (SCREENWIDTH-20)/5-18)] forState:UIControlStateNormal];
                }else
                {
                    btn.frame = CGRectMake(20+(SCREENWIDTH-20)/4*i, 15, (SCREENWIDTH-20)/4-18, (SCREENWIDTH-20)/4-18);
                    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, (SCREENWIDTH-20)/4-3, (SCREENWIDTH-20)/4-18, 30)];
                     [btn setImage:[UIImage redraw:[UIImage imageNamed:moreArrayImage[i]] Frame:CGRectMake(0, 0, (SCREENWIDTH-20)/4-18, (SCREENWIDTH-20)/4-18)] forState:UIControlStateNormal];
                }
                titleLabel.font = [UIFont systemFontOfSize:12];
                [btn setBackgroundColor:[UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1]];
                
                btn.showsTouchWhenHighlighted = YES;
                btn.tag = 1100+i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                titleLabel.numberOfLines = 0;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = moreArrayTitle[i];
                titleLabel.tag = 1200+i;
                titleLabel.textColor = [UIColor colorWithRed:0.459 green:0.459 blue:0.459 alpha:1];
                if ([titleLabel.text isEqualToString:@"最近联系人"]&&SCREENWIDTH<400)
                {
                    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x-10, titleLabel.frame.origin.y, titleLabel.frame.size.width+20, titleLabel.frame.size.height);
                }
                [moreView addSubview:btn];
                [moreView addSubview:titleLabel];
            }
        }else
        {
            [moreView setHidden:NO];
        }
    }
}
-(void)btnAction:(UIButton*)btn
{
    UILabel*label = (UILabel*)[moreView viewWithTag:btn.tag+100];
    if (label.tag ==1200)
    {
        NSLog(@"最近联系人");
        [self.navigationController popViewControllerAnimated:YES];
    }else if(label.tag ==1201)
    {
        NSLog(@"发送图片");
        UIActionSheet*actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍摄照片",nil];
        [actionsheet showInView:self.view];
//        actionsheet
    }else if(label.tag ==1202)
    {
          [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
         
    }else if(label.tag ==1203)
    {
        NSLog(@"聊天清除");
    }
}
- (void)showcamera {
     
     if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
          [Common showMessage:@"该设备没有摄像头" withView:self.view];
          return;
     }
     if (![[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeMovie]) {
          [Common showMessage:@"不支持录制的视频类型" withView:self.view];
          return;
     }
     
     imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
     imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,kUTTypeVideo, nil];
     imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
     imagePicker.showsCameraControls = YES;
     imagePicker.videoMaximumDuration = 60;
     imagePicker.delegate = self;
     [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
          if (buttonIndex==0)
          {
               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
               picker.delegate = self;
               //        picker.allowsEditing = YES;
               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
               if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:picker animated:YES completion:nil];
               });
               
          }else if (buttonIndex==1)
          {
               if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [Common showMessage:@"该设备没有摄像头" withView:self.view];
                    return;
               }
               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
               picker.delegate = self;
               //        picker.allowsEditing = YES;
               picker.sourceType = UIImagePickerControllerSourceTypeCamera;
               //        NSLog(@"%f==%f",picker.cameraOverlayView.frame.size.height,picker.cameraOverlayView.frame.size.width);
               if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:picker animated:YES completion:^{
                         
                    }];
               });
               
               //        [self.imagePickerController takePicture];
          }
     });
    
}

#pragma mark 相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    picker.cameraOverlayView.backgroundColor = [UIColor clearColor];
//    picker.view.backgroundColor = [UIColor clearColor];
//    for (UIView*view in picker.view.subviews)
//    {
//        NSLog(@"%@",view);
//    }
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
         if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
              NSString *path = (NSString *)[[info valueForKey:UIImagePickerControllerMediaURL] path];
              ReminderView *indicator = [ReminderView reminderView];
              [self.view addSubview:indicator];
              // 保存视频
//              UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
              [self video:path didFinishSavingWithError:nil contextInfo:nil];
         }else
         {
              if (picker.sourceType ==UIImagePickerControllerSourceTypeCamera)
              {
                   //            if ([[self appDelegate] connect]) {
                   //            NSLog(@"%f==%f",picker.cameraOverlayView.frame.size.height,picker.cameraOverlayView.frame.size.width);
                   [self sendImage:[self thumbnailWithImageWithoutScale:chosenImage size:CGSizeMake(SCREENWIDTH, SCREENHEIGHT-150)]];
                   //            }
              }else
              {
                   [self sendImage:chosenImage];
              }
         }
    }];
}
// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
     NSLog(@"videoPath = %@",videoPath);
     NSLog(@"error = %@",error);
     NSURL *pathUrl = [NSURL fileURLWithPath:videoPath];
     
     // 上传文件时，是文件不允许被覆盖，文件重名
     // 可以在上传时使用当前的系统事件作为文件名
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     // 设置时间格式
     formatter.dateFormat = @"yyyyMMddHHmmss";
     NSString *str = [formatter stringFromDate:[NSDate date]];
     NSString *videoName = [NSString stringWithFormat:@"%@.mp4",str];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
     if (![fileManager fileExistsAtPath:documentsDirectory]) {
          [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
     }
     documentsDirectory = [documentsDirectory stringByAppendingPathComponent:videoName];
     NSURL *tempUrl = [NSURL fileURLWithPath:documentsDirectory];
     NSLog(@"tempUrl=%@",tempUrl);
     
     [[Photo alloc] lowQuailtyWithInputURL:pathUrl outputURL:tempUrl blockHandler:^(AVAssetExportSession *session){
          if(session.status == AVAssetExportSessionStatusCompleted){
               NSLog(@"success!");
               NSData*data = [NSData dataWithContentsOfURL:tempUrl];
//                           NSLog(@"data=%@",data);
               if (data.length > 0) {
                    MsgObject*infovideo = [[MsgObject alloc]init];
                    infovideo.content = tempUrl;
                    infovideo.fromUserId = sendUserID;
                    infovideo.time = [Statics getCurrentTime];
                    infovideo.type = @"video";
                    [messages addObject:infovideo];
                    //重新刷新tableView
                    
                    [self.tView reloadData];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
                    [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    //                [self removeRecordView];
//                    indicator = [ReminderView reminderView];
                    
                    
                    [ChatDealClass sendMessege:data withSumtime:nil type:@"video" sendID:sendUserID receiverID:receiverUserID isGroup:0 withBlock:^(AFHTTPRequestOperation *operation) {
//                         NSString *html = operation.responseString;
//                         NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//                         NSError*error=nil;
//                         id dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                         NSLog(@"服务器返回的数据为：%@==%@",dict,error);
//                         indicator = [ReminderView reminderView];
//                         [indicator removeFromSuperview];
                         [fileManager removeItemAtPath:videoPath error:nil];
                    }];
               }
          }else if (session.status == AVAssetExportSessionStatusFailed){
               NSLog(@"error = %@",session.error);
          }else
          {
               NSLog(@"压缩视频失败！");
          }
     }];
     
}
//获取视频时长
-(CGFloat) getVideoLength:(NSURL *)movieURL{
     NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                      forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
     AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
     float second = 0;
     second = urlAsset.duration.value/urlAsset.duration.timescale;//视频的总时长，单位秒
     return second;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[self appDelegate] connect];
    }];
}
#pragma mark table代理

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MsgObject *infoall  = [messages objectAtIndex:indexPath.row];
    NSString *msg = infoall.content;
    NSString*type = infoall.type;
    //    CGSize textSize = {260.0 , 10000.0};
    if ([type isEqualToString:@"text"])//文本
    {
         NSMutableArray*array = [[NSMutableArray alloc]init];
         NSString*lenght = [self getImageRange:msg array:array];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:messageTextView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize size = [lenght boundingRectWithSize:CGSizeMake(messageTextView.frame.size.width-30, 999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
         size.width +=(padding/2);
        //    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
//        NSLog(@"%f",size.height);
//        size.height += padding*2;
//         NSLog(@"%f",size.height);
         if (size.width>messageTextView.frame.size.width-30)
         {
//              NSLog(@"size.height=%f",size.height);
              if (size.height<20)
              {
                   size =  CGSizeMake(messageTextView.frame.size.width-30, size.height+padding);
              }
              //              else if (size.height<40)
              //              {
              //                   size =  CGSizeMake(messageTextView.frame.size.width-30, size.height+padding*2);
              //              }
              else
              {
                   size =  CGSizeMake(messageTextView.frame.size.width-30, size.height);
              }
              
         }
         
        CGFloat height;
        if (size.height<20)
        {
            height = size.height+padding*2;
        }else if(size.height<40)
        {
            height = size.height+padding*2;
        }
//        else if (size.height<60)
//        {
//            height = size.height+padding*2.5;
////        }else if (size.height<80)
////        {
////            height = size.height+padding*3;
////        }else if (size.height<100)
////        {
////            height = size.height+padding*3;
////        }
////        else if (size.height<120)
////        {
////            height = size.height+padding*3;
//        }
        else if (size.height<100)
        {
             height = size.height+padding*2.3;
        }else if (size.height<140)
        {
            height = size.height+padding*3.5;
        }else if (size.height<200)
        {
            height = size.height+padding*4.5;
        }
        else if (size.height<300)
        {
             height = size.height+padding*5;
        }else
        {
             int height1;
             if (SCREENWIDTH>320)
             {
                  height1 = (int)(size.height/100)*padding;
             }else
             {
                  height1 = (int)(size.height/90)*padding;
             }
             height = size.height+height1+padding;
        }
//         NSLog(@"%f",height);
        return height;
    }else if ([type isEqualToString:@"img"])//图片
    {
        UIImage*image;
        if ([msg hasSuffix:@"png"]||[msg hasSuffix:@"jpg"]||[msg hasSuffix:@"gif"]||[msg hasSuffix:@"jpeg"]) {
            NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/%@",msg]]];
            NSLog(@"%@",[NSString stringWithFormat:@"http://192.168.0.136:82/apply/%@",msg]);
            image = [UIImage imageWithData:data];
            [[ChatDealClass dealDataClass]changeMsgID:infoall.ID newData:[data base64Encoding]];
        }else
        {
            image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:msg]];
        }
//        NSLog(@"%f======%f",image.size.height,image.size.width);
        if (image.size.height>image.size.width)
        {
            return 100+20;
        }else
        {
            if (image.size.height==0||image.size.width==0)
            {
                return 50;
            }else
            {
                return 100*image.size.height/image.size.width+20;
            }
        }
        return 100+20;
    }else if ([type isEqualToString:@"video"])//小视频
    {
        return 170+10;
    }else if ([type isEqualToString:@"sound"])//
    {
        return 50;
    }
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}
-(BOOL)faceStr:(NSString*)msg
{

     if([msg length]<=0)
          return NO;
     int n=-1;
     if( [msg characterAtIndex:[msg length]-1] == ']'){
          for(int i=(int)[msg length]-1;i>=0;i--){
               if( [msg characterAtIndex:i] == '[' ){
                    n = i;
                    break;
               }
          }
     }
     if (n>0)
     {
          return NO;
     }
     NSString* u;
     if(n>=0)
          u = [msg substringWithRange:NSMakeRange(n,[msg length]-n)];
//     NSLog(@"u===%@",u);
     for (NSString*str in faceArray)
     {
          if ([str isEqualToString:u])
          {
               return YES;
          }
     }
     return NO;
}
-(NSString*)getImageRange:(NSString*)message  array: (NSMutableArray*)array {
//     NSLog(@"%@",message);
     NSRange range=[message rangeOfString: BEGIN_FLAG];
     NSRange range1=[message rangeOfString: END_FLAG];
     //判断当前字符串是否还有表情的标志。
     if (range.length>0 && range1.length>0) {
          if (range.location > 0) {
               [array addObject:[message substringToIndex:range.location]];
               [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
               NSString *str=[message substringFromIndex:range1.location+1];
               [self getImageRange:str array:array ];
          }else {
               NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
               //排除文字是“”的
               if (![nextstr isEqualToString:@""]) {
                    [array addObject:nextstr];
                    NSString *str=[message substringFromIndex:range1.location+1];
                    [self getImageRange:str array:array ];
               }else {
                    return nil;
               }
          }
     } else if (message != nil) {
          [array addObject:message];
     }
//     NSLog(@"%@",array);
     NSMutableString*msgStr = [[NSMutableString alloc]init];
     int flagmsg = 0;
     for (NSString*str in array)
     {
          if ([str hasPrefix:BEGIN_FLAG]&&[str hasSuffix:END_FLAG])
          {
               if (SCREENWIDTH>320)
               {
                    [msgStr insertString:@"aa." atIndex:0];
               }else
               {
                    [msgStr insertString:@"。." atIndex:0];
               }
               
          }else
          {
               [msgStr insertString:str atIndex:msgStr.length];
               flagmsg = 1;
          }
     }
     
     if (flagmsg ==0)
     {
          [msgStr insertString:@"1" atIndex:0];
     }
//     NSLog(@"===%@",msgStr);
     return msgStr;
//     for (NSString*str in array)
//     {
//          if ([str hasPrefix:BEGIN_FLAG]&&[str hasSuffix:END_FLAG])
//          {
//
//          }
//     }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MsgObject *infocell = [messages objectAtIndex:indexPath.row];
    NSString*type = infocell.type;
//    NSLog(@"type = =%@",type);
    if ([type isEqualToString:@"text"])//文本
    {
         
        static NSString *identifier = @"textCell";
        ChatMessageCell *cell =(ChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        //发送者
        NSString *sender = infocell.fromUserId;
        //消息
        NSMutableString *message = infocell.content;
        //时间
//        NSString *time = infocell.time;
         CGSize size;
         NSMutableArray*array = [[NSMutableArray alloc]init];
         
         
         NSString*lenght = [self getImageRange:message array:array];
         if (message.length<=5)
         {
              if ([self faceStr:message])
              {
                   size = CGSizeMake(34, 19);
              }else
              {
                   NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                   paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                   NSDictionary *attributes = @{NSFontAttributeName:messageTextView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                   size = [lenght boundingRectWithSize:CGSizeMake(messageTextView.frame.size.width-30, 999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                   size.width +=(padding/2);
              }
              
         }else
         {
              NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
              paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
              NSDictionary *attributes = @{NSFontAttributeName:messageTextView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
              size = [lenght boundingRectWithSize:CGSizeMake(messageTextView.frame.size.width-30, 999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
              size.width +=(padding/2);
         }
         
//        NSLog(@"%f=%f",size.height,size.width);
         if (size.width>messageTextView.frame.size.width-30)
         {
//              NSLog(@"1size.height=%f",size.height);
              if (size.height<20)
              {
                   size =  CGSizeMake(messageTextView.frame.size.width-30, size.height+padding);
              }
//              else if (size.height<40)
//              {
//                   size =  CGSizeMake(messageTextView.frame.size.width-30, size.height+padding*2);
//              }
              else
              {
                   size =  CGSizeMake(messageTextView.frame.size.width-30, size.height);
              }
              
         }
         NSRange range = NSMakeRange(0, [message length]);
         message = (NSMutableString*)[message stringByReplacingOccurrencesOfString:@"“" withString:@"\"" options:NSCaseInsensitiveSearch range:range];
         message = (NSMutableString*)[message stringByReplacingOccurrencesOfString:@"”" withString:@"\"" options:NSCaseInsensitiveSearch range:range];
        cell.messageContentView.text = (NSString*)message;
        
         
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        UIImage *bgImage = nil;
        //发送消息
         if (![sender isEqualToString:sendUserID]) {
              //背景图
              
              bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
              if (size.height>300)
              {
                   int height;
                   if (SCREENWIDTH>320)
                   {
                        height = (int)(size.height/100)*padding;
                   }else
                   {
                        height = (int)(size.height/80)*padding;
                   }
                   
                   [cell.messageContentView setFrame:CGRectMake(padding*3.5+3, 7, size.width, size.height+height)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5-3, 2, size.width + padding+10, size.height+height+padding)];
                   NSLog(@"%f==%f==%f==%f",size.height,size.height+height,cell.messageContentView.frame.size.height,cell.bgImageView.frame.size.height);
              }else if (size.height>150)
              {
                   [cell.messageContentView setFrame:CGRectMake(padding*3.5, 7, size.width, size.height+padding*3.4)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+10, size.height+padding*4.5)];
              }else if (size.height>100)
              {
                   [cell.messageContentView setFrame:CGRectMake(padding*3.5+3, 7, size.width, size.height+padding*3)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5-3, 2, size.width + padding+10, cell.messageContentView.frame.size.height+16)];
              }else if (size.height>40)
              {
                   [cell.messageContentView setFrame:CGRectMake(padding*3.5, 7, size.width-5, size.height+padding*1.2)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+10, size.height+padding*2.5)];
              }else if (size.height<40)
              {
                   [cell.messageContentView setFrame:CGRectMake(padding*3.5, 13, size.width+2, size.height+10)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2 , size.width + padding+5, size.height + padding*2)];
              }else
              {
                   [cell.messageContentView setFrame:CGRectMake(padding*3.5, 13, size.width-3, size.height+(int)(size.height/50)*padding)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2 , size.width + padding+5, size.height + (int)(size.height/50+1)*padding)];
                   
              }
              if (message.length<2)
              {
                   [cell.bgImageView setFrame:CGRectMake(cell.bgImageView.frame.origin.x, cell.bgImageView.frame.origin.y, cell.bgImageView.frame.size.width+8, cell.bgImageView.frame.size.height)];
              }
//                                 cell.messageContentView.backgroundColor = [UIColor greenColor];
              //                   cell.messageContentView.center = CGPointMake(cell.messageContentView.center.x, cell.bgImageView.center.y-4);
              //        cell.messageContentView.backgroundColor = [UIColor greenColor];
              //        self.automaticallyAdjustsScrollViewInsets = NO;
              [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
              cell.userImageView.image = chatUserImage;
         }else {
              bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
              //                           cell.messageContentView.backgroundColor = [UIColor greenColor];
              if (size.height>300)
              {
                   int height;
                   if (SCREENWIDTH>320)
                   {
                        height = (int)(size.height/100)*padding;
                   }else
                   {
                        height = (int)(size.height/90)*padding;
                   }
                   [cell.messageContentView setFrame:CGRectMake(SCREENWIDTH-size.width+5 - padding-50-5, 7, size.width, size.height+height)];
                   cell.messageContentView.textAlignment = NSTextAlignmentJustified;
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+5, size.height+height+padding)];
                   //                                                              +padding*(int)((int)size.height/100)
              }else if (size.height>150)
              {
                   [cell.messageContentView setFrame:CGRectMake(SCREENWIDTH-size.width+5 - padding-50-5, 7, size.width, size.height+padding*3.2)];
                   cell.messageContentView.textAlignment = NSTextAlignmentJustified;
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+5, size.height+padding*4)];
                   //     +padding*(int)((int)size.height/100)
              }else if (size.height>100)
              {
                   [cell.messageContentView setFrame:CGRectMake(SCREENWIDTH-size.width+5 - padding-50-5, 7, size.width, size.height+padding*2.5)];
                   cell.messageContentView.textAlignment = NSTextAlignmentJustified;
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+5,cell.messageContentView.frame.size.height+16)];
                   //     +padding*(int)((int)size.height/100)
              }else if (size.height>40)
              {
                   [cell.messageContentView setFrame:CGRectMake(SCREENWIDTH-size.width+5 - padding-50, 7, size.width-5, size.height+padding*1.2)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+5, size.height+padding*2)];
              }else if (size.height<40)
              {
                   [cell.messageContentView setFrame:CGRectMake(SCREENWIDTH-size.width+5 - padding-50, 13, size.width+2, size.height+10)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+5, size.height + padding*2)];
              }else
              {
                   [cell.messageContentView setFrame:CGRectMake(SCREENWIDTH-size.width+5 - padding-50, 13, size.width-3, size.height+(int)(size.height/50)*padding)];
                   [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-5, 2, size.width + padding+5, size.height + (int)(size.height/50+1)*padding)];
              }
//                                 cell.messageContentView.backgroundColor = [UIColor whiteColor];
              if (message.length<2)
              {
                   [cell.bgImageView setFrame:CGRectMake(cell.bgImageView.frame.origin.x-4, cell.bgImageView.frame.origin.y, cell.bgImageView.frame.size.width+4, cell.bgImageView.frame.size.height)];
                   [cell.messageContentView setFrame:CGRectMake(cell.messageContentView.frame.origin.x-3, cell.messageContentView.frame.origin.y, cell.messageContentView.frame.size.width, cell.messageContentView.frame.size.height)];
              }
              //                   cell.messageContentView.center = CGPointMake(cell.messageContentView.center.x, cell.bgImageView.center.y-4);
              [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
              cell.userImageView.image = chatUserImage;
         }
         [cell.nameLabel setFrame:CGRectZero];
         
        cell.bgImageView.image = bgImage;
//        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@",time];
        
        return cell;
    }else if ([type isEqualToString:@"img"])//图片
    {
        NSString *message = infocell.content;
//        NSLog(@"%@",message);
        NSString *sender = infocell.fromUserId;
//        NSString *time = infocell.time;
//        NSLog(@"%@==%@",message,[dict objectForKey:@"msg"]);10152432
        UIImage*image;
        if ([message hasSuffix:@"png"]||[message hasSuffix:@"jpg"]||[message hasSuffix:@"gif"]||[message hasSuffix:@"jpeg"]) {
            NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/%@",message]]];
            image = [UIImage imageWithData:data];
            [[ChatDealClass dealDataClass]changeMsgID:infocell.ID newData:[data base64Encoding]];
        }else
        {
            image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:message]];
        }
        
        static NSString *identifier = @"picCell";
        ChatMessageCell *cell =(ChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.userInteractionEnabled = NO;
        int height,width;
//         NSLog(@"image.size.height==%fimage.size.width==%f==%@",image.size.height,image.size.width,message);
        if (image.size.height>image.size.width)
        {
            height = 100;
            width = 100*image.size.width/image.size.height;
        }else
        {
            width = 100;
            height = 100*image.size.height/image.size.width;
        }
          UIImage *bgImage = nil;
         if (SCREENWIDTH>320)
         {
              if (![sender isEqualToString:sendUserID])
              {
                   bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
                   [cell.imageview setFrame:CGRectMake(padding*3+3+3, 8, width, height)];
                   [cell.bgImageView setFrame:CGRectMake(cell.imageview.frame.origin.x - 8-6, 0, width+8+17+2,height+24+2)];
                   [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
                   cell.userImageView.image = chatUserImage;
              }else
              {
                   bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
                   [cell.imageview setFrame:CGRectMake(SCREENWIDTH-padding-width-43-5, 8, width, height)];
                   [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(cell.imageview.frame.origin.x -12-1, 0, width + 8+17+2, height+24+2)];
                   cell.userImageView.image = chatUserImage;
              }
         }else
         {
              if (![sender isEqualToString:sendUserID])
              {
                   bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
                   [cell.imageview setFrame:CGRectMake(padding*3+3+3, 8, width, height)];
                   [cell.bgImageView setFrame:CGRectMake(cell.imageview.frame.origin.x - 8-6, 0, width+8+17+2,height+24+2)];
                   [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
                   cell.userImageView.image = chatUserImage;
              }else
              {
                   bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
                   [cell.imageview setFrame:CGRectMake(SCREENWIDTH-padding-width-43-5, 8, width, height)];
                   [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(cell.imageview.frame.origin.x -12-1, 0, width + 8+17+2, height+24+2)];
                   cell.userImageView.image = chatUserImage;
              }
         }
        
         [cell.nameLabel setFrame:CGRectZero];
        cell.bgImageView.image = bgImage;
        cell.imageview.image = image;
        cell.imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [cell.imageview addGestureRecognizer:tap];
        
//        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@",time];
        
        return cell;
    }else if ([type isEqualToString:@"video"])//小视频
    {
         ReminderView *indicator = [ReminderView reminderView];
         [indicator removeFromSuperview];
        static NSString *identifier = @"videoCell";
        ChatMessageCell *cell =(ChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        //发送者
        NSString *sender = infocell.fromUserId;
        //消息
        id message = infocell.content;
        if (![message isKindOfClass:[NSURL class]])
        {
            if (![message hasSuffix:@"mp4"]&&![message hasSuffix:@"MP4"])
            {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *strtime = [formatter stringFromDate:[NSDate date]];
//                     NSLog(@"cell.movieUrl cell.movieUrl  =%@",cell.movieUrl );
                    NSString*str = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                    [NSString stringWithFormat: @"%@",
                                     strtime]];
                    //    NSLog(@"%@",str);
                    NSString *mp4FileName = [str lastPathComponent];
                    mp4FileName = [mp4FileName stringByAppendingString:@".mp4"];
                    NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    if(![fileManager fileExistsAtPath:voicePath])
                    {
                        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    NSString *mp4FilePath = [voicePath stringByAppendingPathComponent:mp4FileName];
                    NSData*dat = [NSData dataWithBase64EncodedString:message];
//                 NSLog(@"%@",dat);
                    [dat writeToFile:mp4FilePath atomically:YES];
                 
                 NSError*error =nil;
                 [fileManager removeItemAtPath:[voicePath stringByAppendingPathComponent:[[ChatDealClass dealDataClass] deleteDataWithMsgID:infocell.ID]] error:&error];
                 
                    [[ChatDealClass dealDataClass]changeMsgID:infocell.ID newData:mp4FileName];
//                    dispatch_async(dispatch_get_main_queue(), ^{
                         cell.movieUrl = mp4FileName;
//                    });
            }else
            {
                 cell.movieUrl = message;
            }
        }
        else
        {
             cell.movieUrl = [[[NSString stringWithFormat:@"%@",message] componentsSeparatedByString:@"/"] lastObject];
             NSLog(@"cell.movieUrl ==%@",cell.movieUrl);
        }
//         NSLog(@"cell.movieUrl==%@",cell.movieUrl);
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.userInteractionEnabled = NO;
        UIImage *bgImage = nil;
         if (SCREENWIDTH>320)
         {
              if (![sender isEqualToString:sendUserID]) {
                   //背景图
                   bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
                   [cell.movieImage setFrame:CGRectMake(padding*3+6+3, 10, SCREENWIDTH/2, 150)];
                   [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(padding*3-8, 0, SCREENWIDTH/2+8+17+6, 150+24+6)];
                   cell.userImageView.image = chatUserImage;
                   cell.logoMovie.center = cell.movieImage.center;
              }else {
                   bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
                   [cell.movieImage setFrame:CGRectMake(SCREENWIDTH/2 +10 - padding-50-8-3, 10,  SCREENWIDTH/2, 150)];
                   [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(cell.movieImage.frame.origin.x-12-3, 0, cell.movieImage.frame.size.width + 8+17+6, 150+24+6)];
                   cell.userImageView.image = chatUserImage;
                   cell.logoMovie.center = cell.movieImage.center;
              }
         }else
         {
              if (![sender isEqualToString:sendUserID]) {
                   //背景图
                   bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
                   [cell.movieImage setFrame:CGRectMake(padding*3+6+3, 10, SCREENWIDTH/2, 150)];
                   [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(padding*3-8, 0, SCREENWIDTH/2+8+17+6, 150+24+6)];
                   cell.userImageView.image = chatUserImage;
                   cell.logoMovie.center = cell.movieImage.center;
              }else {
                   bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
                   [cell.movieImage setFrame:CGRectMake(SCREENWIDTH/2 +10 - padding-50-8-3, 10,  SCREENWIDTH/2, 150)];
                   [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(cell.movieImage.frame.origin.x-12-3, 0, cell.movieImage.frame.size.width + 8+17+6, 150+24+6)];
                   cell.userImageView.image = chatUserImage;
                   cell.logoMovie.center = cell.movieImage.center;
              }
         }
        [cell.nameLabel setFrame:CGRectZero];
         [cell.logoMovie setHidden:NO];
//         cell.movieImage.backgroundColor = [UIColor blackColor];
         NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
         NSString *mp4FilePath = [voicePath stringByAppendingPathComponent:cell.movieUrl];
         NSURL*url = [NSURL fileURLWithPath:mp4FilePath];
//         NSLog(@"url = %@",cell.movieUrl);
         cell.movieImage.image = [self getImage:url];
        cell.bgImageView.image = bgImage;
//        if (lastMovieCell==nil)
//        {
//            lastMovieCell = cell;
//        }else
//        {
//            lastMovieCell.isMoviePlaying = NO;
//            lastMovieCell = cell;
//        }
//        cell.isMoviePlaying = YES;
//        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@",time];
        return cell;
    }else if ([type isEqualToString:@"sound"])
    {
        static NSString *identifier = @"voiceCell";
        ChatMessageCell *cell =(ChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        //发送者
        NSString *sender = infocell.fromUserId;
        //消息
        id message = infocell.content;
        //         NSLog(@"message=%@",message);
        //时间
//        NSString *time = infocell.time;
        
        if (![message isKindOfClass:[NSURL class]])
        {
            if (![message hasSuffix:@"mp3"]&&![message hasSuffix:@"MP3"])
            {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *strtime = [formatter stringFromDate:[NSDate date]];
                    
                    NSString*str = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                    [NSString stringWithFormat: @"%@",
                                     strtime]];
                    //    NSLog(@"%@",str);
                    NSString *mp3FileName = [str lastPathComponent];
                    mp3FileName = [mp3FileName stringByAppendingString:@".MP3"];
                    NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    if(![fileManager fileExistsAtPath:voicePath])
                    {
                        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    NSString *mp3FilePath = [voicePath stringByAppendingPathComponent:mp3FileName];
                    NSData*dat = [NSData dataWithBase64EncodedString:message];
                    [dat writeToFile:mp3FilePath atomically:YES];
                 
                 NSError*error =nil;
                 [fileManager removeItemAtPath:[voicePath stringByAppendingPathComponent:[[ChatDealClass dealDataClass] deleteDataWithMsgID:infocell.ID]] error:&error];
//                 NSLog(@"error==%@,path=%@",error,[[ChatDealClass dealDataClass] deleteDataWithMsgID:infocell.ID]);
                 
                    [[ChatDealClass dealDataClass]changeMsgID:infocell.ID newData:mp3FileName];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSData*dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/up/chat/20154219525694294625.mp3"]]];
//                        NSLog(@"%@",dat);
                        cell.voiceUrl = mp3FileName;
                    });
            
            }else
            {
                cell.voiceUrl = message;
            }
//            else
//            {
//                cell.voiceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/%@",message]];
//            }
        }else
        {
            cell.voiceUrl = [[[NSString stringWithFormat:@"%@",message] componentsSeparatedByString:@"/"] lastObject];;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        //        cell.userInteractionEnabled = NO;
        UIImage *bgImage = nil;
        //发送消息
//         if (SCREENWIDTH>320)
//         {
              if (![sender isEqualToString:sendUserID]) {
                   //背景图
                   cell.sender = @"accept";
                   bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
                   [cell.voiceView setFrame:CGRectMake(padding*3.5+5, 18, 12, 17)];
                   [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(padding*2.7, 4, 66, 54)];
                   cell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
                   [cell.voiceTimeLenLable setFrame:CGRectMake(cell.bgImageView.frame.origin.x+cell.bgImageView.frame.size.width+3, 15, 50, 15)];
                   cell.voiceTimeLenLable.textAlignment = NSTextAlignmentLeft;
                   cell.userImageView.image = chatUserImage;
              }else {
                   cell.sender = @"send";
                   bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
                   [cell.voiceView setFrame:CGRectMake(SCREENWIDTH-85, 18,  12, 17)];
                   [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
                   [cell.bgImageView setFrame:CGRectMake(SCREENWIDTH-100-padding, 4 , 66, 54)];
                   cell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
                   cell.userImageView.image = chatUserImage;
                   [cell.voiceTimeLenLable setFrame:CGRectMake(cell.bgImageView.frame.origin.x-55, 15, 50, 15)];
                   cell.voiceTimeLenLable.textAlignment = NSTextAlignmentRight;
              }
         cell.bgImageView.userInteractionEnabled = YES;
         cell.bgImageView.tag = indexPath.row+10000;
         UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceplay:)];
         [cell.bgImageView addGestureRecognizer:tap];
//         }else
//         {
//              if (![sender isEqualToString:sendUserID]) {
//                   //背景图
//                   cell.sender = @"accept";
//                   bgImage = [[UIImage imageNamed:@"BlueBubble2"] stretchableImageWithLeftCapWidth:32 topCapHeight:30];
//                   [cell.voiceView setFrame:CGRectMake(padding*3.5+5, 18, 12, 17)];
//                   [cell.userImageView setFrame:CGRectMake(12, 5, 40, 40)];
//                   [cell.bgImageView setFrame:CGRectMake(padding*2.7, 4, 66, 54)];
//                   cell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
//                   cell.userImageView.image = chatUserImage;
//                   [cell.voiceTimeLenLable setFrame:CGRectMake(cell.bgImageView.frame.origin.x+cell.bgImageView.frame.size.width+3, 15, 30, 15)];
//                   cell.voiceTimeLenLable.textAlignment = NSTextAlignmentLeft;
//              }else {
//                   cell.sender = @"send";
//                   bgImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
//                   [cell.voiceView setFrame:CGRectMake(SCREENWIDTH-85, 18,  12, 17)];
//                   [cell.userImageView setFrame:CGRectMake(SCREENWIDTH-52, 5, 40, 40)];
//                   [cell.bgImageView setFrame:CGRectMake(SCREENWIDTH-100-padding, 4 , 66, 54)];
//                   cell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
//                   cell.userImageView.image = chatUserImage;
//                   [cell.voiceTimeLenLable setFrame:CGRectMake(cell.bgImageView.frame.origin.x-35, 15, 30, 15)];
//                   cell.voiceTimeLenLable.textAlignment = NSTextAlignmentRight;
//              }
//         }
         [cell.nameLabel setFrame:CGRectZero];
         cell.voiceTimeLenLable.text = [NSString stringWithFormat:@"%@''",infocell.timeLen];
        cell.bgImageView.image = bgImage;
        lastVoiceCell = cell;
        cell.isVoicePlaying = NO;
//        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@",time];
        return cell;
    }
    return nil;
}
-(void)voiceplay:(UITapGestureRecognizer*)tap
{
     [voicePlayTimer invalidate];
     nowVoiceCell.isVoicePlaying = NO;
     player1 =nil;
     if ([nowVoiceCell.sender isEqualToString:@"accept"])
     {
          nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
     }else if ([nowVoiceCell.sender isEqualToString:@"send"])
     {
          nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
     }
     NSLog(@"点击");
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag-10000 inSection:0];
     MsgObject *info = [messages objectAtIndex:indexPath.row];
     NSString*type = info.type;
     if ([type isEqualToString:@"sound"])
     {
          ChatMessageCell*cell = (ChatMessageCell*)[tView cellForRowAtIndexPath:indexPath];
          nowVoiceCell = cell;
          NSLog(@"%@",cell.voiceUrl);
          NSError*error = nil;
          if (player1==nil)
          {
               NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
               NSString *mp3FilePath = [voicePath stringByAppendingPathComponent:cell.voiceUrl];
               NSURL*url = [NSURL fileURLWithPath:mp3FilePath];
               player1 = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfURL:url] error:&error];
               [player1 prepareToPlay];
               player1.delegate = self;
               NSLog(@"%@",error);
          }else
          {
               if (player1.isPlaying)
               {
                    [player1 stop];
                    [voicePlayTimer invalidate];
                    if ([nowVoiceCell.sender isEqualToString:@"accept"])
                    {
                         nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
                    }else if ([nowVoiceCell.sender isEqualToString:@"send"])
                    {
                         nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
                    }
                    cell.isVoicePlaying = NO;
                    lastVoiceCell = cell;
                    return;
               }else
               {
                    NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
                    NSString *mp3FilePath = [voicePath stringByAppendingPathComponent:cell.voiceUrl];
                    NSURL*url = [NSURL fileURLWithPath:mp3FilePath];
                    player1 = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
                    [player1 prepareToPlay];
                    player1.delegate = self;
               }
          }
          //        NSLog(@"error==%@",error);
          if (cell.isVoicePlaying==YES)
          {
               cell.isVoicePlaying = NO;
               if (player1.isPlaying)
               {
                    [player1 stop];
                    [voicePlayTimer invalidate];
                    if ([nowVoiceCell.sender isEqualToString:@"accept"])
                    {
                         cell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
                    }else if ([nowVoiceCell.sender isEqualToString:@"send"])
                    {
                         cell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
                    }
               }else
               {
                    [player1 play];
                    if (player1.isPlaying)
                    {
                         dispatch_async(dispatch_get_global_queue(0, 0), ^{
                              voicePlayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(voicePlayTimer) userInfo:nil repeats:YES];
                              [voicePlayTimer fire];
                              [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
                         });
                    }
               }
          }else
          {
               if (player1.isPlaying)
               {
                    [player1 stop];
                    [voicePlayTimer invalidate];
                    if ([nowVoiceCell.sender isEqualToString:@"accept"])
                    {
                         cell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
                    }else if ([nowVoiceCell.sender isEqualToString:@"send"])
                    {
                         cell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
                    }
               }else
               {
                    [player1 play];
                    if (player1.isPlaying)
                    {
                         dispatch_async(dispatch_get_global_queue(0, 0), ^{
                              voicePlayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(voicePlayTimer) userInfo:nil repeats:YES];
                              [voicePlayTimer fire];
                              [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
                         });
                    }
               }
               //            lastVoiceCell.isVoicePlaying = NO;
               cell.isVoicePlaying = YES;
               //            lastVoiceCell = cell;
          }
     }
}
#pragma mark 获取视频的缩略图
-(UIImage *)getImage:(NSURL *)videoURL{
     NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
     AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:opts];
     AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
     gen.appliesPreferredTrackTransform = YES;
//     CMTime time = CMTimeMakeWithSeconds(0.0, 600);
     NSError *error ;
     CMTime actualTime;
     CGImageRef image = [gen copyCGImageAtTime:CMTimeMake(10, 10) actualTime:&actualTime error:&error];
//     NSLog(@"error==%@",error);
     UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
     CGImageRelease(image);
     return thumb;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    MsgObject *info = [messages objectAtIndex:indexPath.row];
    NSString*type = info.type;
    if ([type isEqualToString:@"video"])
    {
        ChatMessageCell*cell = (ChatMessageCell*)[tableView cellForRowAtIndexPath:indexPath];
//        if (cell.isMoviePlaying==YES)
//        {
//            cell.isMoviePlaying = NO;
//            [cell.movieView pause];
//        }else
//        {
//            lastMovieCell.isMoviePlaying = NO;
//            cell.isMoviePlaying = YES;
//            [cell.movieView play];
//            lastMovieCell = cell;
//        }
         NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/voicePath"];
         NSString *mp4FilePath = [voicePath stringByAppendingPathComponent:cell.movieUrl];
         NSURL*url = [NSURL fileURLWithPath:mp4FilePath];
         NSLog(@"%@",url);
         MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:url];
         [self presentMoviePlayerViewControllerAnimated:playerViewController];
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [voicePlayTimer invalidate];
     nowVoiceCell.isVoicePlaying = NO;
     player =nil;
    if ([nowVoiceCell.sender isEqualToString:@"accept"])
    {
        nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
    }else if ([nowVoiceCell.sender isEqualToString:@"send"])
    {
        nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
    }
     
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
     NSLog(@"error=%@",error);
}
-(void)voicePlayTimer
{
    if (player1.isPlaying) {
        static int flagvoiceplay;
        if (flagvoiceplay==3)
        {
            flagvoiceplay=1;
        }else
        {
            flagvoiceplay++;
        }
        if ([nowVoiceCell.sender isEqualToString:@"accept"])
        {
            nowVoiceCell.voiceView.image = [UIImage imageNamed:[NSString stringWithFormat:@"voiceplay_1%d",flagvoiceplay]];
        }else if ([nowVoiceCell.sender isEqualToString:@"send"])
        {
            nowVoiceCell.voiceView.image = [UIImage imageNamed:[NSString stringWithFormat:@"voiceplay_0%d",flagvoiceplay]];
        }
    }else
    {
        [voicePlayTimer invalidate];
        if ([nowVoiceCell.sender isEqualToString:@"accept"])
        {
            nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_13"];
        }else if ([nowVoiceCell.sender isEqualToString:@"send"])
        {
            nowVoiceCell.voiceView.image = [UIImage imageNamed:@"voiceplay_0"];
        }
    }
}
//点击图片进入大图
-(void)imageTap:(UITapGestureRecognizer*)tap
{
//     beginPoint = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    [messageTextView resignFirstResponder];
    UIImageView*image = (UIImageView *)tap.view;
    if (imageBigView==nil)
    {
        imageBigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        imageBigView.userInteractionEnabled = YES;
        imageBigView.backgroundColor = [UIColor blackColor];
        AppDelegate*delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:imageBigView];
        
        UIImageView*imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        imageview.image = image.image;
        imageview.tag = 110;
        imageview.backgroundColor = [UIColor blackColor];
        imageview.userInteractionEnabled = YES;
        imageview.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapCancle)];
        [imageview addGestureRecognizer:tap];
        UIPinchGestureRecognizer*pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
        [imageview addGestureRecognizer:pinch];
         UIPanGestureRecognizer*pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
         [imageview addGestureRecognizer:pan];
         
        [imageBigView addSubview:imageview];
    }else
    {
        UIImageView*imageview = (UIImageView*)[imageBigView viewWithTag:110];
        imageview.image = image.image;
        imageview.transform = CGAffineTransformMakeScale(1, 1);
         imageview.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        [imageBigView setHidden:NO];
    }
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
}
//大图退出
-(void)imageTapCancle
{
      [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [imageBigView setHidden:YES];
}
//图片捏合
-(void)pinchAction:(UIPinchGestureRecognizer*)sender
{
    UIImageView*imageview = (UIImageView*)[imageBigView viewWithTag:110];
    imageview.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
}
#pragma mark 拖拽
-(void)panAction:(UIPanGestureRecognizer*)sender
{
     UIImageView*imageview = (UIImageView*)[imageBigView viewWithTag:110];
     if (sender.state == UIGestureRecognizerStateBegan)
     {
          beginPoint = [sender translationInView:imageview];
     }
     
     CGPoint nowPoint = [sender translationInView:imageview];
     float offX = nowPoint.x - beginPoint.x;
     float offY = nowPoint.y - beginPoint.y;
     imageview.center = CGPointMake(imageview.center.x+offX, imageview.center.y+offY);
     beginPoint = nowPoint;
     
}

#pragma mark 图片大小尺寸
//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark KKMessageDelegate
-(void)newMessageReceived:(NSDictionary *)messageCotent{
    
    [messages addObject:messageCotent];
    
    [self.tView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [tView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-( AppDelegate*)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
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
