//
//  RouteViewController.h
//  CAVmap
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeAndCompenyView.h"
//#import "ChangeDestinationView.h"
#import "BusRouteViewController.h"
#import "BMapKit.h"

@interface RouteViewController : BaseViewController
{
    CGRect upRect, downRect;
    CGRect upPoi, downPoi;
    CLLocationCoordinate2D one, two;
}
@property (assign, nonatomic) NSInteger selectNavBtn; // 选中的导航按钮  1.bus  2. car  3.foot
@property (strong, nonatomic) UIView*change;
@property (assign, nonatomic) CLLocationCoordinate2D toLocation;
@property (assign, nonatomic) CLLocationCoordinate2D origin;
@property (assign, nonatomic) CLLocationCoordinate2D endPoint;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *endName;
@property (assign, nonatomic) BOOL isMylocation,isSelectLocation;
- (void)requestBusDataWithCity:(NSString *)city Start:(CLLocationCoordinate2D)startPin End:(CLLocationCoordinate2D)endPin;//请求公车的
- (void)requestWalkingWithStart:(CLLocationCoordinate2D)startPin End:(CLLocationCoordinate2D)endPin;//请求步行的
- (void)requestDrivingWithStart:(CLLocationCoordinate2D)startPin End:(CLLocationCoordinate2D)endPin;//请求驾车的
//-(void)requestTaxiDataWithCity:(NSString)
@end
