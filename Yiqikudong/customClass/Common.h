//
//  Common.h
//  Yiqikudong
//
//  Created by wendy on 15/3/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//图片处理
+(NSData *) dealImage : (NSData *) data;

//压缩图片
+(UIImage *)scaleToSize:(UIImage *)img width:(int)width height:(int) height;

//显示提示信息
+(void) showMessage:(NSString *) msg withView:(UIView *)view;

//删除文件
+(void)deleteFile : (NSString *) path;

//获取视频的缩略图
+(UIImage *)getImage:(NSURL *)videoURL;

//获取时长
+(CGFloat) getVideoLength:(NSURL *)movieURL;

//获取当前时间
+(NSString *)getCurrentDate : (NSString *) dateFormat;
/**
 *
 *
 *  @param url 音频的Url
 *
 *  @return 返回播放时间字符串
 */
+(NSString *) getVoiceTimeLength:(NSURL *) url;

/**
 *  日期格式处理
 *
 *  @param dateTime 要处理的日期
 *
 *  @return 固定格式的日期
 */
+(NSString *) dealDateTime:(NSString *) dateTime;

/**
 *  计算当前日期和创建日期的时间差
 *
 *  @param inDay 时间
 *
 *  @return 时间差
 */
+(NSString *) getTimeDifference:(NSString *) inDay;
@end
