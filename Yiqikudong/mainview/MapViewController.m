//
//  MapViewController.m
//  YiQiWeb
//
//  Created by BK on 14/11/28.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize currentLocation,pullView;
-(void)dealloc
{
    if (mapview)
    {
        mapview = nil;
    }
    
}
+ (MapViewController *)onlyOneMainViewController
{
    static MapViewController *mainV;
    if (mainV==nil)
    {
        mainV = [[MapViewController alloc]init];
    }
    return mainV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    backbutton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backbutton;
//    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn = self.backButton;
    [self.backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 25, 200, 30)];
    titleLabel.text = @"地图";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
#ifdef __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
#endif
    
    //适配ios7
    //    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    //    {
    //        self.navigationController.navigationBar.translucent = NO;
    //    }
    search = [[BMKPoiSearch alloc]init];
    //    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"地图标记"])
    //    {
    //        NSLog(@"dsf");
    //        mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    //    }else
    //    {
    //        NSLog(@"dsfasdfdgfh==");
    mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH, SCREENHEIGHT-(44+[UIApplication sharedApplication].statusBarFrame.size.height)-40)];
    //    }
    
    mapview.delegate = self;
    mapview.showsUserLocation = NO;
    mapview.userTrackingMode = BMKUserTrackingModeFollow;
    mapview.showsUserLocation = YES;
    mapview.zoomLevel = 15;//地图尺寸
    mapview.mapType = BMKMapTypeStandard;
    mapview.showMapScaleBar = YES;
    
    [self.view addSubview:mapview];
    
    locationService = [[BMKLocationService alloc]init];
    locationService.delegate = self;
//        [locationService startUserLocationService];
    
    // 放大缩小按钮初始化
    NSArray *btnImageArr = [NSArray arrayWithObjects:[UIImage redraw:[UIImage imageNamed:@"main_icon_zoomin"] Frame:kFrame(0, 0, 20, 20)],[UIImage redraw:[UIImage imageNamed:@"main_icon_zoomout"] Frame:kFrame(0, 0, 20, 20)], nil];
    
    for (int i = 0; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = kFrame(kScreenWidth-40, mapview.frame.size.height-120+i*30, 40, 40);
        [btn setImage:btnImageArr[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"main_bottombar_background"] forState:UIControlStateNormal];
        
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(zoomTransFormAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    // 定位按钮初始化
    locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];;
    locationBtn.frame = kFrame(kScreenWidth-40, mapview.frame.size.height-40, 40, 40);
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"main_bottombar_background"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"navi_idle_gps_unlocked"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(loactionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    
    // 跟随图片，罗盘图片初始化
    follow = [UIImage redraw:[UIImage imageNamed:@"main_icon_follow"] Frame:kFrame(0, 0, 30, 30)];
    compass = [UIImage redraw:[UIImage imageNamed:@"main_icon_compass"] Frame:kFrame(0, 0, 30, 30)];
    
    // 是否单击locationBtn
    isTouchLocationBtn = NO;
    
    [self initTabBar];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"detailRoute" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailRoute:) name:@"detailRoute" object:nil];
    
    
}


-(void)detailRoute:(NSNotification*)notif
{
    NSArray*detailArray = [[notif userInfo] objectForKey:@"detailArray"];
    DetailBusView*detailBusView = [[DetailBusView alloc]init];
    if ([detailArray[0] isKindOfClass:[BMKDrivingStep class]])
    {
        detailBusView.detailArray = [self dealArray:detailArray];
    }else if ([detailArray[0] isKindOfClass:[BMKRouteStep class]])
    {
        detailBusView.detailArray = detailArray;
    }
    
    detailBusView.lineDetail = [[notif userInfo]objectForKey:@"TransitRouteLine"];
    //    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:detailBusView animated:YES];
}
//处理自驾车的导航数据。
-(NSArray*)dealArray:(NSArray*)array
{
    NSMutableArray*detailArray = [[NSMutableArray alloc]init];
    for (BMKDrivingStep*step in array)
    {
        NSString*str = step.instruction;
        NSArray*strArr = [str componentsSeparatedByString:@","];
        for (NSString*str1 in strArr)
        {
            NSString*string = str1;
            //            int a = 0;
            NSString*str2;
            //            NSLog(@"%@",string);
            if ([string rangeOfString:@"<"].length>0)
            {
                NSLog(@"%@",string);
                str2 = string;
                while ([string rangeOfString:@"<"].length>0)
                {
                    str2 = [string stringByReplacingOccurrencesOfString:[string substringWithRange:NSMakeRange([string rangeOfString:@"<"].location, [string rangeOfString:@">"].location-[string rangeOfString:@"<"].location+1)] withString:@""];
                    string = str2;
                }
                NSLog(@"%@",str2);
                [detailArray addObject:str2];
            }else
            {
                [detailArray addObject:str1];
            }
        }
    }
    return detailArray;
}


-(void)initTabBar
{
    UIView*tab = [[UIView alloc]initWithFrame:CGRectMake(0, mapview.frame.size.height+mapview.frame.origin.y, SCREENWIDTH, 40)];
    tab.tag = 2000;
    tab.backgroundColor = [UIColor clearColor];
    //    tab.layer.backgroundColor = [UIColor whiteColor];
    UIToolbar*toolBar = [[UIToolbar alloc]initWithFrame:tab.bounds];
    [tab addSubview:toolBar];
    //    tab.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tab];
    
    for (int i = 0; i<2; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(SCREENWIDTH/2*i, 5, SCREENWIDTH/2, 30);
        btn.tag = 1000+i;
        if (i ==0) {
            [btn setTitle:@"附近的店" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"main_icon_nearby"] forState:UIControlStateNormal];
            
            
        }else
        {
            [btn setTitle:@"路线查询" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"main_icon_route"] forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        //        btn.backgroundColor = [UIColor blackColor];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [tab addSubview:btn];
    }
    
}
#pragma mark - ButtonClicksAction
// 放大缩小地图
- (void)zoomTransFormAction:(UIButton*)sender
{
    if (sender.tag == 101)
    {
        if (mapview.zoomLevel != 19)
            mapview.zoomLevel++;
    }
    else
    {
        if (mapview.zoomLevel != 3)
            mapview.zoomLevel--;
    }
}

// 开启定位
- (void)loactionBtnAction:(UIButton*)sender
{
    isTouchLocationBtn = YES;
    
    // 转换定位方式
    if ([[sender imageForState:UIControlStateNormal]isEqual:compass] || [[sender imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"navi_idle_gps_unlocked"]])
    {
        mapview.userTrackingMode = BMKUserTrackingModeNone;
        mapview.userTrackingMode = BMKUserTrackingModeFollow;
        [sender setImage:follow forState:UIControlStateNormal];
    }
    else if ([[sender imageForState:UIControlStateNormal]isEqual:follow])
    {
        mapview.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
        [sender setImage:compass forState:UIControlStateNormal];
        
    }
    mapview.showsUserLocation = YES;
    isTouchLocationBtn = NO;
}
-(void)btnAction:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"附近的店"])
    {
        if (!flag1)
        {
            if (pullView==nil)
            {
                listArr = [NSArray arrayWithObjects:@"餐厅",@"电影",@"KTV",@"酒店",@"公交",@"景点",@"小吃", nil];
                int height = listArr.count>5?5:(int)listArr.count;
                pullView = [[PullDownView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-40-35*height, SCREENWIDTH/2, 35*height) withTitles:listArr withBackgroud:nil];
                pullView.delegate = self;
                pullView.layer.cornerRadius = 10;
                pullView.layer.masksToBounds = YES;
                
            }
            [self.view addSubview:pullView];
            [self.view bringSubviewToFront:btn.superview];
            flag1 = 1;
        }else
        {
            flag1 = 0;
            if (pullView!=nil)
            {
                [pullView removeFromSuperview];
            }
        }
    }else if([btn.titleLabel.text isEqualToString:@"路线查询"])
    {
        //        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"地图标记"];
        RouteViewController*route = [[RouteViewController alloc]init];
//        [self.navigationController.navigationItem hidesBackButton];
        route.origin = currentLocation.location.coordinate;
        [self.navigationController pushViewController:route animated:YES];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

-(void)clickTable:(NSString *)title
{
    NSLog(@"%@",title);
    BMKNearbySearchOption*nearSearch = [[BMKNearbySearchOption alloc]init];
    nearSearch.pageCapacity = 0;
    nearSearch.pageCapacity = 10;
    nearSearch.keyword  = title;
    nearSearch.radius = 1000;
    nearSearch.location = currentLocation.location.coordinate;
    BOOL flag = [search poiSearchNearBy:nearSearch];
    if (flag)
    {
        NSLog(@"chenggong");
    }else
    {
        NSLog(@"shibai");
    }
    [pullView removeFromSuperview];
    flag1 = 0;
}


-(void)willStartLocatingUser
{
    NSLog(@"jhgfd");
}
-(void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

//用户位置变化后调用这个
-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    mapview.centerCoordinate = userLocation.location.coordinate;
    //    NSLog(@"============");
    NSNumber *latNum = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
    NSNumber *longNum = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];
    
    [kUserDictionary setObject:latNum forKey:@"latitude"];
    [kUserDictionary setObject:longNum forKey:@"longitude"];
    currentLocation = userLocation;
//    NSLog(@"===%f",userLocation.location.coordinate.latitude);
    [[KeyWordSearchModel keyWordModel]geoCodeWithCoordinate:userLocation.location.coordinate andBlock:^(id result){
        BMKReverseGeoCodeResult*result1 = (BMKReverseGeoCodeResult*)result;
        //        NSLog(@"%@",result1.addressDetail.city);
        [kUserDictionary setObject:result1.addressDetail.city forKey:@"MyCity"];
        
    }];
    
    [mapview updateLocationData:userLocation];
}
//用户方向更新后调用
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [mapview updateLocationData:userLocation];
    
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //    NSLog(@"dsdfgrtghseazhthhbxfgf");
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, (annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    UIButton*goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBtn.frame = CGRectMake(0, 0, 40, 40);
    [goBtn setTitle:@"前往" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [goBtn addTarget: self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    goBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    annotationView.rightCalloutAccessoryView = goBtn;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    selectedItem =(BMKPointAnnotation*)view.annotation;
    NSLog(@"%f==%f",selectedItem.coordinate.latitude,selectedItem.coordinate.longitude);
    //    UIBarButtonItem *morebutton = [[UIBarButtonItem alloc] initWithTitle:@"前往" style:UIBarButtonItemStyleBordered target:self action:@selector(goSearch:)];
    //    morebutton.tintColor = [UIColor whiteColor];
    //    self.navigationItem.rightBarButtonItem = morebutton;
    
}
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    //    UIBarButtonItem *morebutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(goSearch:)];
    //    morebutton.tintColor = [UIColor whiteColor];
    //    self.navigationItem.rightBarButtonItem = morebutton;
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //    NSLog(@"didAddAnnotationViews");
    
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:mapview.annotations];
    [mapview removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [mapview addAnnotation:item];
            mapview.zoomLevel = 17;
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                mapview.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.alpha = 1;
    [super viewWillAppear:animated];
    //    [self.navigationItem hidesBackButton];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    mapview.frame = CGRectMake(0, 44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH, SCREENHEIGHT-(44+[UIApplication sharedApplication].statusBarFrame.size.height)-40);
    locationBtn.frame = kFrame(kScreenWidth-40, mapview.frame.size.height+mapview.frame.origin.y-50, 40, 40);
    UIView*tab = (UIView*)[self.view viewWithTag:2000];
    tab.frame = CGRectMake(0, mapview.frame.size.height+mapview.frame.origin.y, SCREENWIDTH, 40);
    UIButton*btn1 = (UIButton*)[self.view viewWithTag:101];
    UIButton*btn2 = (UIButton*)[self.view viewWithTag:102];
    btn1.frame = kFrame(kScreenWidth-40, mapview.frame.size.height+mapview.frame.origin.y-120, 40, 40);
    btn2.frame = kFrame(kScreenWidth-40, mapview.frame.size.height+mapview.frame.origin.y-120+30, 40, 40);
    
    
    [mapview viewWillAppear];
    mapview.delegate = self;
    locationService.delegate = self;
    [locationService startUserLocationService];
    search.delegate = self;
    buslinesearch = [[BMKBusLineSearch alloc]init];
    buslinesearch.delegate = self;
    busPoiArray = [[NSMutableArray alloc]init];
//    self.navigationController.navigationBar.hidden = NO;
    if (pullView!=nil)
    {
        [pullView removeFromSuperview];
        flag1 = 0;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
    [mapview viewWillDisappear];
    [locationService stopUserLocationService];
    mapview.delegate = nil;
    locationService.delegate = nil;
    locationService = nil;
    search.delegate = nil;
    buslinesearch.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) goback{
    //    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"地图标记"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//        [self.navigationController.navigationBar reloadInputViews];
//    });
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
    //    NSLog(@"52");
}

-(void) goSearch:(UIButton *)morebutton
{
    if ([morebutton.titleLabel.text isEqualToString:@"前往"])
    {
        RouteViewController*route = [[RouteViewController alloc]init];
        route.toLocation = selectedItem.coordinate;
        route.origin = currentLocation.location.coordinate;
        route.endName = selectedItem.title;
        [self.navigationController pushViewController:route animated:YES];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
