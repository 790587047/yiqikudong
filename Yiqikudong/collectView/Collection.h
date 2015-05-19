//
//  Collection.h
//  YiQiWeb
//
//  Created by wendy on 14/11/18.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collection : NSObject

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *publishDate;
@property (nonatomic, copy) NSData *imgData;

+(BOOL) addCollection : (Collection *) item;
+(BOOL)addCollection:(Collection *)item WithImgData:(NSData *) imageData;
//获取全部收藏信息
+(NSMutableArray *)getAllCollections;
//根据收藏链接和标题查询收藏信息
+(NSMutableArray *) getAllCollectionsForSearch : (NSString *)searchText;
+(BOOL) deleteCollectionById : (NSString *) collectionId;
//判断该url是否存在
+(BOOL) isExistsUrl : (NSString *) url;
+(BOOL) updateImage : (NSData *) imageData withId:(NSString *) cId;
#pragma 判断是否存在url返回info
+(Collection *) getCollectionInfo:(NSString *) url;

//检测设备是否为iPad
+ (BOOL)iPad;

@end
