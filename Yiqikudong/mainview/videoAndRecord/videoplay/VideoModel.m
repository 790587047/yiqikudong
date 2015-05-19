//
//  VedioModel.m
//  YiQiWeb
//
//  Created by wendy on 14/12/12.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import "VideoModel.h"
#import "SqlServer.h"

@implementation VideoModel

+(NSString *)addVideoModel : (VideoModel *) model{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *insertSql = @"INSERT INTO VIDEOINFO(NAME,VIDEOURL,TIMESCALE,IMAGEDATA,STATE,OPERATETIME,PLAYTIME,SUM,UPLOADFILESIZE,DOWNLOADID) VALUES(?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [insertSql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [model.v_Name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [model.v_Url UTF8String], -1, NULL);
        sqlite3_bind_int64(stmt, 3, model.v_timeScale);
        sqlite3_bind_blob(stmt, 4, [model.v_imageData bytes], [[NSNumber numberWithLong:[model.v_imageData length]] intValue], NULL);
        sqlite3_bind_int64(stmt, 5, model.v_State);
        sqlite3_bind_text(stmt, 6, [model.v_OperationTime UTF8String], -1, NULL);
        sqlite3_bind_double(stmt, 7, model.v_PlayTime);
        sqlite3_bind_double(stmt, 8, model.sumMemory);
        sqlite3_bind_double(stmt, 9, model.downloadMemory);
        sqlite3_bind_int64(stmt, 10, model.downLoadId);
    }
    NSInteger rowId = 0;
    if (sqlite3_step(stmt) != SQLITE_ERROR) {
        NSLog(@"添加成功！");
        rowId = (long)sqlite3_last_insert_rowid(sqlDbInstance.db);
    }
    else{
        NSLog(@"添加失败！");
    }
    sqlite3_finalize(stmt);
    [sqlDbInstance closeDB];
    return [NSString stringWithFormat:@"%ld",(long)rowId];
}

+(VideoModel *) getInfoById : (NSString *) videoId{
    VideoModel *model = [[VideoModel alloc] init];
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM VIDEOINFO WHERE ID = %@",videoId];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            model = [self readModelInfo:statement];
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(sqlDbInstance.db);
    return model;
}

+(NSMutableArray *)getAllVideoInfo {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *sqlString = @"SELECT * FROM VIDEOINFO ORDER BY ID DESC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [sqlString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            VideoModel *item = [self readModelInfo:statement];
            
            [dataArray addObject:item];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDbInstance.db);
    return dataArray;
}

+(BOOL) deleteVideoModel:(NSString *) videoId{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM VIDEOINFO WHERE ID = %@",videoId];
    if ([sqlDbInstance exec:deleteString]) {
        return true;
    }
    return false;
}

+(NSMutableArray *)getAllVideoInfoByID:(int) state{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM VIDEOINFO WHERE STATE = %d ORDER BY OPERATETIME DESC",state];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [sqlString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            VideoModel *item = [self readModelInfo:statement];
            
            [dataArray addObject:item];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDbInstance.db);
    return dataArray;
}

+(BOOL) updatePlayTime : (double) playTime withID : (NSString *) videoId{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *updateSQl =@"UPDATE VIDEOINFO SET PLAYTIME = ? WHERE ID = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [updateSQl UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_double(statement, 1, playTime);
        sqlite3_bind_text(statement, 2, [videoId UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) == SQLITE_DONE){
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else{
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        NSLog(@"%s step failed: \"%s\"", __FUNCTION__, sqlite3_errmsg(sqlDbInstance.db));
        return NO;
    }
}

+(BOOL)updateInfoWhenUploadFinish:(VideoModel *)model{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *updateSQL = @"UPDATE VIDEOINFO SET VIDEOURL = ?,STATE = ?,OPERATETIME=? WHERE ID = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [model.v_Url UTF8String], -1, NULL);
        sqlite3_bind_int64(statement, 2, model.v_State);
        sqlite3_bind_text(statement, 3, [model.v_OperationTime UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [model.v_Id UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) == SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else{
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        NSLog(@"%s step failed: \"%s\"", __FUNCTION__, sqlite3_errmsg(sqlDbInstance.db));
        return NO;
    }
}

+(BOOL) updateInfoWhenUploadFail:(VideoModel *) model{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *updateSQL = @"UPDATE VIDEOINFO SET UPLOADFILESIZE=? WHERE ID = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_double(statement, 1, model.downloadMemory);
        sqlite3_bind_text(statement, 2, [model.v_Id UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) == SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else{
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        NSLog(@"%s step failed: \"%s\"", __FUNCTION__, sqlite3_errmsg(sqlDbInstance.db));
        return NO;
    }
}

+(NSMutableDictionary *) getAllUploadVideoInfo : (int) updateState And :(int)updateFinish {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *selectedSQL = [NSString stringWithFormat:@"SELECT * FROM VIDEOINFO WHERE STATE IN (%d, %d) ORDER BY STATE ASC, OPERATETIME DESC",updateState,updateFinish];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectedSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *arrays = [[NSMutableArray alloc] init];
            VideoModel *item = [self readModelInfo:statement];
            
            NSString *key = [NSString stringWithFormat:@"%ld",(long)item.v_State];
            
            if (![dictionary objectForKey:key]) {
                [arrays addObject:item];
                [dictionary setObject:arrays forKey:key];
            }else{
                NSMutableArray *tmp_Array = [NSMutableArray arrayWithArray:[dictionary objectForKey:key]];
                [tmp_Array addObject:item];
                [dictionary setObject:tmp_Array forKey:key];
            }
        }
    }
    return dictionary;
}

+(VideoModel *) readModelInfo:(sqlite3_stmt *)statement{
    VideoModel *item = [[VideoModel alloc] init];
    char *_id = (char *)sqlite3_column_text(statement, 0);
    item.v_Id = [NSString stringWithUTF8String:_id];
    
    char *v_name = (char *)sqlite3_column_text(statement, 1);
    item.v_Name = v_name == nil ? @"" : [NSString stringWithUTF8String:v_name];
    
    char *v_vedioUrl = (char *)sqlite3_column_text(statement, 2);
    item.v_Url = v_vedioUrl != nil ? [NSString stringWithUTF8String:v_vedioUrl] : @"";
    
    int v_timeScale = sqlite3_column_int(statement, 3);
    item.v_timeScale = v_timeScale;
    
    int length = sqlite3_column_bytes(statement, 4);
    item.v_imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:length];
    
    item.v_State = sqlite3_column_int(statement, 5);
    
    char *v_operationTime = (char *)sqlite3_column_text(statement, 6);
    item.v_OperationTime = [NSString stringWithUTF8String:v_operationTime];
    
    item.v_PlayTime = sqlite3_column_double(statement, 7);
    
    item.sumMemory = sqlite3_column_double(statement, 8);
    
    item.downloadMemory = sqlite3_column_double(statement, 9);
    
    item.downLoadId = sqlite3_column_int(statement, 10);
    
    return item;
}

+(BOOL) updateDownLoad:(VideoModel *) model{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *updateSQL = @"UPDATE VIDEOINFO SET DOWNLOADID=? WHERE ID = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_double(statement, 1, model.downLoadId);
        sqlite3_bind_text(statement, 2, [model.v_Id UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) == SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else{
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        NSLog(@"%s step failed: \"%s\"", __FUNCTION__, sqlite3_errmsg(sqlDbInstance.db));
        return NO;
    }
}

+(BOOL) isExistsUploadVideoName :(NSString *) name{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    sqlite3_stmt *statement;
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM VIDEOINFO WHERE NAME = '%@'",name];
    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            sqlite3_finalize(statement);
            sqlite3_close(sqlDbInstance.db);
            return YES;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(sqlDbInstance.db);
    return false;
}


+ (BOOL)iPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end
