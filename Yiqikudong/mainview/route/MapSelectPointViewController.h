//
//  MapSelectPointViewController.h
//  CAVmap
//
//  Created by Ibokan on 14-10-25.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BaseViewController.h"
#import "MapViewController.h"
#import "BMapKit.h"
typedef void(^selectLocationBlock)(CLLocationCoordinate2D *coordinate);

@interface MapSelectPointViewController : BaseViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,UIScrollViewDelegate>
{
    BMKMapView *mapV;  // mapView
    BMKPinAnnotationView *tipsAnnotation;  // 大头针view
    BMKLocationService*locationService;
    selectLocationBlock block;
    BMKPolyline *polyline;
    BMKPointAnnotation *startPoint,*endPoint;
}

@property (assign, nonatomic) int selectLine;
@property (strong, nonatomic) UIScrollView *busDetailScrollView;  //
@property (strong, nonatomic) BMKWalkingRouteResult *walkingData;
@property (strong, nonatomic) BMKTransitRouteResult *transitData;  // bus数据
@property (strong, nonatomic) BMKDrivingRouteResult *drivingData;  // bus数据
@property (assign, nonatomic) CLLocationCoordinate2D selectLocation;  //选择位置

// 实现块
- (void)realizeBlock:(selectLocationBlock)sender;

// 添加确定按钮
- (void)addConfirmBtn;
@end
