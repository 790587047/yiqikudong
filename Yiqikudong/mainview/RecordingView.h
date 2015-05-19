//
//  RecordingView.h
//  亿启FM
//
//  Created by BK on 15/3/3.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceInfo.h"
#import "ViewForRecordMeters.h"
#import "UserCenterController.h"
#import "ClassifyViewController.h"
#import "VideoViewController.h"
#import "VideoModel.h"
#import "Common.h"
@interface RecordingView : UserCenterController<AVAudioRecorderDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    UILabel*timeLabel;
    UIPageControl*pageControl;
    
    AVAudioRecorder *recorder;
    NSURL *tmpFile;
    BOOL flag;
    NSTimer*timer;
    UIButton*beforeBtn;
    
    int sumTime;
    VoiceInfo*voiceInfo;
    
    BOOL flagRecord;
    int page;
    UIScrollView*scroll;
    
    UIImagePickerController *imagePicker;
    dispatch_source_t _timer;
    ReminderView *indicator;
    VideoModel *videoModel;
    UIButton*MVmodel;
}
@property(nonatomic,retain)ViewForRecordMeters*viewRecording;
@property(nonatomic,retain)NSString*kind;
//@property(nonatomic, strong) ViewForRecording *recordView;
@property(nonatomic,retain)NSMutableArray*averagePowerArray;
@property(nonatomic,retain)NSMutableArray*peakPowerArray;

@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIButton *btnPlay;
@end
