//
//  Collection.m
//  YiQiWeb
//
//  Created by wendy on 14/11/18.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import "Collection.h"
#import "SqlServer.h"

@implementation Collection

+(BOOL)addCollection:(Collection *)item{
    NSString *insertSql = @"INSERT INTO COLLECTIONINFO(TITLE,URL,IMAGEDATA,COLLECTIONDATE) VALUES(?,?,?,?)";
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [insertSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [item.title UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [item.url UTF8String], -1, NULL);
        sqlite3_bind_blob(statement, 3, [item.imgData bytes], (int)[item.imgData length], NULL);
        sqlite3_bind_text(statement, 4, [item.publishDate UTF8String], -1, NULL);
    }
    
    if (sqlite3_step(statement) == SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else{
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return NO;
    }
}

+(BOOL)addCollection:(Collection *)item WithImgData:(NSData *) imageData{
    NSString *insertSql = @"INSERT INTO COLLECTIONINFO(TITLE,URL,IMAGEDATA,COLLECTIONDATE) VALUES(?,?,?,?)";
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [insertSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [item.title UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [item.url UTF8String], -1, NULL);
        sqlite3_bind_blob(statement, 3, [imageData bytes], (int)[item.imgData length], NULL);
        sqlite3_bind_text(statement, 4, [item.publishDate UTF8String], -1, NULL);
    }
    
    if (sqlite3_step(statement) == SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else{
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return NO;
    }
}

+(NSMutableArray *)getAllCollections{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *selectAllSql = @"SELECT * FROM COLLECTIONINFO ORDER BY COLLECTIONDATE DESC";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectAllSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Collection *item = [self readModelInfo:statement]; 
            [dataArray addObject:item];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDbInstance.db);
    return dataArray;
}

+(NSMutableArray *)getAllCollectionsForSearch:(NSString *)searchText{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    SqlServer *sqlServer = [SqlServer sharedInstance];
    [sqlServer openDB];
    sqlite3 *sqlDb = sqlServer.db;
    
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE TITLE LIKE '%%%@%%' OR URL LIKE '%%%@%%'",searchText,searchText];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDb, [SQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Collection *item = [[Collection alloc] init];
            char *c_id = (char *)sqlite3_column_text(statement, 0);
            item.cId = [NSString stringWithUTF8String:c_id];
            
            char *c_title = (char *) sqlite3_column_text(statement, 1);
            item.title = [NSString stringWithUTF8String:c_title];
            
            char *c_url = (char *) sqlite3_column_text(statement, 2);
            item.url = [NSString stringWithUTF8String:c_url];
            
            char *c_date = (char *) sqlite3_column_text(statement, 3);
            item.publishDate = [NSString stringWithUTF8String:c_date];
            
            int length = sqlite3_column_bytes(statement, 4);
            item.imgData = [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:length];
            
            [dataArray addObject:item];
            
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDb);
    return dataArray;
}

+(Collection *) readModelInfo:(sqlite3_stmt *)statement{
    Collection *item = [[Collection alloc] init];
    char *c_id = (char *)sqlite3_column_text(statement, 0);
    item.cId = [NSString stringWithUTF8String:c_id];
    
    char *c_title = (char *) sqlite3_column_text(statement, 1);
    item.title = [NSString stringWithUTF8String:c_title];
    
    char *c_url = (char *) sqlite3_column_text(statement, 2);
    item.url = [NSString stringWithUTF8String:c_url];
    
    char *c_date = (char *) sqlite3_column_text(statement, 3);
    item.publishDate = [NSString stringWithUTF8String:c_date];
    
    int length = sqlite3_column_bytes(statement, 4);
    item.imgData = [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:length];
    return item;
}

+(BOOL)deleteCollectionById:(NSString *)collectionId{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM COLLECTIONINFO WHERE ID = %@",collectionId];
    if ([sqlDbInstance exec:deleteSql]) {
        return true;
    }
    return false;
}

+(BOOL)isExistsUrl:(NSString *)url{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    sqlite3_stmt *statement;
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE URL = '%@'",url];
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

+(BOOL)updateImage:(NSData *)imageData withId:(NSString *)cId{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *updateSQl = @"UPDATE COLLECTIONINFO SET IMAGEDATA=? WHERE ID = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDbInstance.db, [updateSQl UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_blob(statement, 1, [imageData bytes], (int)[imageData length], NULL);
        sqlite3_bind_text(statement, 2, [cId UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) == SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return YES;
    }
    else
    {
        sqlite3_finalize(statement);
        sqlite3_close(sqlDbInstance.db);
        return NO;
    }
}

#pragma 判断是否存在url返回info
+(Collection *) getCollectionInfo:(NSString *) url{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    sqlite3_stmt *statement;
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE URL = '%@'",url];
    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            Collection *info = [[Collection alloc] init];
            char *c_id = (char *)sqlite3_column_text(statement, 0);
            info.cId = [NSString stringWithUTF8String:c_id];
            
            char *c_title = (char *) sqlite3_column_text(statement, 1);
            info.title = [NSString stringWithUTF8String:c_title];
            
            char *c_url = (char *) sqlite3_column_text(statement, 2);
            info.url = [NSString stringWithUTF8String:c_url];
            
            char *c_date = (char *) sqlite3_column_text(statement, 3);
            info.publishDate = [NSString stringWithUTF8String:c_date];
            
            int length = sqlite3_column_bytes(statement, 4);
            info.imgData = [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:length];
            sqlite3_finalize(statement);
            sqlite3_close(sqlDbInstance.db);
            return info;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(sqlDbInstance.db);
    return nil;
}


+ (BOOL)iPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end
