//
//  DealData.h
//  YiQiWeb
//
//  Created by BK on 14/12/26.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ReminderView.h"
#import "SqlServer.h"
#import "FMDB.h"
#import "VideoInfo.h"
#import "VoiceInfo.h"

@interface DealData : NSObject
{
    UIViewController*viewcontroller;
    NSString*sqlitePath;//数据库文件路径
}
+(DealData*)dealDataClass;

-(void)videoNotification:(UIViewController*)view withPlayer:(MPMoviePlayerViewController*)player;
-(float)selectVideo:(NSString*)contentURL;
-(void)saveVideo:(VideoInfo*)info;
-(NSArray*)getVideoData;


//保存刚录完的音
-(void)saveVoice:(VoiceInfo*)info;
-(NSMutableArray*)getVoiceData;
-(void)deleteVoice:(NSString*)str;

//保存正在上传的录音信息
-(void)saveUploadVoice:(VoiceInfo*)info;
-(NSMutableArray*)getUploadVoiceData;
//删除已经上传完的录音的数据库信息
-(void)deleteUploadVoice:(NSString*)str;

//保存已上传录音信息
-(void)saveUploadedVoice:(VoiceInfo*)info;
-(NSMutableArray*)getUploadedVoiceData;
-(void)deleteUploadedVoice:(NSString*)str;

//保存已下载录音信息
-(void)saveDownloadVoice:(VoiceInfo*)info;
-(NSMutableArray*)getDownloadVoiceData;
-(void)deleteDownloadVoice:(NSString*)str;

//保存正在下载录音信息
-(void)saveDownloadingVoice:(VoiceInfo*)info;
-(NSMutableArray*)getDownloadingVoiceData;
-(void)deleteDownloadingVoice:(NSString*)str;

//检测设备是否为iPad
-(BOOL)iPad;
@end
