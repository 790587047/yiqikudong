//
//  VoiceDownloadingTable.h
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceDownloadingCell.h"
#import "VoiceDownloadCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "VoicePlayView.h"
@interface VoiceDownloadingTable : UITableView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    NSMutableArray*infoArray1;
    NSMutableArray*info1Array1;
    int flag,flag1;
    
    AVAudioPlayer*player;
    VoicePlayView*playView;
    NSTimer*timer;
}
@property(nonatomic,retain)NSMutableArray*infoArray;
@property(nonatomic,retain)NSMutableArray*info1Array;//已下载

@end
