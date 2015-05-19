//
//  LocalVoiceView.h
//  YiQiWeb
//
//  Created by BK on 15/1/8.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalVoiceCell.h"
#import "VoicePlayView.h"
#import "VoiceListView.h"
@interface LocalVoiceView : BaseController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    NSMutableArray*localVoiceArray;
    NSMutableArray*localVoiceArray1;
    NSMutableArray*uploadedArray;
    NSMutableArray*uploadedArray1;
    NSMutableArray*uploadingArray;
    NSMutableArray*uploadingArray1;
    
    AVAudioPlayer*player;
    int flag,flag1,flag2;
    
    VoicePlayView*playView;
    NSTimer*timer;
    NSIndexPath* selectedIndexPath;
    
    
    NSMutableArray*voicesArray;
    NSMutableArray*numArray;
    
    AFHTTPRequestOperationManager*manager;
    NSMutableArray*array1;//存储正在上传的视频的信息
    NSMutableArray*array2;//存储正在上传的上传实体对象
}
@property(nonatomic,strong)UITableView*tableview;
@property(nonatomic,retain)NSString*kind;
@end
