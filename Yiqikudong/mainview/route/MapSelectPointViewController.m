//
//  MapSelectPointViewController.m
//  CAVmap
//
//  Created by Ibokan on 14-10-25.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "MapSelectPointViewController.h"
#import "BusDetialView.h"
#import "UIImage+Redraw.h"
#import "UIAlertView+TipsUser.h"
@interface MapSelectPointViewController ()
{
    BOOL isClickMap;
}
@end

@implementation MapSelectPointViewController

@synthesize walkingData;
@synthesize transitData,drivingData;
@synthesize selectLocation;
@synthesize title;
@synthesize selectLine;
@synthesize busDetailScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    self.view.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                   nil];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 25, 200, 30)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
    isClickMap = NO;  // 是否点击了map
    [self initMapView];  // 初始化地图
    [self initButtonView];  // 初始化按钮
    if (transitData)
    {
        [self mapViewAddView];
        [self initScrollView];
    }
    if (walkingData)
    {
        BMKWalkingRouteLine *line = walkingData.routes[0];
        for (int i = 0; i < line.steps.count ; i++)
        {
            BMKWalkingStep*walking = line.steps[i];
            // 画线
            polyline = [BMKPolyline polylineWithPoints:walking.points count:walking.pointsCount];
            [mapV addOverlay:polyline];
        }
        BusDetialView *detailView = [[BusDetialView alloc]initWithFrame:CGRectMake(20, 70, SCREENWIDTH-40, 60) andData:line];
        [self.view addSubview:detailView];
        
    }
    if (drivingData)
    {
        BMKDrivingRouteLine *line = drivingData.routes[0];
        for (int i = 0; i < line.steps.count ; i++)
        {
            BMKDrivingStep*driving = line.steps[i];
            // 画线
            polyline = [BMKPolyline polylineWithPoints:driving.points count:driving.pointsCount];
            [mapV addOverlay:polyline];
        }
        
        BusDetialView *detailView = [[BusDetialView alloc]initWithFrame:CGRectMake(20, 70, SCREENWIDTH-40, 60) andData:line];
        [self.view addSubview:detailView];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapV viewWillAppear];
    locationService.delegate = self;
    mapV.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [mapV viewWillDisappear];
    locationService.delegate = nil;
    mapV.delegate = nil;
}

#pragma mark - 初始化地图视图
- (void)initMapView
{
    
    // 初始化地图
    mapV = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH,SCREENHEIGHT-38)];
    
    // 地图比例尺
    mapV.showMapScaleBar = YES;
    mapV.mapScaleBarPosition = CGPointMake(10,SCREENHEIGHT-100);
    mapV.delegate = self;
//    [mapV setCompassPosition:CGPointMake(10,70)];  // 指南针位置
//    mapV.showsUserLocation = YES;
    mapV.userTrackingMode = BMKUserTrackingModeFollow;
    mapV.showsUserLocation = YES;
    mapV.mapType = BMKMapTypeStandard; // 地图类型 ： 标准地图
    mapV.zoomLevel = 19;// 地图尺寸

//    [mapV addAnnotation:]
//    locationService = [[BMKLocationService alloc]init];
//    locationService.delegate = self;
//    [locationService startUserLocationService];
    
    if ([[MapViewController onlyOneMainViewController] currentLocation])
    {
//         NSLog(@"============1");
        [mapV updateLocationData:[[MapViewController onlyOneMainViewController] currentLocation]];
        BMKCoordinateSpan span = {0.002,0.002};
        BMKCoordinateRegion region = {[[MapViewController onlyOneMainViewController] currentLocation].location.coordinate,span};
        [mapV setRegion:region animated:YES];
        mapV.showsUserLocation = YES;
    }
    else if ([kUserDictionary objectForKey:@"latitude"] && [kUserDictionary objectForKey:@"longitude"])
    {
//         NSLog(@"===========2");
        double a = [[kUserDictionary objectForKey:@"latitude"]doubleValue];
        double b = [[kUserDictionary objectForKey:@"longitude"]doubleValue];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:a longitude:b];
        mapV.centerCoordinate = location.coordinate;
//        BMKCoordinateSpan span = {0.001,0.001};
//        BMKCoordinateRegion region = {location.coordinate,span};
//        [mapV setRegion:region animated:YES];
    }
    [self.view addSubview:mapV];
    
}
//-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
//{
//    mapV.centerCoordinate = userLocation.location.coordinate;
//}
#pragma mark - mapViewWithBusRoute
- (void)mapViewAddView
{
  
    BMKTransitRouteLine *routeline = transitData.routes[selectLine];
    
    // 添加起点
    BMKGroundOverlay *startImage = [BMKGroundOverlay groundOverlayWithPosition:routeline.starting.location
                                                                 zoomLevel:18
                                                                    anchor:CGPointMake(0.0f,0.0f)
                                                                      icon:[UIImage imageNamed:@"routemap_start_img@2x"]];
    [mapV addOverlay:startImage];
    
    
    // 添加终点大头针
    BMKGroundOverlay *endImage = [BMKGroundOverlay groundOverlayWithPosition:routeline.terminal.location
                                                                 zoomLevel:18
                                                                    anchor:CGPointMake(0.0f,0.0f)
                                                                      icon:[UIImage imageNamed:@"routemap_end_img@2x"]];
    [mapV addOverlay:endImage];
    

    for (int i = 0; i < routeline.steps.count ; i++)
    {
        BMKTransitStep *transit = routeline.steps[i];
        // 画线
        polyline = [BMKPolyline polylineWithPoints:transit.points count:transit.pointsCount];
        [mapV addOverlay:polyline];
    }
    
    [self setMapViewRegionWithStart:routeline.starting.location End:routeline.terminal.location];
}

- (void)initScrollView
{
    busDetailScrollView = [[UIScrollView alloc]initWithFrame:kFrame(0, 70, SCREENWIDTH, 60)];
    busDetailScrollView.contentSize = CGSizeMake(SCREENWIDTH*transitData.routes.count, 60);
    busDetailScrollView.pagingEnabled = YES;
    busDetailScrollView.showsVerticalScrollIndicator = NO;
    busDetailScrollView.showsHorizontalScrollIndicator = NO;
    busDetailScrollView.delegate = self;
    busDetailScrollView.contentOffset = CGPointMake(selectLine*SCREENWIDTH, 0);
    for (int i = 0;i < transitData.routes.count; i++)
    {
        BMKTransitRouteLine *transit = transitData.routes[i];
        BusDetialView *detailView = [[BusDetialView alloc]initWithFrame:kFrame(20+i*SCREENWIDTH, 0, SCREENWIDTH-40, 60) andData:transit];
        
        [busDetailScrollView addSubview:detailView];
    }
    [self.view addSubview:busDetailScrollView];
}

- (void)setMapViewRegionWithStart:(CLLocationCoordinate2D)start End:(CLLocationCoordinate2D)end
{
    CLLocationCoordinate2D cender;

    cender.latitude = start.latitude > end.latitude ? (end.latitude + (start.latitude - end.latitude)/2) : (start.latitude + (end.latitude - start.latitude)/2) ;
    cender.longitude = start.longitude > end.longitude ? (end.longitude + (start.longitude - end.longitude)/2) : (start.longitude + (end.longitude - start.longitude)/2) ;
    
    BMKCoordinateSpan span = {(end.latitude - start.latitude)*2,(end.longitude - start.longitude)*2};
    BMKCoordinateRegion region = {cender,span};
    [mapV setRegion:region animated:YES];
    mapV.showsUserLocation = NO;
}

#pragma mark - button init
- (void)initButtonView
{
    // 放大缩小按钮初始化
    NSArray *btnImageArr = [NSArray arrayWithObjects:[UIImage redraw:[UIImage imageNamed:@"main_icon_zoomin"] Frame:kFrame(0, 0, 20, 20)],[UIImage redraw:[UIImage imageNamed:@"main_icon_zoomout"] Frame:kFrame(0, 0, 20, 20)], nil];
    
    for (int i = 0; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = kFrame(SCREENWIDTH-40, SCREENHEIGHT-80+i*30, 40, 40);
        [btn setImage:btnImageArr[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"main_bottombar_background"] forState:UIControlStateNormal];
        
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(zoomTransFormAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)addConfirmBtn
{
    //  确定按钮
    UIButton *confirmBtn = [UIButton blueSystemButtonWithButtonType:UIButtonTypeRoundedRect title:@"确定" frame:kFrame(SCREENWIDTH-45, 27.5, 40, 25)];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

#pragma mark - ButtonClicksAction
// 放大缩小地图
- (void)zoomTransFormAction:(UIButton*)sender
{
    if (sender.tag == 101)
    {
        if (mapV.zoomLevel != 19)
            mapV.zoomLevel++;
    }
    else
    {
        if (mapV.zoomLevel != 3)
            mapV.zoomLevel--;
    }
}

- (void)confirmAction:(id)sender
{
    if (isClickMap)
    {
        block(&selectLocation);
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [UIAlertView showAlertViewWithMessage:@"未选择地点" buttonTitles: nil];
    }
}

#pragma mark - mapView Delegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (!transitData)
    {
        [self addAnnotationWithCoordinate:coordinate];
    }
    
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi
{
    if (!transitData)
    {
        [self addAnnotationWithCoordinate:mapPoi.pt];
    }
    
}

- (void)addAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    // 移除之前的大头针
    [mapV removeAnnotations:mapV.annotations];
    selectLocation = coordinate;
    // 添加一个大头针
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = selectLocation;
    [mapV addAnnotation:annotation];
    isClickMap = YES;
}

// 定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
    NSString *AnnotationViewID = @"location";
    tipsAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    
    // 从天上掉下效果
    //    tipsAnnotation.animatesDrop = YES;
    // 设置可拖拽
    tipsAnnotation.draggable = YES;
    // 设置大头针图标
    tipsAnnotation.image = [UIImage imageNamed:@"icon_openmap_focuse_mark"];
    
    return tipsAnnotation;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor colorWithRed:10/255.0 green:95/255.0 blue:254/255.0 alpha:1] colorWithAlphaComponent:1];
        polylineView.fillColor = [UIColor blackColor];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView *groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        
        return groundView;
    }
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    selectLine =  (int)(scrollView.contentOffset.x/SCREENWIDTH);

    NSArray *arr = [NSArray arrayWithArray:mapV.overlays];
    [mapV removeOverlays:arr];
    [self mapViewAddView];
}

#pragma mark - 实现block
- (void)realizeBlock:(selectLocationBlock)sender
{
    block = sender;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
