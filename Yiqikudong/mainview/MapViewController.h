//
//  MapViewController.h
//  YiQiWeb
//
//  Created by BK on 14/11/28.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "RouteViewController.h"
#import "KeyWordSearchModel.h"
#import "DetailBusView.h"
#import "PullDownView.h"
@interface MapViewController : BaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKBusLineSearchDelegate,PullDownViewProtocol>
{
    BMKMapView*mapview;
    BMKLocationService*locationService;
    BMKPoiSearch*search;
    BMKBusLineSearch* buslinesearch;
//    BMKPointAnnotation* annotation;
    
    NSMutableArray* busPoiArray;
    
    BMKPointAnnotation*selectedItem;
    
    UIButton *locationBtn; // 定位按钮
    BOOL isTouchLocationBtn;  // 是否单击定位按钮
    UIImage *follow, *compass;  // 跟随和罗盘图片
    
     NSArray *listArr;
     int flag1;
    
    CLLocationManager  *locationManager;
}
@property (retain, nonatomic) BMKUserLocation *currentLocation;  // 当前位置
@property (retain, nonatomic) PullDownView *pullView;

+ (MapViewController *)onlyOneMainViewController;  // 单例
@end
