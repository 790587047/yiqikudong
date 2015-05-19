//
//  DealData.m
//  YiQiWeb
//
//  Created by BK on 14/12/26.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "DealData.h"
#import "VideoModel.h"
#import "VideoInfo.h"
#import "sys/sysctl.h"
@implementation DealData

+(DealData*)dealDataClass
{
    static DealData*dealData = nil;
    if (dealData==nil)
    {
        dealData = [[DealData alloc]init];
        
    }
    
    return dealData;
}
-(void)videoNotification:(UIViewController*)view withPlayer:(MPMoviePlayerViewController*)player
{
    viewcontroller = view;
    [[NSNotificationCenter defaultCenter] removeObserver:player name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop1:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}
-(void)stop1:(NSNotification*)info
{
    MPMoviePlayerController*view = [info object];
    if (view.playbackState ==2||view.playbackState ==3)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setObject:@"可以退出" forKey:@"videoState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"不可以退出" forKey:@"videoState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)stop:(NSNotification*)info
{
    //    NSLog(@"%@",info);
    MPMoviePlayerController*view = [info object];
    NSLog(@"%@",view.contentURL);
//        NSLog(@"%ld===%f,%f",view.controlStyle,view.currentPlaybackTime,view.playableDuration);
    static BOOL flag;
    if (view.playableDuration- view.currentPlaybackTime>1)
    {
        flag = YES;
    }else
    {
        flag = NO;
    }
#warning 修改过。
    NSString *isDown = [[NSUserDefaults standardUserDefaults] stringForKey:@"isDown"];
    if ([isDown isEqual:@"0"]) {
        viewcontroller = view.view.window.rootViewController;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isDown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    NSString*message;
    if (view.playableDuration- view.currentPlaybackTime>1||flag)
    {
        //        NSLog(@"%d",flag);
        flag = NO;
        [viewcontroller dismissMoviePlayerViewControllerAnimated];
        [[NSUserDefaults standardUserDefaults] setObject:@"不可以退出" forKey:@"videoState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%f",view.currentPlaybackTime);
//        message = [self saveVideo:view];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"videoState"] isEqualToString:@"可以退出"])
    {
        [viewcontroller dismissMoviePlayerViewControllerAnimated];
        [[NSUserDefaults standardUserDefaults] setObject:@"不可以退出" forKey:@"videoState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%f",view.currentPlaybackTime);
    }else if (view.playbackState == 0 && isnan(view.currentPlaybackTime)){
        [viewcontroller dismissMoviePlayerViewControllerAnimated];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *videoId = [[NSUserDefaults standardUserDefaults] stringForKey:@"videoid"];
        float currentTime = view.currentPlaybackTime;
        if (currentTime == view.duration) {
            currentTime = 0;
        }
        [VideoModel updatePlayTime:currentTime withID:videoId];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"videoid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
//    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//    [alert show];
    ReminderView*reminder = [ReminderView reminderViewWithTitle:@"正在加载中"];
    [reminder removeFromSuperview];
}




-(void)saveVideo:(VideoInfo*)info
{
    if (![self searchVideo:[NSString stringWithFormat:@"%@",info.url]])
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
        NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
//        NSLog(@"%@,%f,%@",contenturl,info.sumMemory,UIImagePNGRepresentation(info.image));
        BOOL insertResult = [dataBase executeUpdate:@"insert into videoClass values(?,?,?,?,?)",contenturl,[NSString stringWithFormat:@"%f",info.sumMemory],[NSString stringWithFormat:@"%f",info.downloadMemory],nil,UIImagePNGRepresentation(info.image)];
        if (insertResult)
        {
            NSLog(@"数据插入成功");
        }
        [dataBase close];

    }else{
        //打开数据库
        FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
        if (![dataBase open])
        {
            NSLog(@"数据库打开失败");
            [dataBase close];
            return;
        }
        //更新
        NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
        BOOL updateResult = [dataBase executeUpdate:@"update videoClass set CURRENTTIME = ? where URL = ?",[NSString stringWithFormat:@"%f",info.downloadMemory],contenturl];
        if (updateResult)
        {
            NSLog(@"数据更新成功");
            [dataBase close];
        }
        [dataBase close];
    }

}
-(BOOL)searchVideo:(NSString*)contentURL
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    //条件查询
//    NSLog(@"%@",contentURL);
    NSString*contenturl = [[contentURL componentsSeparatedByString:@"/"] lastObject];
    FMResultSet*resultSet  = [dataBase executeQuery:@"select* from videoClass where URL like ?",contenturl];
//    NSLog(@"as-ds-f=ds-f=ds%@",[resultSet stringForColumn:@"URL"]);
    while ([resultSet next])
    {
//        NSString*url = [resultSet stringForColumn:@"URL"];
//        NSString*sum = [resultSet stringForColumn:@"SUMTIME"];
//        int age = [resultSet intForColumn:@"age"];
//        NSLog(@"%@,%@",url,sum);
        [dataBase close];
        return YES;
    }
    [dataBase close];
    return NO;
}
-(float)selectVideo:(NSString*)contentURL
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    //条件查询
    NSString*contenturl = [[contentURL componentsSeparatedByString:@"/"] lastObject];
    FMResultSet*resultSet  = [dataBase executeQuery:@"select* from videoClass where URL like ?",contenturl];

    while ([resultSet next])
    {
//        NSString*url = [resultSet stringForColumn:@"URL"];
//        NSString*sum = [resultSet stringForColumn:@"SUMTIME"];
        NSString*current = [resultSet stringForColumn:@"CURRENTTIME"];
//        NSLog(@"%@,%@,%@",url,sum,current);
        [dataBase close];
        return current.floatValue;
    }
    [dataBase close];
    return @"0".floatValue;
}
-(NSArray*)getVideoData
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from videoClass"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*url = [resultSet stringForColumn:@"URL"];
//        NSString*sex = [resultSet stringForColumn:@"sex"];
        NSData*imageData = [resultSet dataForColumn:@"IMAGEDATA"];
        VideoModel*info = [[VideoModel alloc]init];
        info.v_Url = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"] stringByAppendingPathComponent:url];
        info.v_imageData = imageData;
        [infoArray addObject:info];
//        NSLog(@"%@,%@",url,imageData);
    }
    [dataBase close];
    
    return infoArray;
}

-(void)saveVoice:(VoiceInfo*)info
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
    NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
    BOOL insertResult = [dataBase executeUpdate:@"insert into voiceClass values(?,?,?,?)",contenturl,[NSString stringWithFormat:@"%f",info.sumTime],info.dateStr,info.name];
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}
-(NSMutableArray*)getVoiceData
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from voiceClass"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*url = [resultSet stringForColumn:@"URL"];
        NSString*name = [resultSet stringForColumn:@"NAME"];
        NSString*saveTime = [resultSet stringForColumn:@"SAVETIME"];
        NSString*sumTime = [resultSet stringForColumn:@"SUMTIME"];
        VoiceInfo*info = [[VoiceInfo alloc]init];
        info.url = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url]];
        info.name = name;
        info.dateStr = saveTime;
        info.sumTime = sumTime.floatValue;
        [infoArray addObject:info];
    }
    [dataBase close];
    
    return infoArray;
}
-(void)deleteVoice:(NSString *)str
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from voiceClass where URL = ?",str];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}
-(void)saveUploadVoice:(VoiceInfo*)info
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
    NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
    BOOL insertResult = [dataBase executeUpdate:@"insert into voiceUpload values(?,?,?,?)",contenturl,[NSString stringWithFormat:@"%f",info.sumTime],nil,info.name];
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}
-(void)deleteUploadVoice:(NSString*)str
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from voiceUpload where URL = ?",str];
//    NSFileManager*fileManager = [NSFileManager defaultManager];
//    NSString*url = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:str];
//    [fileManager removeItemAtPath:url error:nil];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}

-(NSMutableArray*)getUploadVoiceData
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from voiceUpload"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*url = [resultSet stringForColumn:@"URL"];
        NSString*name = [resultSet stringForColumn:@"NAME"];
//        NSString*uploadedTime = [resultSet stringForColumn:@"UPLOADEDTIME"];
        NSString*sumTime = [resultSet stringForColumn:@"SUMTIME"];
        VoiceInfo*info = [[VoiceInfo alloc]init];
        info.url = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url]];
        info.name = name;
//        info.dateStr = uploadedTime;
        info.sumTime = sumTime.floatValue;
        [infoArray addObject:info];
    }
    [dataBase close];
    
    return infoArray;
}


-(void)saveUploadedVoice:(VoiceInfo *)info
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
    NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
    BOOL insertResult = [dataBase executeUpdate:@"insert into voiceUploaded values(?,?,?,?)",contenturl,[NSString stringWithFormat:@"%f",info.sumTime],info.name,info.uploadUrl];
    NSLog(@"%@",info.uploadUrl);
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}
-(NSMutableArray *)getUploadedVoiceData
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from voiceUploaded"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*url = [resultSet stringForColumn:@"URL"];
        NSString*name = [resultSet stringForColumn:@"NAME"];
        NSString*sumTime = [resultSet stringForColumn:@"SUMTIME"];
        NSString*uploadUrl = [resultSet stringForColumn:@"UPLOADURL"];
        VoiceInfo*info = [[VoiceInfo alloc]init];
        info.url = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url]];
        info.name = name;
        info.sumTime = sumTime.floatValue;
        info.uploadUrl = [NSURL URLWithString:uploadUrl];
        [infoArray addObject:info];
    }
    [dataBase close];
    
    return infoArray;
}
-(void)deleteUploadedVoice:(NSString *)str
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from voiceUploaded where URL = ?",str];
//    NSFileManager*fileManager = [NSFileManager defaultManager];
//    NSString*url = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:str];
//    [fileManager removeItemAtPath:url error:nil];

    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}


-(void)saveDownloadVoice:(VoiceInfo*)info
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
    NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
    BOOL insertResult = [dataBase executeUpdate:@"insert into voiceDownload values(?,?,?,?)",contenturl,[NSString stringWithFormat:@"%f",info.sumTime],nil,info.name];
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}
-(NSArray*)getDownloadVoiceData
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from voiceDownload"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*url = [resultSet stringForColumn:@"URL"];
        NSString*name = [resultSet stringForColumn:@"NAME"];
        NSString*sumTime = [resultSet stringForColumn:@"SUMTIME"];
//        NSString*uploadUrl = [resultSet stringForColumn:@"DOWNLOADEDTIME"];
        VoiceInfo*info = [[VoiceInfo alloc]init];
        info.url = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url]];
        info.name = name;
        info.sumTime = sumTime.floatValue;
//        info.uploadUrl = [NSURL URLWithString:uploadUrl];
        [infoArray addObject:info];
    }
    [dataBase close];
    
    return infoArray;
}
-(void)deleteDownloadVoice:(NSString *)str
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from voiceDownload where URL = ?",str];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}


-(void)saveDownloadingVoice:(VoiceInfo *)info
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
    NSString*contenturl = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
    BOOL insertResult = [dataBase executeUpdate:@"insert into voiceDownloading values(?,?,?,?)",contenturl,[NSString stringWithFormat:@"%f",info.sumTime],info.name,info.uploadUrl];
    if (insertResult)
    {
        NSLog(@"数据插入成功");
    }
    [dataBase close];
}
-(NSMutableArray *)getDownloadingVoiceData
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    //查询所有数据
    FMResultSet*resultSet = [dataBase executeQuery:@"select* from voiceDownloading"];
    //
    NSMutableArray*infoArray = [[NSMutableArray alloc]init];
    while ([resultSet next])
    {
        NSString*url = [resultSet stringForColumn:@"URL"];
        NSString*name = [resultSet stringForColumn:@"NAME"];
        NSString*sumTime = [resultSet stringForColumn:@"SUMTIME"];
        NSString*uploadUrl = [resultSet stringForColumn:@"UPLOADURL"];
        VoiceInfo*info = [[VoiceInfo alloc]init];
        info.url = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/voicePath"] stringByAppendingPathComponent:url]];
        info.name = name;
        info.sumTime = sumTime.floatValue;
        info.uploadUrl = [NSURL URLWithString:uploadUrl];
        [infoArray addObject:info];
    }
    [dataBase close];
    
    return infoArray;
}
-(void)deleteDownloadingVoice:(NSString *)str
{
    sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"yiQiCollection.sqlite"];
    //打开数据库
    FMDatabase*dataBase = [FMDatabase databaseWithPath:sqlitePath];
    if (![dataBase open])
    {
        NSLog(@"数据库打开失败");
    }
    BOOL  deleteResult = [dataBase executeUpdate:@"delete from voiceDownloading where URL = ?",str];
    if (deleteResult)
    {
        NSLog(@"数据删除成功");
    }
    [dataBase close];
}

-(BOOL)iPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
@end
