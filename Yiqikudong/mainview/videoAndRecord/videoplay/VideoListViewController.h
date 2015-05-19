//
//  VideoListViewController.h
//  YiQiWeb
//
//  Created by wendy on 15/1/16.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownOrUploadView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "Mp3EncodeClient.h"
#import "VoiceDownloadTable.h"
#import "VoiceDownloadingTable.h"
#import "UploadVoiceTable.h"
#import "UploadView.h"
#import "VideoDownLoadViewController.h"

@interface VideoListViewController : BaseController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AVAudioRecorderDelegate>{
    UISegmentedControl*segment;
    int whichBtn1,whichBtn2;
    UITextView*textview;
    AVAudioRecorder *recorder;
    NSURL *tmpFile;
    
    
    UIButton *sayBeginBtn;
    UIButton *sayEndBtn;
    
    Mp3EncodeClient *mp3EncodeClient;
    
    UploadVoiceTable*uploadVoiceTable;
    VoiceInfo*downloadInfo;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *btnDownLoadFinish;
@property (strong, nonatomic) UIButton *btnDownLoading;
@property (strong, nonatomic) UIButton *btnUpload;
@property (strong, nonatomic) UIButton *btnUploadVideo;

@property (strong, nonatomic) UIView *dataView;
@property (strong, nonatomic) UIView *uploadView;
@property (strong, nonatomic) UIView *finishDownView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *downingView;

//录音界面
@property(strong, nonatomic) UIView *voiceView;

@property (nonatomic, assign) BOOL setToStopped;
@property (nonatomic, assign) NSMutableArray *recordQueue;


@property(nonatomic,retain)NSString*kind;

@property (strong, nonatomic) VideoDownLoadViewController *viewController;

@property BOOL isTakeVideoView;

@end
