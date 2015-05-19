//
//  VoiceCollectModel.h
//  Yiqikudong
//
//  Created by wendy on 15/4/29.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  音频收藏实体
 */
@interface VoiceCollectModel : NSObject

/**
 *  录音的ID
 */
@property (nonatomic,strong ) NSString  *voiceId;
/**
 *  录音的种类
 */
@property (assign, nonatomic) NSInteger voiceClassId;
/**
 *  录音的类型（普通1 MV 2）
 */
@property (assign, nonatomic) NSInteger voiceType;
/**
 *  录音名称
 */
@property (nonatomic,strong ) NSString  *voiceName;
/**
 *  音频的url
 */
@property (nonatomic,strong ) NSString  *voiceUrl;
/**
 *  录音携带的图片的url
 */
@property (nonatomic,strong ) NSData    *voicePic;
/**
 *  录音的时长
 */
@property (nonatomic,strong ) NSString  *voiceSumTime;
/**
 *  音频大小
 */
@property (nonatomic        ) float     total;
/**
 *  录音的发布者
 */
@property (nonatomic,strong ) NSString  *voiceAuthor;
/**
 *  录音的创建时间(上传时间)
 */
@property (nonatomic,strong ) NSString  *createTime;
/**
 *  录音的播放次数
 */
@property (nonatomic,strong ) NSString  *playSumCount;
/**
 *  图片路径
 */
@property (nonatomic,strong ) NSString  *picPath;
/**
 *  用户ID
 */
@property (nonatomic, strong) NSString    *userId;

/**
 *  判断是否存在音频
 *
 *  @param url 音频URL
 *
 *  @return
 */
+(BOOL) isExistsCollectUrl:(NSString *)url;

/**
 *  增加播放记录
 *
 *  @param model
 *
 *  @return
 */
+(NSString *) addVoiceCollectInfo:(VoiceCollectModel *) model;

/**
 *  删除收藏音频信息
 *
 *  @param url 音频url
 *
 *  @return 
 */
+(BOOL)deleteVoiceCollect:(NSString *)url;

+(NSMutableArray*)getVoiceCollection;
@end
