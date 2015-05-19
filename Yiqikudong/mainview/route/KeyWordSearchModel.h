//
//  KeyWordSearchModel.h
//  CAVmap
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import <Foundation/Foundation.h>

// 接收数据
typedef void(^receiveDataBlock)(id);

@interface KeyWordSearchModel : NSObject <BMKPoiSearchDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate,BMKBusLineSearchDelegate,BMKSuggestionSearchDelegate>
{
    receiveDataBlock currentBlock;  // 点评块
    receiveDataBlock baiduBlock;  // 兴趣点检索块
    receiveDataBlock detailBlock;  // 详情块
    receiveDataBlock routeSearchBlock;  // 路径检索块
    receiveDataBlock geoResultBlock;  // 编码结果块
    receiveDataBlock asyResultBlock;  // 反编码结果块
    receiveDataBlock busResultBlock;  // bus结果块
    receiveDataBlock placeResultBlock;//地点搜索结果块
    
    BMKRouteSearch *_searcher;  // 路径检索
    BMKSuggestionSearch *placeSearch;  // 地点搜索
    BMKGeoCodeSearch *geoSearch;  // 编码
    BMKGeoCodeSearch *_geoCodeSearch;  // 反编码
    BMKBusLineSearch *busSearcher;  // bus详情检索
}

// 发送周边检索请求
- (void)requestPoiSearchWithSearchBlock:(receiveDataBlock)searchBlock block:(receiveDataBlock)block;

// POI检索
- (void)requestBaiduDetailDataWithUid:(NSString *)uid andBlock:(receiveDataBlock)block;

// 百度检索
- (void)requestBusDetailWithBlock:(receiveDataBlock)searcher andResultBlock:(receiveDataBlock)block;

// 点评检索
- (void)requestDataWithUrl:(NSString *)url params:(NSString *)params reponse:(receiveDataBlock)block;

// 路径检索
- (void)requearRouteSearchWithsearchBlock:(receiveDataBlock)searchBlock andBlock:(receiveDataBlock)block;

//地点搜索
-(void)placeWithKeyWord:(NSString*)place andBlock:(receiveDataBlock)block;

// 编码反编码
- (void)geoCodeWithCity:(NSString *)city address:(NSString *)address andBlock:(receiveDataBlock)block;
- (void)geoCodeWithCoordinate:(CLLocationCoordinate2D )coordinate andBlock:(receiveDataBlock)block;

//单例
+ (KeyWordSearchModel *)keyWordModel;

@end

