//
//  KeyWordSearchModel.m
//  CAVmap
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "KeyWordSearchModel.h"
#import "AppDelegate.h"

@implementation KeyWordSearchModel 

#pragma mark - 百度检索

- (void)requestPoiSearchWithSearchBlock:(receiveDataBlock)searchBlock block:(receiveDataBlock)block
{
    // 初始化检索对象
    BMKPoiSearch *searcher = [[BMKPoiSearch alloc]init];
    searcher.delegate = self;
    
    searchBlock(searcher);
    
    baiduBlock = block;
}

// 实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        // 完成请求
        
        baiduBlock(poiResultList);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD)
    {
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else
    {
        baiduBlock(@"失败");
    }
}


#pragma mark - 百度详情检索
- (void)requestBaiduDetailDataWithUid:(NSString *)uid andBlock:(receiveDataBlock)block
{
    
    BMKPoiSearch *searcher = [[BMKPoiSearch alloc]init];
    searcher.delegate = self;
    
    //POI详情检索
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = uid;//POI搜索结果中获取的uid
    BOOL flag = [searcher poiDetailSearch:option];

    if(flag)
    {
        //详情检索发起成功
    }
    else
    {
        //详情检索发送失败
    }
    detailBlock = block;
    
}
-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR)
    {
        //在此处理正常结果
        detailBlock(poiDetailResult);
    }
    searcher.delegate = nil;
}

#pragma mark - bus详情检索
- (void)requestBusDetailWithBlock:(receiveDataBlock)searcher andResultBlock:(receiveDataBlock)block
{
    busSearcher = [[BMKBusLineSearch alloc]init];
    busSearcher.delegate = self;
    searcher(busSearcher);
    busResultBlock = block;
}

-(void)onGetBusDetailResult:(BMKBusLineSearch *)searcher result:(BMKBusLineResult *)busLineResult errorCode:(BMKSearchErrorCode)error
{
    switch (error)
    {
        case BMK_SEARCH_NO_ERROR:
            busResultBlock(busLineResult);
            break;
            
        case BMK_SEARCH_RESULT_NOT_FOUND:
            busResultBlock(@"没结果");
            break;
            
        case BMK_SEARCH_AMBIGUOUS_KEYWORD:
            busResultBlock(@"搜索词有歧义");
            break;
            
        case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
            busResultBlock(@"搜索地址有歧义");
            break;
            
        case BMK_SEARCH_NOT_SUPPORT_BUS:
            busResultBlock(@"城市不支持搜索");
            break;
            
        case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
            busResultBlock(@"不支持夸成");
            break;
            
        default:
            break;
    }
    
    busSearcher.delegate = nil;
}

#pragma mark - 百度路劲检索
- (void)requearRouteSearchWithsearchBlock:(receiveDataBlock)searchBlock andBlock:(receiveDataBlock)block
{
    //初始化检索对象
    _searcher = [[BMKRouteSearch alloc]init];
    _searcher.delegate = self;
    
    searchBlock(_searcher);
    routeSearchBlock = block;
}

//实现Deleage处理回调结果
-(void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
//    NSLog(@"%@\n%@\n%@",result.taxiInfo,result.routes,result.suggestAddrResult);
//    for (BMKTransitRouteLine*a in result.routes) {
//        NSLog(@"%@",a.steps);
//    }
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //在此处理正常结果
//        NSLog(@"%@",result);
        
        routeSearchBlock(result);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        //当路线起终点有歧义时通，获取建议检索起终点
        //result.routeAddrResult
        NSLog(@"歧义");
    }
    else
    {
        routeSearchBlock(@"失败");
        [UIAlertView showAlertViewWithMessage:@"抱歉、未找到结果" buttonTitles:nil];
       
    }
    _searcher.delegate = nil;
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //在此处理正常结果
        //        NSLog(@"%@",result);
        
        routeSearchBlock(result);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        //当路线起终点有歧义时通，获取建议检索起终点
        //result.routeAddrResult
        NSLog(@"歧义");
    }
    else
    {
        routeSearchBlock(@"失败");
        [UIAlertView showAlertViewWithMessage:@"抱歉、未找到结果" buttonTitles:nil];
        
    }
    _searcher.delegate = nil;
}
-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //在此处理正常结果
        //        NSLog(@"%@",result);
        
        routeSearchBlock(result);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        //当路线起终点有歧义时通，获取建议检索起终点
        //result.routeAddrResult
        NSLog(@"歧义");
    }
    else
    {
        routeSearchBlock(@"失败");
        [UIAlertView showAlertViewWithMessage:@"抱歉、未找到结果" buttonTitles:nil];
        
    }
    _searcher.delegate = nil;
}
#pragma mark - 单例
+ (KeyWordSearchModel *)keyWordModel
{
    static KeyWordSearchModel *keyWord;
    
    if (!keyWord)
    {
        keyWord = [[KeyWordSearchModel alloc]init];
    }
    
    return keyWord;
}
#pragma mark - 百度地理地址搜索
-(void)placeWithKeyWord:(NSString *)place andBlock:(receiveDataBlock)block
{
//    NSLog(@"=%@=%@",place,[[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"]);
    placeSearch = [[BMKSuggestionSearch alloc]init];
    placeSearch.delegate = self;
    BMKSuggestionSearchOption*option = [[BMKSuggestionSearchOption alloc]init];
    option.cityname = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
    option.keyword = place;
    [placeSearch suggestionSearch:option];
    placeResultBlock = block;
}
-(void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result);
    if ([searcher isEqual:placeSearch])
    {
        if (error == BMK_SEARCH_NO_ERROR)
        {
            placeResultBlock(result);
//            for (NSString*str in result.keyList)
//            {
//                 NSLog(@"%@",str);
//            }
        }
    }
}

#pragma mark - 百度地理编码   反编码

- (void)geoCodeWithCity:(NSString *)city address:(NSString *)address andBlock:(receiveDataBlock)block;
{
    //初始化检索对象
    geoSearch =[[BMKGeoCodeSearch alloc]init];
    geoSearch.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= city;
    geoCodeSearchOption.address = address;
    BOOL flag = [geoSearch geoCode:geoCodeSearchOption];

    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    geoResultBlock = block;

}

//实现Deleage处理回调结果
//接收正向编码结果

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if ([searcher isEqual:geoSearch])
    {
        if (error == BMK_SEARCH_NO_ERROR)
        {
            //在此处理正常结果
            geoResultBlock(result);
            
        }
        else
        {
            NSLog(@"抱歉，未找到结果");
        }
        geoSearch.delegate = nil;
    }
    
}

- (void)geoCodeWithCoordinate:(CLLocationCoordinate2D )coordinate andBlock:(receiveDataBlock)block;
{
    
    //初始化地理编码类
    //注意：必须初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    asyResultBlock = block;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
//    NSLog(@"%@  -- %@",result.address ,result.addressDetail);
    asyResultBlock(result);
//    for (BMKPoiInfo*info in result.poiList)
//    {
//        NSLog(@"%@",info.name);
//    }
    _geoCodeSearch.delegate = nil;
}

#pragma mark - 点评请求

- (void)requestDataWithUrl:(NSString *)url params:(NSString *)params reponse:(receiveDataBlock)block
{
//    kAddObserver(self, @selector(receiveData:),kReceiveData, nil);
//    
//    [[[AppDelegate instance] dpapi] requestWithURL:url paramsString:params delegate:nil];
//    currentBlock = block;
}

- (void)receiveData:(NSNotification *)sender
{
    currentBlock(sender.object);
//    kRemover(self, kReceiveData, nil);
}

@end
