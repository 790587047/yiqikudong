//
//  MsgObject.h
//  Yiqikudong
//
//  Created by BK on 15/3/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgObject : NSObject
@property (nonatomic,retain) NSNumber*  messageNo;//序列号，数值型
@property (nonatomic,retain) NSString*  ID;//消息在数据库中的编号
@property (nonatomic,retain) NSString*  type;//消息类型
@property (nonatomic,retain) NSString*  chatID;//会话ID,查询私聊信息的标准
@property (nonatomic,retain) NSString*  messageId;//消息标识号，字符串
@property (nonatomic,retain) NSString*  maxID;//最新消息标识号，字符串，请求新信息的标准
@property (nonatomic,retain) NSString*  fromUserId;//源
@property (nonatomic,retain) NSString*  toUserId;//目标
@property (nonatomic,retain) id  content;//内容
@property (nonatomic,retain) NSNumber*  fileSize;//文件尺寸
@property (nonatomic,retain) NSString*  timeLen;//录音时长
@property (nonatomic,retain) NSNumber*  location_x;//位置经度
@property (nonatomic,retain) NSNumber*  location_y;//位置纬度
@property (nonatomic,retain) NSString*    time;//时间
//@property (nonatomic,retain) NSDate*    timeReceive;//时间
@property (nonatomic,retain) NSData*    fileData;//文件内容
@property (nonatomic,assign) BOOL       isGroup;//是否群聊
@end
