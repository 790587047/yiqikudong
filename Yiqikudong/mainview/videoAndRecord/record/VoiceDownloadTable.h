//
//  VoiceDownloadTable.h
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoicePlayView.h"
@interface VoiceDownloadTable : UITableView<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    AVAudioPlayer*player;
    
    VoicePlayView*playView;
    NSTimer*timer;
}
@property(nonatomic,retain)NSArray*infoArray;
@end
