//
//  DownOrUploadView.h
//  YiQiWeb
//
//  Created by BK on 14/12/26.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "BaseController.h"
#import "VideoInfo.h"
#import "AFHTTPRequestOperationManager.h"
#import "DownloadCell.h"
@interface DownOrUploadView : BaseController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{

    NSMutableArray*array1;//存储正在下载的视频的信息
    NSMutableArray*array2;//存储正在下载视频的第一帧图片
    NSMutableArray*array3;//存储正在下载的下载实体对象
    
    
    BOOL isplaying;
//    AFHTTPRequestOperation*downloadRequest;
//    AFHTTPRequestOperationManager*manager;
    int flag;
}
@property(nonatomic,retain)UITableView*tableList;
@property(nonatomic,retain)NSMutableArray*array4;//存储正在下载视频的链接
@end
