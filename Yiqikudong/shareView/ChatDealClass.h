//
//  ChatDealClass.h
//  Yiqikudong
//
//  Created by BK on 15/3/24.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MsgObject.h"
#import "AFNetworking.h"
#import "Statics.h"
#import "Photo.h"
#import "UserObject.h"
@interface ChatDealClass : NSObject
{
    NSString*sqlitePath;//数据库文件路径
}
+(ChatDealClass*)dealDataClass;

//最近联系人
-(void)saveLinkMan:(NSMutableArray*)array;//通过服务器返回的最近联系人和本地的对比进行保存
-(NSMutableArray*)getListMan;//获取最近联系人列表
-(NSMutableArray*)rankMan:(NSMutableArray*)array;//根据最近信息的时间排序最近联系人
-(void)deleteMan:(NSString*)ID;//根据id删除用户，接口未做
//更新maxid
-(void)changeManMaxID:(NSString*)maxID chatID:(NSString*)chatID;
//更新msg
-(void)changeManMsg:(NSString*)msg chatID:(NSString*)chatID;
//更新time
-(void)changeManTime:(NSString*)time chatID:(NSString*)chatID;
-(void)changeManTime:(NSString *)time chatUserID:(NSString *)chatID;
//文件信息由url改成data
-(void)changePic:(NSData*)data chatID:(NSString*)chatID;
//修改未读信息的状态为已读
-(void)changeState:(NSString*)state chatID:(NSString*)chatID;

//群
-(NSMutableArray*)getGroud;//获取群列表


//删除与某个人的全部聊天记录
-(void)deleteManMSG:(NSString *)ID;
//保存聊天记录
-(void)saveMsg:(MsgObject*)info;
-(NSMutableArray*)getMsgData:(NSString*)chatID withPage:(int)page;
-(void)deleteMsg:(NSString*)str;
//文件信息由url改成data
-(void)changeMsgID:(NSString*)ID newData:(id)data;
//获取本地已经存在的文件并删除
-(NSString*)deleteDataWithMsgID:(NSString*)ID;

//发送文本信息
+(BOOL)sendMessege:(NSString*)message sendID:(NSString*)sendID receiverID:(NSString*)receiverID isGroup:(int)isGroup;
//发送文件信息
+(void)sendMessege:(NSData*)message withSumtime:(NSString*)sumtime type:(NSString*)type sendID:(NSString*)sendID receiverID:(NSString*)receiverID isGroup:(int)isGroup withBlock:(void (^)(AFHTTPRequestOperation *operation))block;
//检测新信息，有就返回，无则返回空
+(NSDictionary*)getNewMessegesID:(NSString*)ChatMaxID sendID:(NSString*)sendID receiverID:(NSString*)receiverID;
//
//
//处理返回的信息字典成为指定类型的数组
+(NSMutableArray*)dictionary:(NSDictionary*)dict withSendID:(NSString *)sendID;
//发送已读通知
-(void)sendMSGID:(NSString*)ID;


//发送修改群资料的请求
-(void)changeGroudSet:(NSDictionary*)dict withGroudID:(NSString*)ID;
//发送添加或删除群成员请求
-(void)addOrDeleteMember:(NSArray*)array withGroudID:(NSString*)ID;
//发送退群请求
-(void)exitGroudwithGroudID:(NSString*)ID;
//发送同意或拒绝加群审核
-(void)sebdCheckResult:(NSDictionary*)dict withGroudID:(NSString*)ID;
//发送建群请求
-(void)sendCreateGroud:(NSDictionary*)dict withOwnerID:(NSString*)ID;
////发送修改群资料的请求
//-(void)changeGroudSet:(NSDictionary*)dict withGroudID:(NSString*)ID;

@end
