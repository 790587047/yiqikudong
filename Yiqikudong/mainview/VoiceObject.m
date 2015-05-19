//
//  VoiceObject.m
//  Yiqikudong
//
//  Created by BK on 15/3/20.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "VoiceObject.h"
#import "FMDB.h"
#import "Common.h"
@implementation VoiceObject

-(id) copyWithZone:(NSZone *)zone{
    VoiceObject *obj = [VoiceObject allocWithZone:zone];
    obj.voiceId         = self.voiceId;
    obj.voiceAuthor     = self.voiceAuthor;
    obj.uploadingFlag   = self.uploadingFlag;
    obj.voiceClassId    = self.voiceClassId;
    obj.voiceName       = self.voiceName;
    obj.voicePic        = self.voicePic;
    obj.voiceSumTime    = self.voiceSumTime;
    obj.voiceType       = self.voiceType;
    obj.voiceUrl        = self.voiceUrl;
    obj.downloadFlag    = self.downloadFlag;
    obj.downloadingFlag = self.downloadingFlag;
    obj.downloadTime    = self.downloadTime;
    obj.createTime      = self.createTime;
    obj.picPath         = self.picPath;
    obj.playSumCount    = self.playSumCount;
    obj.collectFlag     = self.collectFlag;
    obj.total           = self.total;
    return obj;
}

-(void) encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.voiceId forKey:@"voiceId"];
    [coder encodeObject:self.voiceAuthor forKey:@"voiceAuthor"];
    [coder encodeInteger:self.uploadingFlag forKey:@"uploadingFlag"];
    [coder encodeInteger:self.voiceClassId forKey:@"voiceClassId"];
    [coder encodeObject:self.voiceName forKey:@"voiceName"];
    [coder encodeObject:self.voicePic forKey:@"voicePic"];
    [coder encodeObject:self.voiceSumTime forKey:@"voiceSumTime"];
    [coder encodeInteger:self.voiceType forKey:@"voiceType"];
    [coder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    [coder encodeInteger:self.downloadFlag forKey:@"downloadFlag"];
    [coder encodeInteger:self.downloadingFlag forKey:@"downloadingFlag"];
    [coder encodeObject:self.downloadTime forKey:@"downloadTime"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
    [coder encodeObject:self.picPath forKey:@"picPath"];
    [coder encodeObject:self.playSumCount forKey:@"playSumCount"];
//    [coder encodeBool:self.collectFlag forKey:@"collectFlag"];
    [coder encodeFloat:self.total forKey:@"collectFlag"];
}

-(id) initWithCoder:(NSCoder *) coder{
    _voiceId         = [[coder decodeObjectForKey:@"voiceId"] copy];
    _voiceAuthor     = [[coder decodeObjectForKey:@"voiceId"] copy];
    _uploadingFlag   = [coder decodeIntegerForKey:@"uploadingFlag"];
    _voiceClassId    = [coder decodeIntegerForKey:@"voiceClassId"];
    _voiceName       = [[coder decodeObjectForKey:@"voiceName"]copy];
    _voicePic        = [[coder decodeObjectForKey:@"voicePic"]copy];
    _voiceSumTime    = [[coder decodeObjectForKey:@"voiceSumTime"] copy];
    _voiceType       = [coder decodeIntegerForKey:@"voiceType"];
    _voiceUrl        = [[coder decodeObjectForKey:@"voiceUrl"]copy];
    _downloadFlag    = [coder decodeIntegerForKey:@"downloadFlag"];
    _downloadingFlag = [coder decodeIntegerForKey:@"downloadingFlag"];
    _downloadTime    = [[coder decodeObjectForKey:@"downloadTime"]copy];
    _createTime      = [[coder decodeObjectForKey:@"createTime"] copy];
    _picPath         = [[coder decodeObjectForKey:@"picPath"] copy];
    _playSumCount    = [[coder decodeObjectForKey:@"playSumCount"] copy];
//    _collectFlag     = [coder decodeBoolForKey:@"collectFlag"];
    _total           = [coder decodeFloatForKey:@"total"];
    return self;
}

+(NSString *) getDataBasePath {
    //获取数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    return filePath;
}

+(NSString *)addVoiceModel:(VoiceObject *)model{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    NSString *vId;
    if (db.open) {
        BOOL result = [db executeUpdate:@"INSERT INTO voiceUpload(voiceName,URL,SUMTIME,TOTAL,CREATETIME,AUTHOR,IMAGEDATA,CLASSID,TYPE,uploadingFlag,downloadFlag,downloadingFlag,collectFlag,playSumCount,USERID,downloadTime) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",model.voiceName,model.voiceUrl,model.voiceSumTime,[NSNumber numberWithFloat:model.total],model.createTime,model.voiceAuthor,model.voicePic,[NSNumber numberWithInteger:model.voiceClassId],[NSNumber numberWithInteger:model.voiceType],[NSNumber numberWithInt:model.uploadingFlag],[NSNumber numberWithInt:model.downloadFlag],[NSNumber numberWithInt:model.downloadingFlag],[NSNumber numberWithInt:model.collectFlag],model.playSumCount,model.userId,model.downloadTime];
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

+(NSMutableArray *)getAllVoiceUploadInfo{
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceUpload WHERE CREATETIME <> '' ORDER BY CREATETIME DESC"];
        while (rs.next) {
            [arrays addObject:[self getVoiceObject:rs]];
        }
        [rs close];
    }
    return arrays;
}

+(BOOL)updateUploadedInfo:(VoiceObject *)obj{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        BOOL result = [db executeUpdate:@"UPDATE voiceUpload SET URL = ?, picPath = ?,uploadingFlag=? WHERE ID = ?",obj.voiceUrl,obj.picPath,[NSNumber numberWithInt:obj.uploadingFlag],obj.voiceId];
        if (result) {
            NSLog(@"更新成功");
            return true;
        }
        else{
            NSLog(@"更新失败");
            return false;
        }
    }
    NSLog(@"数据库打开失败");
    return false;
}

+(BOOL)deleteVoiceObject:(NSString *)vId{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        BOOL result = [db executeUpdate:@"DELETE FROM voiceUpload WHERE ID = ?",vId];
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

+(BOOL)deleteVoiceInfo:(NSString *)vId{
    __block BOOL flag = false;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDataBasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceUpload WHERE id = ? AND (downloadingFlag = 1 OR downloadFlag = 1)",vId];
        if ([rs next]) {
            flag = [db executeUpdate:@"UPDATE voiceUpload SET CREATETIME='' WHERE ID = ?",vId];
        }
        else{
            flag = [db executeUpdate:@"DELETE FROM voiceUpload WHERE ID = ?",vId];
        }
        [rs close];
        if (flag) {
            NSLog(@"数据更新成功");
        }
        else{
            NSLog(@"更新数据失败");
            
        }

    }];
    return flag;
}

+(BOOL)updateDownloadingState:(VoiceObject *)obj{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        BOOL result = [db executeUpdate:@"UPDATE voiceUpload SET downloadingFlag = 1,downloadTime = ? WHERE ID = ?",obj.downloadTime,obj.voiceId];
        if (result) {
            NSLog(@"更新成功");
            return true;
        }
        else{
            NSLog(@"更新失败");
            return false;
        }
    }
    NSLog(@"数据库打开失败");
    return false;
}

+(NSMutableArray *)getDownloadingInfo{
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceUpload WHERE downloadingFlag = 1 ORDER BY downloadTime DESC"];
        while (rs.next) {
           [arrays addObject:[self getVoiceObject:rs]];
        }
        [rs close];
    }
    return arrays;
}

+(BOOL) updateDownloadState:(VoiceObject *) obj{
    __block BOOL flag = false;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDataBasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceUpload WHERE id = ? AND createTime <> ''",obj.voiceId];
        if ([rs next]) {
            flag = [db executeUpdate:@"UPDATE voiceUpload SET downloadingFlag = ?,downloadFlag = ? WHERE ID = ?",[NSNumber numberWithInt:obj.downloadingFlag],[NSNumber numberWithInt:obj.downloadFlag],obj.voiceId];
        }
        else{
             flag = [db executeUpdate:@"DELETE FROM voiceUpload WHERE ID = ?",obj.voiceId];
        }
        [rs close];
        if (flag) {
            NSLog(@"数据更新成功");
        }
        else{
            NSLog(@"更新数据失败");
            
        }
        
    }];
    return flag;
}

+(BOOL) updateDownLoadedState:(VoiceObject *) obj{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        BOOL result = [db executeUpdate:@"UPDATE voiceUpload SET downloadingFlag = ?,downloadFlag = ?,downloadTime = ? WHERE ID = ?",[NSNumber numberWithInt:obj.downloadingFlag],[NSNumber numberWithInt:obj.downloadFlag],obj.downloadTime,obj.voiceId];
        if (result) {
            NSLog(@"更新成功");
            return true;
        }
        else{
            NSLog(@"更新失败");
            return false;
        }
    }
    NSLog(@"数据库打开失败");
    return false;

}

+(NSMutableArray *)getDownLoadedInfo{
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (db.open) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceUpload WHERE downloadFlag = 1 ORDER BY downloadTime DESC"];
        while (rs.next) {
            [arrays addObject:[self getVoiceObject:rs]];
        }
        [rs close];
    }
    return arrays;
}

+(VoiceObject *) getVoiceObject:(FMResultSet*) rs{
    VoiceObject *item    = [[VoiceObject alloc] init];
    item.voiceId         = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ID"]];
    item.voiceName       = [rs stringForColumn:@"voiceName"];
    item.voiceUrl        = [rs stringForColumn:@"URL"];
    item.voiceSumTime    = [rs stringForColumn:@"SUMTIME"];
    item.total           = [rs doubleForColumn:@"total"];
    item.createTime      = [rs stringForColumn:@"CREATETIME"];
    item.voiceAuthor     = [rs stringForColumn:@"AUTHOR"];
    item.voicePic        = [rs dataForColumn:@"IMAGEDATA"];
    item.voiceClassId    = [rs intForColumn:@"CLASSID"];
    item.voiceType       = [rs intForColumn:@"Type"];
    item.uploadingFlag   = [rs intForColumn:@"uploadingFlag"];
    item.downloadFlag    = [rs intForColumn:@"downloadFlag"];
    item.downloadingFlag = [rs intForColumn:@"downloadingFlag"];
    item.collectFlag     = [rs intForColumn:@"collectFlag"];
    item.picPath         = [rs stringForColumn:@"picPath"];
    item.playSumCount    = [rs stringForColumn:@"playSumCount"];
    item.downloadTime    = [rs stringForColumn:@"downloadTime"];
    item.userId          = [rs stringForColumn:@"USERID"];
    return item;
}

+(BOOL)isExistsDownLoadUrl:(NSString *)url{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDataBasePath]];
    BOOL flag = false;
    if (db.open) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM voiceUpload WHERE (downloadFlag = 1 or downloadingFlag = 1) and URL = ?",url];
        if (rs.next) {
            flag = true;
        }
        [rs close];
    }
    return flag;
}

+(void)sendAddPlayNumber:(NSString*)ID
{
    NSURL*url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://192.168.0.30/wap/apply20150317/AppInterface/yiqiVideoInterface.asp"]];
    //创建可变链接请求
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //设置http请求方式
    [request setHTTPMethod:@"POST"];
    //设置http请求body
    //    NSMutableString*str = (NSMutableString*)message;
    //    str = (NSMutableString*)[str stringByReplacingOccurrencesOfString:@" " withString:@"YQ"];
    NSString*bodyStr = [NSString stringWithFormat:@"sign=counting&id=%@",ID];
    
    //    NSLog(@"%@",bodyStr);
    [request setHTTPBody:[[bodyStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"%@",request);
    //response响应信息
    NSHTTPURLResponse*response = nil;
    //错误信息
    NSError*error = nil;
    //开始post同步请求
    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //    NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
    NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    //    NSDictionary*dict = [strResult objectFromJSONString];
}
+(NSMutableArray*)getSearchResultWithKeyWord:(NSString*)keyWord withPage:(int)page
{
    NSMutableArray*resultArray = [[NSMutableArray alloc]init];
    
    NSURL*url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://192.168.0.30/wap/apply20150317/AppInterface/yiqiVideoInterface.asp"]];
    //创建可变链接请求
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //设置http请求方式
    [request setHTTPMethod:@"POST"];
    //设置http请求body
    //    NSMutableString*str = (NSMutableString*)message;
    //    str = (NSMutableString*)[str stringByReplacingOccurrencesOfString:@" " withString:@"YQ"];
    NSString*bodyStr = [NSString stringWithFormat:@"sign=sear&kw=%@&pnum=%d&pagcnt=10",keyWord,page];
    
    //    NSLog(@"%@",bodyStr);
    [request setHTTPBody:[[bodyStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"%@",request);
    //response响应信息
    NSHTTPURLResponse*response = nil;
    //错误信息
    NSError*error = nil;
    //开始post同步请求
    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //    NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
    NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",[strResult objectFromJSONString]);
    NSDictionary*dict = [strResult objectFromJSONString];
    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"suc"]] isEqualToString:@"1"])
    {
        NSArray *arrs = [dict objectForKey:@"info"];
        for (NSDictionary *eachDict in arrs) {
            VoiceObject *obj = [[VoiceObject alloc] init];
            obj.voiceId      = [eachDict objectForKey:@"id"];
            obj.voiceClassId = [[eachDict objectForKey:@"tid"] integerValue];
            obj.voiceName    = [eachDict objectForKey:@"title"];
            obj.voiceUrl     = [eachDict objectForKey:@"url"];
            obj.picPath      = [eachDict objectForKey:@"picurl"];
            obj.voiceType    = [[eachDict objectForKey:@"flg"] integerValue];
            obj.playSumCount = [eachDict objectForKey:@"playsu"];
            obj.voiceAuthor  = [eachDict objectForKey:@"sname"];
            obj.createTime   = [Common dealDateTime:[eachDict objectForKey:@"createTime"]];
            obj.voiceSumTime = [Common getVoiceTimeLength:[NSURL URLWithString:obj.voiceUrl]];
            [resultArray addObject:obj];
        }
    }
    return resultArray;
}
@end
