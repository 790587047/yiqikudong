//
//  BusRouteViewController.h
//  CAVmap
//
//  Created by Ibokan on 14-10-29.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BaseViewController.h"
#import "MapSelectPointViewController.h"

@interface BusRouteViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BMKWalkingRouteResult *walkingData;
@property (strong, nonatomic) BMKTransitRouteResult *routeData;
@property (strong, nonatomic) BMKDrivingRouteResult *drivingData;
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) BMKTaxiInfo *taxiInfo;
@property (strong, nonatomic) UITableView *busTableView;
@property (strong, nonatomic) NSString *title;

@end
