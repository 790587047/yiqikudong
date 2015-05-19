//
//  VoiceHistoryModel.m
//  Yiqikudong
//
//  Created by wendy on 15/4/29.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VoiceHistoryModel.h"

@implementation VoiceHistoryModel

+(NSString *) getDataBasePath {
    //获取数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    return filePath;
}

+(NSString *)addVoiceHistoryModel:(VoiceHistoryModel *)model{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    NSString *vId;
    if (db.open) {
        BOOL result = [db executeUpdate:@"INSERT INTO voiceHistory(voiceName,URL,SUMTIME,TOTAL,CREATETIME,AUTHOR,IMAGEDATA,CLASSID,TYPE,playSumCount,picPath,userId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?);",model.voiceName,model.voiceUrl,model.voiceSumTime,[NSNumber numberWithFloat:model.total],model.createTime,model.voiceAuthor,model.voicePic,[NSNumber numberWithInteger:model.voiceClassId],[NSNumber numberWithInteger:model.voiceType],model.playSumCount,model.picPath,model.userId];
        if (result) {
            NSLog(@"添加数据成功");
            vId = [NSString stringWithFormat:@"%lld",[db lastInsertRowId]];
        }
        else{
            NSLog(@"添加数据失败");
            vId = @"";
        }
    }
    return vId;
}

+(BOOL)isExistsUrl:(NSString *)url{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    BOOL flag = false;
    if (db.open) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceHistory WHERE URL = ?",url];
        if (rs.next) {
            flag = true;
        }
        [rs close];
    }
    return flag;
}

+(BOOL) insertHistory:(VoiceHistoryModel *) model{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDataBasePath]];
    __block BOOL result = false;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceHistory WHERE URL = ?",model.voiceUrl];
        if (rs.next) {
            result = [db executeUpdate:@"UPDATE voiceHistory SET CREATETIME = ? WHERE ID = ?",model.createTime,[NSNumber numberWithInt:[rs intForColumn:@"ID"]]];
        }
        else{
            result = [db executeUpdate:@"INSERT INTO voiceHistory(voiceName,URL,SUMTIME,TOTAL,CREATETIME,AUTHOR,IMAGEDATA,CLASSID,TYPE,playSumCount,picPath,userId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?);",model.voiceName,model.voiceUrl,model.voiceSumTime,[NSNumber numberWithFloat:model.total],model.createTime,model.voiceAuthor,model.voicePic,[NSNumber numberWithInteger:model.voiceClassId],[NSNumber numberWithInteger:model.voiceType],model.playSumCount,model.picPath,model.userId];
        }
        [rs close];
        if (result) {
            NSLog(@"数据更新成功");
        }
        else{
             NSLog(@"更新数据失败");
            
        }
    }];
    return result;
}

+(BOOL)deleteVoiceHistory:(NSString *)url{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        BOOL result = [db executeUpdate:@"DELETE FROM voiceHistory WHERE url = ?",url];
        if (result) {
            NSLog(@"删除成功");
            return true;
        }
        else{
            NSLog(@"删除失败");
            return false;
        }
    }
    NSLog(@"数据库打开失败");
    return false;
}
+(BOOL) deleteAllVoiceHistory{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        BOOL result = [db executeUpdate:@"DELETE FROM voiceHistory WHERE USERID = ?"];
        if (result) {
            NSLog(@"删除成功");
            return true;
        }
        else{
            NSLog(@"删除失败");
            return false;
        }
    }
    NSLog(@"数据库打开失败");
    return false;
}
+(NSMutableArray *)getVoiceHistory
{
    FMDatabase*dataBase = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from voiceHistory"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*voiceId = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"ID"]];
        NSInteger voiceClassId = [resultSet stringForColumn:@"CLASSID"].integerValue;
        NSInteger voiceType = [resultSet stringForColumn:@"TYPE"].integerValue;
        NSString*voiceName = [resultSet stringForColumn:@"voiceName"];
        NSString*voiceUrl = [resultSet stringForColumn:@"URL"];
        NSData*voicePic = [resultSet dataForColumn:@"IMAGEDATA"];
        NSString*voiceSumTime = [resultSet stringForColumn:@"SUMTIME"];
        float total = [resultSet doubleForColumn:@"TOTAL"];
        NSString*voiceAuthor = [resultSet stringForColumn:@"AUTHOR"];
        NSString*createTime = [resultSet stringForColumn:@"CREATETIME"];
        NSString*playSumCount = [resultSet stringForColumn:@"playSumCount"];
        NSString*picPath = [resultSet stringForColumn:@"picPath"];
        //        NSLog(@"%@",state.class);
        VoiceHistoryModel*info = [[VoiceHistoryModel alloc]init];
        info.voiceId = voiceId;
        info.voiceClassId = voiceClassId;
        info.voiceType = voiceType;
        info.voiceName = voiceName;
        info.voiceUrl = voiceUrl;
        info.voicePic = voicePic;
        info.voiceSumTime = voiceSumTime;
        info.total = total;
        info.voiceAuthor = voiceAuthor;
        info.createTime = createTime;
        info.playSumCount = playSumCount;
        info.picPath = picPath;
        [infoArray addObject:info];
    }
    [dataBase close];
    return (NSMutableArray*)[[infoArray reverseObjectEnumerator]allObjects];
}
@end
