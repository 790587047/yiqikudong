//
//  ChatDealClass.m
//  Yiqikudong
//
//  Created by BK on 15/3/24.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ChatDealClass.h"
#import "Photo.h"
@implementation ChatDealClass

+(ChatDealClass*)dealDataClass
{
    static ChatDealClass*dealData = nil;
    if (dealData==nil)
    {
        dealData = [[ChatDealClass alloc]init];
        
    }
    return dealData;
}
-(void)saveLinkMan:(NSMutableArray *)array
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from chatList"];
    //
    NSMutableArray*newManArray = [[NSMutableArray alloc]init];
//    NSMutableArray*oldManArray = [[NSMutableArray alloc]init];
    newManArray = array;
    while ([resultSet next])
    {
        NSString*chatuserID = [resultSet stringForColumn:@"CHATUSERID"];
        //            NSLog(@"%@==%@",chatuserID,[resultSet stringForColumn:@"CHATUSERID"]);
        for (UserObject*info in newManArray)
        {
            //                NSLog(@"%@",info.state);
            if ([chatuserID isEqualToString:info.chatUserID])
            {
                [newManArray removeObject:info];
//                [oldManArray addObject:info];
                break;
            }
        }
    }
    [dataBase close];
    for (UserObject*info in newManArray)
    {
        [self save:info];
    }
//    for (UserObject*info1 in oldManArray)
//    {
//        [self changeState:info1.state chatID:info1.chatID];
//    }
    
}
-(void)save:(UserObject*)info
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return ;
    }
    //数据插入
    NSString*myID = info.myID;
    NSString*chatUserID = info.chatUserID;
    NSString*maxID = info.maxID;
    NSString*time = info.time;
    NSString*picUrl = info.picUrl;
    NSString*chatPicUrl = info.chatPicUrl;
    NSString*chatUserName = info.chatUserName;
    NSString*msg = info.content;
    NSString*msgid = info.msgID;
    NSString*chattype = info.chatType;
    BOOL insertResult = [dataBase executeUpdate:@"insert into chatList(MYID,CHATUSERID,MAXID,TIME,PICURL,CHATPICURL,CHATUSERNAME,STATECHAT,MSG,MSGID,CHATTYPE) values(?,?,?,?,?,?,?,?,?,?,?)",myID,chatUserID,maxID,time,picUrl,chatPicUrl,chatUserName,@"1",msg,msgid,chattype];
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}

-(NSMutableArray *)getListMan
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from chatList order by TIME desc"];
    //根据时间排序，desc降序，asc升序
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*chatType = [resultSet stringForColumn:@"CHATTYPE"];//True表示群聊，False表示私聊
        if (![chatType isEqualToString:@"True"])
        {
            NSString*chatID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"ID"]];
            NSString*myID = [resultSet stringForColumn:@"MYID"];
            NSString*chatUserID = [resultSet stringForColumn:@"CHATUSERID"];
            NSString*maxID = [resultSet stringForColumn:@"MAXID"];
            NSString*time = [resultSet stringForColumn:@"TIME"];
            NSString*picUrl = [resultSet stringForColumn:@"PICURL"];
            NSString*chatPicUrl = [resultSet stringForColumn:@"CHATPICURL"];
            NSString*chatUserName = [resultSet stringForColumn:@"CHATUSERNAME"];
            NSString*msg = [resultSet stringForColumn:@"MSG"];
            NSString*state = [resultSet stringForColumn:@"STATECHAT"];
            NSString*msgID = [resultSet stringForColumn:@"MSGID"];
            //        NSLog(@"%@",state.class);
            UserObject*info = [[UserObject alloc]init];
            info.chatID = chatID;
            info.myID = myID;
            info.chatUserID = chatUserID;
            info.maxID = maxID;
            info.time = time;
            info.picUrl = picUrl;
            info.chatPicUrl = chatPicUrl;
            info.chatUserName = chatUserName;
            info.content = msg;
            info.zt = state;
            info.msgID = msgID;
            info.chatType = chatType;
            [infoArray addObject:info];
        }
    }
    [dataBase close];
//    NSLog(@"infoArray==%@",infoArray);
    return infoArray;
}
//按时间排序列表
-(NSMutableArray *)rankMan:(NSMutableArray *)array
{
//    NSMutableArray*rankArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<array.count; i++)
    {
        UserObject*userObject1 = array[i];
        for (int j = i; j<array.count; j++)
        {
            UserObject*userObject2 = array[j];
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate*time1 = [inputFormatter dateFromString:userObject1.time];
            NSDate*time2 = [inputFormatter dateFromString:userObject2.time];
            NSComparisonResult result = [time1 compare:time2];
            if (result == NSOrderedAscending)
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    NSLog(@"array==%@",array);
    return array;
}
-(void)deleteMan:(NSString *)ID
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from chatList where CHATUSERID = ?",ID];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}
-(void)changeState:(NSString *)state chatID:(NSString *)chatID
{
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatList set STATECHAT = ? where ID = ?",state,chatID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(void)changeManMaxID:(NSString*)maxID chatID:(NSString*)chatID
{
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatList set MAXID = ? where ID = ?",maxID,chatID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(void)changeManMsg:(NSString *)msg chatID:(NSString *)chatID
{
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatList set MSG = ? where ID = ?",msg,chatID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(void)changeManTime:(NSString *)time chatID:(NSString *)chatID
{
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatList set TIME = ? where ID = ?",time,chatID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(void)changeManTime:(NSString *)time chatUserID:(NSString *)chatID
{
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatList set TIME = ? where CHATUSERID = ?",time,chatID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(void)changePic:(NSData *)data chatID:(NSString *)chatID
{
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatList set CHATPICURL = ? where ID = ?",[data base64Encoding],chatID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(NSMutableArray *)getGroud
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from chatList"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*chatType = [resultSet stringForColumn:@"CHATTYPE"];//True表示群聊，False表示私聊
        if (![chatType isEqualToString:@"False"])
        {
            NSString*chatID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"ID"]];
            NSString*myID = [resultSet stringForColumn:@"MYID"];
            NSString*chatUserID = [resultSet stringForColumn:@"CHATUSERID"];
            NSString*maxID = [resultSet stringForColumn:@"MAXID"];
            NSString*time = [resultSet stringForColumn:@"TIME"];
            NSString*picUrl = [resultSet stringForColumn:@"PICURL"];
            NSString*chatPicUrl = [resultSet stringForColumn:@"CHATPICURL"];
            NSString*chatUserName = [resultSet stringForColumn:@"CHATUSERNAME"];
            NSString*msg = [resultSet stringForColumn:@"MSG"];
            NSString*state = [resultSet stringForColumn:@"STATECHAT"];
            NSString*msgID = [resultSet stringForColumn:@"MSGID"];
            //        NSLog(@"%@",state.class);
            UserObject*info = [[UserObject alloc]init];
            info.chatID = chatID;
            info.myID = myID;
            info.chatUserID = chatUserID;
            info.maxID = maxID;
            info.time = time;
            info.picUrl = picUrl;
            info.chatPicUrl = chatPicUrl;
            info.chatUserName = chatUserName;
            info.content = msg;
            info.zt = state;
            info.msgID = msgID;
            info.chatType = chatType;
            [infoArray addObject:info];
        }
    }
    [dataBase close];
    //    NSLog(@"infoArray==%@",infoArray);
    return [self rankMan:infoArray];
    //    return infoArray;
}
//删除与某个人的全部聊天记录
-(void)deleteManMSG:(NSString *)ID
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from chatRecords where CHATID = ?",ID];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}

-(void)saveMsg:(MsgObject*)info
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return ;
    }
//    NSString*content ;
//    if ([info.type isEqualToString:@"text"]) {
//        content = info.content;
//    }else
//    {
////        content = info.content = 
//    }
    //数据插入
    
//    NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.content] componentsSeparatedByString:@"/"] lastObject];
    BOOL insertResult = [dataBase executeUpdate:@"insert into chatRecords(CHATID,SENDID,RECIEVEID,MSGTYPE,MSGID,MSG,TIME,OTHER) values(?,?,?,?,?,?,?,?)",info.chatID,info.fromUserId,info.toUserId,info.type,info.messageId,info.content,info.time,info.timeLen];
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}
-(NSMutableArray*)getMsgData:(NSString*)chatID withPage:(int)page
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from chatRecords where CHATID = ? order by TIME desc limit ?",chatID,[NSString stringWithFormat:@"%d",page*20]];
    
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*ID = [resultSet stringForColumn:@"ID"];
        NSString*chatID = [resultSet stringForColumn:@"CHATID"];
        NSString*sendID = [resultSet stringForColumn:@"SENDID"];
        NSString*recieveID = [resultSet stringForColumn:@"RECIEVEID"];
        NSString*msgType = [resultSet stringForColumn:@"MSGTYPE"];
        NSString*msgID = [resultSet stringForColumn:@"MSGID"];
        NSString*msg = [resultSet stringForColumn:@"MSG"];
        NSString*time = [resultSet stringForColumn:@"TIME"];
        NSString*timeLen = [resultSet stringForColumn:@"OTHER"];
        MsgObject*info = [[MsgObject alloc]init];
        info.ID = ID;
        info.chatID = chatID;
        info.fromUserId = sendID;
        info.toUserId = recieveID;
        info.type = msgType;
        info.messageId = msgID;
        info.content = msg;
        info.time = time;
        info.timeLen = timeLen;
        [infoArray addObject:info];
    }
    [dataBase close];
    
    return (NSMutableArray *)[[infoArray reverseObjectEnumerator] allObjects];//数组倒序输出
}
-(void)deleteMsg:(NSString *)str
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from chatRecords where MSGID = ?",str];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}
-(void)changeMsgID:(NSString*)ID newData:(id)data
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //更新
    BOOL updateResult = [dataBase executeUpdate:@"update chatRecords set MSG = ? where ID = ?",data ,ID];
    if (updateResult)
    {
        NSLog(@"数据更新成功");
        return;
    }
    [dataBase close];
}
-(NSString*)deleteDataWithMsgID:(NSString*)ID
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //条件查询
    FMResultSet*resultSet  = [dataBase executeQuery:@"select* from chatRecords where ID = ?",ID];
    NSString*name;
    while ([resultSet next])
    {
        name = [resultSet stringForColumn:@"MSG"];
    }
    [dataBase close];
    return name;
}


#pragma maek 发送文本信息
+(BOOL)sendMessege:(NSString*)message sendID:(NSString*)sendID receiverID:(NSString*)receiverID isGroup:(int)isGroup
{
   
    //创建url连接
    //    NSURL*url = [[NSURL alloc]initWithString:@"http://www.xinquanxinyuan.com/test/gold_seed/app/newslist.php"];
    NSURL*url = [[NSURL alloc]initWithString:@"http://192.168.0.136:82/apply/chat/APP_PrivateChat_AddMessage.asp"];
    //创建可变链接请求
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //设置http请求方式
    [request setHTTPMethod:@"POST"];
    //设置http请求body
//    NSMutableString*str = (NSMutableString*)message;
//    str = (NSMutableString*)[str stringByReplacingOccurrencesOfString:@" " withString:@"YQ"];
    NSString*bodyStr = [NSString stringWithFormat:@"IsGroup=%d&SendID=%@&ReceiverId=%@&Message=%@&MType=text",isGroup,sendID,receiverID,message];
//    NSLog(@"%@",[bodyStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
#pragma mark 非常重要,必须先编码，不然空格换行等都会出错
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
    
    //生成url链接
//    NSURL*url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/chat/APP_PrivateChat_AddMessage.asp?IsGroup=0&SendID=1&ReceiverId=10&Message=%@&MType=text",message]];
//    //生成urlRequest
//    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
//    //response响应信息
//    NSHTTPURLResponse*response = nil;
//    //错误信息
//    NSError*error = nil;
//    //发送同步请求,获得请求数据
//    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
//    //
//    NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//解码后得到的数据为JSon数据
//    NSLog(@"get同步请求结果=%@",strResult);
//    NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
//    NSDictionary*dict = [strResult objectFromJSONString];
//    NSLog(@"json解析结果bushou=%@",[[[[dict objectForKey:@"data"] objectForKey:@"words"] objectAtIndex:0] objectForKey:@"bushou"]);
    
    
//    NSLog(@"strResult = %@",strResult);
//    NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
    if ([[[strResult objectFromJSONString] objectForKey:@"code"] isEqualToString:@"ok"])
    {
        return YES;
    }else
    {
        return NO;
    }
}
#pragma maek 发送文件信息
+(void)sendMessege:(NSData*)message withSumtime:(NSString*)sumtime type:(NSString*)type sendID:(NSString*)sendID receiverID:(NSString*)receiverID isGroup:(int)isGroup withBlock:(void (^)(AFHTTPRequestOperation *))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPRequestOperationManager*manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.136:82/apply/chat"]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary*parameters;
        if ([type isEqualToString:@"sound"])
        {
            parameters = @{@"IsGroup":[NSString stringWithFormat:@"%d",isGroup],@"SendID":sendID,@"ReceiverId":receiverID,@"MType":type,@"TimeSu":sumtime};
        }else
        {
            parameters = @{@"IsGroup":[NSString stringWithFormat:@"%d",isGroup],@"SendID":sendID,@"ReceiverId":receiverID,@"MType":type};
        }
        
        AFHTTPRequestOperation*request = [manager POST:@"APP_UploadSave.asp" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if ([type isEqualToString:@"img"])
            {
                [formData appendPartWithFileData:message name:@"Message" fileName:@"pic.png" mimeType:@"image/png"];
            }else if ([type isEqualToString:@"video"])
            {
                [formData appendPartWithFileData:message name:@"Message" fileName:@"video.mp4" mimeType:@"video/mpeg4"];
            }else if ([type isEqualToString:@"sound"])
            {
                [formData appendPartWithFileData:message name:@"Message" fileName:@"voice.mp3" mimeType:@"audio/mp3"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject){
            //        NSString *html = operation.responseString;
            //        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        NSError*error=nil;
            //        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
            //        NSLog(@"服务器返回的数据为：%@==%@",dict,error);
            block(operation);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不好意思,服务器请求出现问题了，请稍后重新请求。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert show];
//            NSLog(@"dsafgfdsh==%@",error);
        }];
        [request start];
    });
}
#pragma maek 检测新信息，有就返回，无则返回空
+(NSDictionary*)getNewMessegesID:(NSString*)ChatMaxID sendID:(NSString*)sendID receiverID:(NSString*)receiverID
{
    //创建url连接
    NSURL*url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@chat/APP_PrivateChat_CheckNew.asp",chatUrlPrefix]];
    //创建可变链接请求
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //设置http请求方式
    [request setHTTPMethod:@"POST"];
    //设置http请求body
    NSLog(@"%@",ChatMaxID);
    NSString*bodyStr = [NSString stringWithFormat:@"SendID=%@&ReceiverId=%@&ChatMaxId=%@",sendID,receiverID,ChatMaxID];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    //response响应信息
    NSHTTPURLResponse*response = nil;
    //错误信息
    NSError*error = nil;
    //开始post同步请求
    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
    NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"strResult = %@",strResult);
//    NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
    if ([[[strResult objectFromJSONString] objectForKey:@"code"] isEqualToString:@"ok"])
    {
        NSURL*url1 = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@chat/APP_PrivateChat_GetMessage.asp",chatUrlPrefix]];
        //创建可变链接请求
        NSMutableURLRequest*request1 = [[NSMutableURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        //设置http请求方式
        [request1 setHTTPMethod:@"POST"];
        //设置http请求body
//        NSString*bodyStr1 = [NSString stringWithFormat:@"SendID=1&ReceiverId=10&ChatMaxId=10152357"];
        [request1 setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"%@",[NSString stringWithFormat:@"%@",@"Jhh\\nGood night to\\nThe first "]);
        //response响应信息
        NSHTTPURLResponse*response1 = nil;
        //错误信息
        NSError*error1 = nil;
        //开始post同步请求
        NSData*data1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&response1 error:&error1];
//        NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response1 statusCode]],error1);
        NSString*strResult1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
//        NSLog(@"strResult = %@",[strResult1 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]);
        NSString*zyStr = [strResult1 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
//        NSLog(@"%@",zyStr);
        NSMutableDictionary*dictResult = [[zyStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] objectFromJSONString];
//        NSLog(@"%@",dictResult);
        NSMutableArray*arrayResult1 = [dictResult objectForKey:@"PrivateChats"];
//        NSMutableDictionary*dictResult1 = [arrayResult1 lastObject];
//        NSMutableString*jsonResult = [dictResult1 objectForKey:@"message"];
//
//        NSMutableDictionary*returnDict1 = [NSMutableDictionary dictionaryWithDictionary:dictResult1];
//        [returnDict1 setObject:[[jsonResult stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] forKey:@"message"];
//        arrayResult1 = [NSMutableArray arrayWithObject:returnDict1];
//
//        NSMutableDictionary*returnDict = [NSMutableDictionary dictionaryWithDictionary:dictResult];
        NSMutableDictionary*returnDict;
        NSMutableArray*arrayResult2 = [[NSMutableArray alloc]init];
        for (NSMutableDictionary*dictResult1 in arrayResult1)
        {
            NSMutableString*jsonResult = [dictResult1 objectForKey:@"message"];
            NSMutableDictionary*returnDict1 = [NSMutableDictionary dictionaryWithDictionary:dictResult1];
            [returnDict1 setObject:[[jsonResult stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] forKey:@"message"];
            [arrayResult2 addObject:returnDict1];
        }
        returnDict = [NSMutableDictionary dictionaryWithDictionary:dictResult];
        
        [returnDict setObject:arrayResult2 forKey:@"PrivateChats"];
        if (returnDict) {
            return returnDict;
        }else
        {
            return nil;
        }
    }else
    {
        return nil;
    }
}
+(NSMutableArray*)dictionary:(NSDictionary*)dict withSendID:(NSString *)sendID
{
    NSMutableArray*array = [[NSMutableArray alloc]init];
//    NSLog(@"%@",dict);
    for (NSDictionary*str in [dict objectForKey:@"PrivateChats"]) {
//        NSDictionary*dictionary = [str objectFromJSONString];
//        NSLog(@"%@",str);
//        if () {
//
//        }
        NSMutableDictionary*dictionary = [[NSMutableDictionary alloc]init];
        if ([[str objectForKey:@"m_type"]isEqualToString:@"video"])
        {
//            NSMutableString*str1 = [str objectForKey:@"m_type"];
//            str1 = [str1 replaceCharactersInRange:NSMakeRange(str1, <#NSUInteger len#>) withString:<#(NSString *)#>]
//            if (![sendID isEqualToString:[NSString stringWithFormat:@"%@",[str objectForKey:@"sender_id"]]])
//            {
                NSData*dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",chatUrlPrefix,[str objectForKey:@"message"]]]];
                //            NSLog(@"%@",dat);
//                if (dat==nil)
//                {
//                    [dictionary setObject:@"失败" forKey:@"msg"];
//                }else
//                {
                    [dictionary setObject:[dat base64Encoding] forKey:@"msg"];
//                }
//            }
            
        }else if([[str objectForKey:@"m_type"]isEqualToString:@"sound"])
        {
            NSData*dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",chatUrlPrefix,[str objectForKey:@"message"]]]];
            [dictionary setObject:[dat base64Encoding] forKey:@"msg"];
        }else
        {
            [dictionary setObject:[str objectForKey:@"message"] forKey:@"msg"];
        }
        if ([sendID isEqualToString:[NSString stringWithFormat:@"%@",[str objectForKey:@"sender_id"]]])
        {
            [dictionary setObject:@"you" forKey:@"sender"];
        }else
        {
            [dictionary setObject:@"noyou" forKey:@"sender"];
        }
        //加入发送时间
        [dictionary setObject:[str objectForKey:@"send_time"] forKey:@"time"];
        [dictionary setObject:[str objectForKey:@"id"] forKey:@"id"];
        [dictionary setObject:[str objectForKey:@"m_type"] forKey:@"type"];
        [dictionary setObject:[str objectForKey:@"TimeSu"] forKey:@"TimeSu"];
        
        [array addObject:dictionary];
    }
    return array;
}


-(void)sendMSGID:(NSString*)ID
{
    //创建url连接
    //    NSURL*url = [[NSURL alloc]initWithString:@"http://www.xinquanxinyuan.com/test/gold_seed/app/newslist.php"];
    NSURL*url = [[NSURL alloc]initWithString:@"http://192.168.0.136:82/apply/chat/APP_PrivateChat_UpdataRead.asp"];
    //创建可变链接请求
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //设置http请求方式
    [request setHTTPMethod:@"POST"];
    //设置http请求body
    //    NSMutableString*str = (NSMutableString*)message;
    //    str = (NSMutableString*)[str stringByReplacingOccurrencesOfString:@" " withString:@"YQ"];
    NSString*bodyStr = [NSString stringWithFormat:@"ID=%@",ID];
//    NSLog(@"%@",bodyStr);
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"%@",request);
    //response响应信息
    NSHTTPURLResponse*response = nil;
    //错误信息
    NSError*error = nil;
    //开始post同步请求
    NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
    NSString*strResult = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSLog(@"strResult = %@",strResult);
//    NSLog(@"json解析结果=%@",[strResult objectFromJSONString]);
   
}

//发送修改群资料的请求
-(void)changeGroudSet:(NSDictionary*)dict withGroudID:(NSString*)ID
{
    
}
//发送添加或删除群成员请求
-(void)addOrDeleteMember:(NSArray*)array withGroudID:(NSString*)ID
{
    
}
//发送退群请求
-(void)exitGroudwithGroudID:(NSString*)ID
{
    
}
//发送同意或拒绝加群审核
-(void)sebdCheckResult:(NSDictionary*)dict withGroudID:(NSString*)ID
{
    
}
//发送建群请求
-(void)sendCreateGroud:(NSDictionary*)dict withOwnerID:(NSString*)ID
{
    
}


@end
