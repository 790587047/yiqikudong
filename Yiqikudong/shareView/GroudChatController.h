//
//  ChatController.h
//  Yiqikudong
//
//  Created by BK on 15/3/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "KKMessageDelegate.h"
#import "Photo.h"
#import "CaptureViewController.h"
#import "PlayViewController.h"
#import "ChatMessageCell.h"
#import "AFNetworking.h"
#import "GroudMemberView.h"
#import "GroudSetView.h"
#import "GroudApplyView.h"
#import "GroudCreateView.h"
#import "GroudApplyListView.h"
@interface GroudChatController : BaseController<UITableViewDelegate, UITableViewDataSource,  KKMessageDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    NSMutableArray *messages;
    UIView*baseView;
    int flag;//标识是否点击了语音按钮
    int flag1;//标识是否点击了表情按钮
    int flag2;//标识点击了more按钮
    int swipeflag;//标识聊天界面正在滑动
    UIButton*swipeBtn;//滑动时如果收到新消息会提示
    
    UIButton*sendBtn;
    UIButton*voiceBtn;//最左边的点击录音按钮
    UIButton*voiceRecordBtn;//点击录音按钮后出现的录制按钮
    UIButton*faceBtn;
    NSRange cursorPosition;//选择表情时textview的光标所在位置
    CGSize kbSize;//键盘大小
    
    UIButton*moreBtn;
    UIView*moreView;
    
    //表情界面
    UIView*faceView;
    UIScrollView*faceScroll;
    UIPageControl*pageControl;
    NSArray*faceArray;
    
    //监测文本输入的计时器
    NSTimer*timer;
    UIView*imageBigView;
    UIView*videoView;
    ChatMessageCell*lastMovieCell;
    
    
    //视频的类
//    AVCaptureSession*_session;
//    AVCaptureVideoPreviewLayer*_preview;
//    AVCaptureConnection*_videoConnection;
//    AVCaptureConnection*_audioConnection;
    UIImagePickerController *imagePicker;
    UILabel *lblTime;
    UIButton *btnPlay;
    dispatch_source_t _timer;
    
    dispatch_queue_t queue;
    
    //录音的类
    AVAudioRecorder *recorder;
    NSTimer*timerVoice;
    NSURL *tmpvoiceFile;
    int sumTime;
    NSString*filname;
    AVAudioPlayer*player1;
    BOOL flagRecord;//标记是否在录音
    BOOL finishRecord;//标记是否完成录音
    BOOL cancalRecord;//标记是否中间取消录音
    ChatMessageCell*lastVoiceCell;
    ChatMessageCell*nowVoiceCell;
    //播放录音时的计时器
    NSTimer *voicePlayTimer;
    
//    AFHTTPRequestOperationManager*manager;
    
    //实时获取聊天记录的timer
    NSTimer*talkTimer;
    int messegePage;
    CGPoint beginPoint;
    int scrollFlag,scrollY,loadMoreFlag;
}
@property (strong, nonatomic) UITableView *tView;
@property (strong, nonatomic) UITextView *messageTextView;
@property(nonatomic, retain) NSString *chatWithUser;
@property(nonatomic,retain)NSMutableArray*msgArray;
@property(nonatomic,retain)NSString*sendUserID;
@property(nonatomic,retain)NSString*receiverUserID;
@property(nonatomic,retain)NSString*maxID;
@property(nonatomic,retain)NSString*chatID;
@property(nonatomic,retain)UIImage*chatUserImage;
@property(nonatomic,retain)NSString*ID;

@property(nonatomic,retain)UIViewController*chatListController;
@end
