//
//  VoiceObject.h
//  Yiqikudong
//
//  Created by BK on 15/3/20.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceObject : NSObject

/**
 *  录音的ID
 */
@property (nonatomic,strong ) NSString    *voiceId;
/**
 *  录音的种类
 */
@property (assign, nonatomic) NSInteger   voiceClassId;
/**
 *  录音的类型（普通1 MV 2）
 */
@property (assign, nonatomic) NSInteger   voiceType;
/**
 *  录音名称
 */
@property (nonatomic,strong ) NSString    *voiceName;
/**
 *  音频的url
 */
@property (nonatomic,strong ) NSString    *voiceUrl;
/**
 *  录音携带的图片的url
 */
@property (nonatomic,strong ) NSData      *voicePic;
/**
 *  录音的发布者
 */
@property (nonatomic,strong ) NSString    *voiceAuthor;
/**
 *  录音的创建时间(上传时间)
 */
@property (nonatomic,strong ) NSString    *createTime;
/**
 *  录音的播放次数
 */
@property (nonatomic,strong ) NSString    *playSumCount;
/**
 *  是否正在上传
 */
@property (nonatomic        ) BOOL        uploadingFlag;
/**
 *  标识是否已经下载过
 */
@property (nonatomic        ) BOOL        downloadFlag;
/**
 *  标识是否正在下载
 */
@property (nonatomic        ) BOOL        downloadingFlag;
/**
 *  标识是否已收藏
 */
@property (nonatomic        ) BOOL        collectFlag;
/**
 *  录音的时长
 */
@property (nonatomic,strong ) NSString    *voiceSumTime;
/**
 *  音频大小
 */
@property (nonatomic        ) float        total;
/**
 *  图片路径
 */
@property (nonatomic,strong ) NSString     *picPath;
/**
 *  下载时间
 */
@property (nonatomic,strong ) NSString    *downloadTime;
/**
 *  用户ID
 */
@property (nonatomic, strong) NSString    *userId;


//增加音频上传信息
+(NSString *) addVoiceModel:(VoiceObject *) model;

//读取所有上传信息
+(NSMutableArray *) getAllVoiceUploadInfo;

//更新数据（上传成功）
+(BOOL) updateUploadedInfo:(VoiceObject *) obj;

//删除音频信息
+(BOOL) deleteVoiceObject : (NSString *) vId;

/**
 *  我的声音音频删除（如果下载过的就更新）
 *
 *  @param vId <#vId description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)deleteVoiceInfo:(NSString *)vId;

//设置为正在下载状态
+(BOOL) updateDownloadingState:(VoiceObject *) obj;

//获取正在下载的数据
+(NSMutableArray *) getDownloadingInfo;

//更改状态（已完成下载）
+(BOOL) updateDownloadState:(VoiceObject *) obj;

+(BOOL) updateDownLoadedState:(VoiceObject *) obj;

//获取已下载信息
+(NSMutableArray *) getDownLoadedInfo;

/**
 *  根据url判断是否存在该音频（下载的音频）
 *
 *  @param url 音频的URL
 *
 *  @return 
 */
+(BOOL) isExistsDownLoadUrl:(NSString *) url;

/**
 *  播放的时候向服务器发送播放次数加1的请求。
 *
 *  @param ID 录音的ID
 */
+(void)sendAddPlayNumber:(NSString*)ID;
/**
 *  根据关键字获取到搜索的信息
 *
 *  @param keyWord 关键字
 *
 *  @return 返回获取到的信息
 */
+(NSMutableArray*)getSearchResultWithKeyWord:(NSString*)keyWord  withPage:(int)page;
@end
