//
//  VedioModel.h
//  YiQiWeb
//
//  Created by wendy on 14/12/12.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, State) {
    NoneState = 0,
    Uploading = 1,    //正在上传
    UploadFinish = 2, //已上传
    Downloading = 3,  //下载中
    DownloadFinish = 4,//已下载
};

@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *v_Id;
@property (nonatomic, copy) NSString *v_Name;
@property (nonatomic, copy) NSString *v_Url;
@property (nonatomic, assign) NSInteger v_timeScale;
@property (nonatomic, copy) NSData *v_imageData;
@property (nonatomic, assign) NSInteger v_State;
@property (nonatomic, copy) NSString *v_OperationTime;
@property (nonatomic, assign) double v_PlayTime;
@property (nonatomic) float progress;
@property (nonatomic) float sumMemory;
@property (nonatomic) float downloadMemory;
@property (nonatomic, assign) NSInteger errorIndex;
@property (nonatomic, assign) NSInteger downLoadId;


+(NSString *) addVideoModel:(VideoModel *) model;
+(VideoModel *) getInfoById : (NSString *) videoId;
+(NSMutableArray *)getAllVideoInfo;
+(BOOL) deleteVideoModel:(NSString *) videoId;
+(NSMutableArray *) getAllVideoInfoByID : (int) state;
+(BOOL) updatePlayTime : (double) playTime withID : (NSString *) videoId;
//上传完成操作
+(BOOL) updateInfoWhenUploadFinish : (VideoModel *) model;
+(BOOL) updateInfoWhenUploadFail:(VideoModel *) model;
+(NSMutableDictionary *) getAllUploadVideoInfo : (int) updateState And :(int)updateFinish;
//下载后修改isDownLoad
+(BOOL) updateDownLoad:(VideoModel *) model;
//判断是否存在上传视频名
+(BOOL) isExistsUploadVideoName :(NSString *) name;


//检测设备是否为iPad
+ (BOOL)iPad;
@end
