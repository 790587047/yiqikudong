//
//  VideoView.h
//  YiQiWeb
//
//  Created by BK on 14/12/23.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionReusableCell.h"
#import "CollectionReusableView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DownOrUploadView.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "ReminderView.h"
#import "DealData.h"

@interface VideoView : BaseController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *location;
    
    NSMutableArray*array1;//存储已下载视频的第一帧图片
    NSMutableArray*array2;//存储正在下载视频的第一帧图片
    NSMutableArray*array3;//存储已下载视频的本地本地链接
    NSMutableArray*array4;//存储正在下载视频的链接
    NSMutableArray*array5;//存储已下载视频的第一帧图片
    NSMutableArray*array6;//存储已下载视频的第一帧图片
//    MPMoviePlayerController*movie;
//    int flag;
    
    BOOL isplaying;
    AFHTTPRequestOperation*downloadRequest;
    AFHTTPRequestOperationManager*manager;
//    BOOL isplay;
}
@end
