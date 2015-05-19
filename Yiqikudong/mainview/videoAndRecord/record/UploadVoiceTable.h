//
//  UploadVoiceTable.h
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoicePlayView.h"
#import "AFHTTPRequestOperationManager.h"
#import "VoiceInfo.h"
@interface UploadVoiceTable : UITableView<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    NSMutableArray*infoUploading1Array;
    NSMutableArray*infoUpload1Array;
    int flag,flag1;
    
    AVAudioPlayer*player;
    
    VoicePlayView*playView;
    NSTimer*timer;
    
    AFHTTPRequestOperationManager*manager;
    NSMutableArray*array1;//存储正在下载的视频的信息
    NSMutableArray*array2;//存储正在下载的下载实体对象
}
@property(nonatomic,retain)NSMutableArray*infoUploadingArray;
@property(nonatomic,retain)NSMutableArray*infoUploadArray;

@end
