//
//  RouteViewController.m
//  CAVmap
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "RouteViewController.h"
#import "KeyWordSearchModel.h"
#import "UIImage+Redraw.h"
#import "UIImageView+SeparateLine.h"
#import "UIView+CustomActivity.h"
@interface RouteViewController ()
{
    NSArray *navBarImageArr;  // 图片视图
}
@end

@implementation RouteViewController

@synthesize selectNavBtn;
@synthesize change;
@synthesize toLocation;
@synthesize origin,endPoint;
@synthesize city,endName;
@synthesize isMylocation,isSelectLocation;

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
    
    [self initNavBarView]; // 初始化navBar视图
    [self initView]; // 初始化视图
    selectNavBtn = 1;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    
}

#pragma mark - 初始化视图

- (void)initView
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    self.view.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                   nil];
    // 搜索按钮
    UIButton *searchBtn = [UIButton blueSystemButtonWithButtonType:UIButtonTypeRoundedRect title:@"搜索" frame:kFrame(SCREENWIDTH-45, 27.5, 40, 25)];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton = searchBtn;
    [self.view addSubview:searchBtn];
    
    // 起点终点
    change = [[UIView alloc]initWithFrame:kFrame(10, 65, SCREENWIDTH-20, 80)];
//    change.viewController = self;
    [self setChange];
    
    if (toLocation.latitude != 0 && toLocation.longitude != 0)
    {
        [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.endPoint = toLocation;
        self.isSelectLocation = YES;
        UIButton *btn = (UIButton *)[change viewWithTag:102];
        UILabel *label = btn.subviews[0];
        label.textColor = [UIColor grayColor];
        UIImageView *imageV = btn.subviews[1];
        imageV.image = [UIImage imageNamed:@"icon_route_end@2x"];
        [[KeyWordSearchModel keyWordModel] geoCodeWithCoordinate:self.endPoint andBlock:^(BMKReverseGeoCodeResult *result) {
        
            label.text = result.address;
        }];
    }
    else
    {
        // 搜索按钮不可按
        [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        searchBtn.userInteractionEnabled = NO;
        searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    [self.view addSubview:change];

    // 分割线
    [self.view addSubview:[UIImageView addSeparateLineWithFrame:kFrame(10, 145, SCREENWIDTH-20, 1)]];

    // 回家或者去公司视图
    HomeAndCompenyView *homeView = [HomeAndCompenyView onlyHomeAndCompenyView];
    homeView.currenViewController = self;
    homeView.frame = kFrame(10, 160, SCREENWIDTH-20, 80);
    [self.view addSubview:homeView];
}

#pragma mark - 初始化navBar视图

- (void)initNavBarView
{
    navBarImageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"common_topbar_route_bus_normal"],
                      [UIImage imageNamed:@"common_topbar_route_car_normal"],
                      [UIImage imageNamed:@"common_topbar_route_foot_normal"],
                      [UIImage imageNamed:@"common_topbar_route_bus_pressed"],
                      [UIImage imageNamed:@"common_topbar_route_car_pressed"],
                      [UIImage imageNamed:@"common_topbar_route_foot_pressed"], nil];
   
    for (int i = 0; i < 3; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom
                                           frame:kFrame((SCREENWIDTH-125)/2+i*50, 25, 25, 25)
                                           image:navBarImageArr[i]
                                           title:nil
                                          target:self
                                       andAction:@selector(navBarBtnAction:)];
        if (i == 0)
        {
            [btn setImage:navBarImageArr[3] forState:UIControlStateNormal];
        }
        btn.tag = 101+i;
        [self.view addSubview:btn];
    }
}

#pragma mark - ButtonClicksAction
// navBar按钮方法
- (void)navBarBtnAction:(UIButton *)sender
{
    if (selectNavBtn != sender.tag-100)
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:selectNavBtn+100];
        [btn setImage:navBarImageArr[selectNavBtn-1] forState:UIControlStateNormal];
        selectNavBtn = sender.tag-100;
        [sender setImage:navBarImageArr[selectNavBtn+2] forState:UIControlStateNormal];
    }
    
}

- (void)searchBtnAction:(id)sender
{
    switch (selectNavBtn)
    {
        case 1:
        {
            [self requestBusDataWithCity:city Start:origin End:endPoint];
            
        }
            break;
            
        case 2:
        {
            [self requestDrivingWithStart:origin End:endPoint];
        }
            break;
        case 3:
        {
            //            NSLog(@"%f   %f   %f   %f",change.origin.latitude,change.origin.longitude,change.endPoint.latitude,change.endPoint.longitude);
            [self requestWalkingWithStart:origin End:endPoint];
        }
            break;

        default:
            break;
    }
    
    
}

- (void)requestBusDataWithCity:(NSString *)city Start:(CLLocationCoordinate2D)startPin End:(CLLocationCoordinate2D)endPin
{
    UIView *activity = [UIView creatCustomActivity];
    [self.view addSubview:activity];
    
    [[KeyWordSearchModel keyWordModel] requearRouteSearchWithsearchBlock:^(BMKRouteSearch *search){
         BMKPlanNode *start = [[BMKPlanNode alloc]init];
         start.pt = startPin;
         BMKPlanNode *end = [[BMKPlanNode alloc]init];
         end.pt = endPin;
        
         BMKTransitRoutePlanOption *transit = [[BMKTransitRoutePlanOption alloc]init];
         transit.city = city;
         transit.from = start;
         transit.to = end;
         
         BOOL searchResult = [search transitSearch:transit];
         if (searchResult)
         {
             NSLog(@"transit检索发送成功");
         }
         else
         {
             [activity removeFromSuperview];
             NSLog(@"transit检索发送失败");
         }
         
     } andBlock:^(BMKTransitRouteResult *result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             BusRouteViewController *bus = [[BusRouteViewController alloc]init];
             bus.routeData = result;
             bus.title = @"方案";
             [self.navigationController pushViewController:bus animated:YES];
         }
         [activity removeFromSuperview];
         
     }];
}
-(void)requestDrivingWithStart:(CLLocationCoordinate2D)startPin End:(CLLocationCoordinate2D)endPin
{
    UIView *activity = [UIView creatCustomActivity];
    [self.view addSubview:activity];
    
    [[KeyWordSearchModel keyWordModel] requearRouteSearchWithsearchBlock:^(BMKRouteSearch *search)
     {
         BMKPlanNode *start = [[BMKPlanNode alloc]init];
         start.pt = startPin;
         BMKPlanNode *end = [[BMKPlanNode alloc]init];
         end.pt = endPin;
         
         BMKDrivingRoutePlanOption *driving = [[BMKDrivingRoutePlanOption alloc]init];
         driving.from = start;
         driving.to = end;
         
         BOOL searchResult = [search drivingSearch:driving];
         if (searchResult)
         {
             NSLog(@"driving检索发送成功");
         }
         else
         {
             [activity removeFromSuperview];
             NSLog(@"driving检索发送失败");
         }
         
     } andBlock:^(BMKDrivingRouteResult *result)
     {
         NSLog(@"%@",result);
         if (![result isKindOfClass:[NSString class]])
         {
             BusRouteViewController *bus = [[BusRouteViewController alloc]init];
             bus.drivingData = result;
             bus.title = @"驾车方案";
             [self.navigationController pushViewController:bus animated:YES];
         }
         
         [activity removeFromSuperview];
         
     }];
}
- (void)requestWalkingWithStart:(CLLocationCoordinate2D)startPin End:(CLLocationCoordinate2D)endPin
{
    UIView *activity = [UIView creatCustomActivity];
    [self.view addSubview:activity];
    
    [[KeyWordSearchModel keyWordModel] requearRouteSearchWithsearchBlock:^(BMKRouteSearch *search)
     {
         BMKPlanNode *start = [[BMKPlanNode alloc]init];
         start.pt = startPin;
         BMKPlanNode *end = [[BMKPlanNode alloc]init];
         end.pt = endPin;
         
         BMKWalkingRoutePlanOption *walking = [[BMKWalkingRoutePlanOption alloc]init];
         walking.from = start;
         walking.to = end;
         
         BOOL searchResult = [search walkingSearch:walking];
         if (searchResult)
         {
             NSLog(@"walking检索发送成功");
         }
         else
         {
             [activity removeFromSuperview];
             NSLog(@"walking检索发送失败");
         }
         
     } andBlock:^(BMKWalkingRouteResult *result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             BusRouteViewController *bus = [[BusRouteViewController alloc]init];
             bus.walkingData = result;
             bus.title = @"步行方案";
             [self.navigationController pushViewController:bus animated:YES];
         }
         
         [activity removeFromSuperview];
         
     }];
}


- (void)setChange
{
//    self = [super initWithFrame:frame];

//    if (self)
//    {
        // Initialization code
        
        isMylocation = isSelectLocation = NO;
    
        // 从哪去哪
        AMBlurView *blueView = [[AMBlurView alloc]initWithFrame:change.bounds];
        blueView.blurTintColor = [UIColor whiteColor];
        [change addSubview:blueView];
        
        // 变换按钮
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                                 frame:kFrame(20, 25, 30, 30)
                                                 image:[UIImage imageNamed:@"icon_route_change@2x"]
                                                 title:nil
                                                target:self
                                             andAction:@selector(changeBtnAction:)];
        [change addSubview:changeBtn];
        
        // 分割线
        [change addSubview:[UIImageView addSeparateLineWithFrame:kFrame(60, 40, kScreenWidth-80, 1)]];
        
        //
        NSArray *imageArr = @[[UIImage imageNamed:@"icon_route_location"],[UIImage imageNamed:@"icon_indoorDetail_min"]];
        NSArray *textArr = @[@"我的位置",@"输入终点"];
        
        for (int i = 0; i < textArr.count; i++)
        {
            UIView *btnView = [[UIView alloc]initWithFrame:kFrame(65, 40*i, kScreenWidth-75, 40)];
            btnView.tag = 101+i;
            
            UILabel *label = [[UILabel alloc]initWithFrame:kFrame(20, 10, 200, 20)];
            label.text = textArr[i];
            if (i==textArr.count-1&&endName!=nil)
            {
                label.text = endName;
//                isSelectLocation = YES;
            }
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor colorWithRed:10/255.0 green:95/255.0 blue:254/255.0 alpha:1];
            
            i == 1 ? (label.textColor = [UIColor grayColor]) : nil;
            i == 0 ? (upRect = btnView.frame) : (downRect = btnView.frame);
            
            UITapGestureRecognizer *tap;
            tap = i == 0 ? ([[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelOneTapAction:)]) : ([[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTwoTapAction:)]) ;
            [btnView addGestureRecognizer:tap];
            
            [btnView addSubview:label];
            [change addSubview:btnView];
            
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:kFrame(0, 12.5, 15, 15)];
            imageV.image = imageArr[i];
            [btnView addSubview:imageV];
            
        }
        one = [MapViewController onlyOneMainViewController].currentLocation.location.coordinate;
//        origin =  one;
        NSLog(@"%@===%@",[MapViewController onlyOneMainViewController],[MapViewController onlyOneMainViewController].currentLocation);
        if (origin.latitude != 0 && origin.longitude != 0)
        {
        //            city = [MapViewController onlyOneMainViewController].cityName;
            if ([kUserDictionary objectForKey:@"MyCity"])
            {
                city = [kUserDictionary objectForKey:@"MyCity"];
            }
            isMylocation = YES;
        }
    
        
//    }
//    return self;
}

// 交换方法
- (void)changeBtnAction:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i < 2; i++)
        {
            UIView *view = [change viewWithTag:101+i];
            view.frame.origin.y == downRect.origin.y ? (view.frame = upRect) : (view.frame = downRect);
            
            UILabel *label = view.subviews[0];
            
            if ([label.text isEqualToString:@"输入终点"])
            {
                label.text = @"输入起点";
            }
            else if ([label.text isEqualToString:@"输入起点"])
            {
                label.text = @"输入终点";
            }
        }
    }];
    
    
        if (isMylocation)
        {
            [self setImageViewWithTag:101 point:one];
        }
        if (isSelectLocation)
        {
            [self setImageViewWithTag:102 point:two];
        }
    //    NSLog(@"origin === %f   %f",origin.latitude,origin.longitude);
    //    NSLog(@"endPoint === %f   %f",endPoint.latitude,endPoint.longitude);
}

- (void)setImageViewWithTag:(int)tag point:(CLLocationCoordinate2D )coordinate
{
    UIView *view = [change viewWithTag:tag];
    UILabel *label = [view.subviews objectAtIndex:0];
    UIImageView *imageV = [view.subviews objectAtIndex:1];
        [self ifViewFrameWithSender:view YesBlocak:^{
            if (!isSelectLocation)
            {
                endPoint.latitude = 0;
                endPoint.longitude = 0;
            }
            origin = coordinate;
    
            tag == 101 ? ([label.text isEqualToString:@"我的位置"]) ? nil :(imageV.image = [UIImage imageNamed:@"icon_route_st@2x"]):(imageV.image = [UIImage imageNamed:@"icon_route_st@2x"]);
    
        } NoBlock:^{
            if (!isSelectLocation)
            {
                origin.latitude = 0;
                origin.longitude = 0;
            }
    
            endPoint = coordinate;
            tag == 101 ? ([label.text isEqualToString:@"我的位置"]) ? nil :(imageV.image = [UIImage imageNamed:@"icon_route_end@2x"]):(imageV.image = [UIImage imageNamed:@"icon_route_end@2x"]);
    
        }];
    
}

- (void)labelOneTapAction:(id)sender
{
    UIView *view = [change viewWithTag:101];
    [self setLocationAction:view];
}

- (void)labelTwoTapAction:(id)sender
{
    UIView *view = [change viewWithTag:102];
    [self setLocationAction:view];
}


// 选择地址
- (void)setLocationAction:(UIView *)sender
{
    RouteSearchViewController *search = [[RouteSearchViewController alloc]init];
    UIImageView *imageV = sender.subviews[1];
    [self ifViewFrameWithSender:sender YesBlocak:^{
        
        search.selectPointText = @"输入起点";
        
    } NoBlock:^{
        
        search.selectPointText = @"输入终点";
        
    }];
    [search realizeBlock:^(id result1) {
        
        if ([result1 isKindOfClass:[BMKReverseGeoCodeResult class]])
        {
           BMKReverseGeoCodeResult*result = (BMKReverseGeoCodeResult*)result1;
            [self ifViewFrameWithSender:sender YesBlocak:^{
                imageV.image  = [UIImage imageNamed:@"icon_route_st@2x"];
                origin = result.location;
            } NoBlock:^{
                imageV.image  = [UIImage imageNamed:@"icon_route_end@2x"];
                endPoint = result.location;
            }];
            
            UIView *view = [change viewWithTag:101];
            if (sender == view)
            {
                isMylocation = YES;
                one = result.location;
            }
            else
            {
                isSelectLocation = YES;
                two = result.location;
            }
            UILabel *label = sender.subviews[0];
            label.textColor = [UIColor grayColor];
            label.text = result.address;
            //            UIImageView*image = sender.subviews[1];
            //            image
            
            city = result.addressDetail.city;
            if (isMylocation && isSelectLocation)
            {
                self.searchButton.userInteractionEnabled = YES;
                [self.searchButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
                self.searchButton.layer.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
            }
        }else if ([result1 isKindOfClass:[BMKGeoCodeResult class]])
        {
            BMKGeoCodeResult*result = (BMKGeoCodeResult*)result1;
            [self ifViewFrameWithSender:sender YesBlocak:^{
                imageV.image  = [UIImage imageNamed:@"icon_route_st@2x"];
                origin = result.location;
            } NoBlock:^{
                imageV.image  = [UIImage imageNamed:@"icon_route_end@2x"];
                endPoint = result.location;
            }];
            
            UIView *view = [change viewWithTag:101];
            if (sender == view)
            {
                isMylocation = YES;
                one = result.location;
            }
            else
            {
                isSelectLocation = YES;
                two = result.location;
            }
            UILabel *label = sender.subviews[0];
            label.textColor = [UIColor grayColor];
            label.text = result.address;
            //            UIImageView*image = sender.subviews[1];
            //            image
            
            city = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCity"];
            if (isMylocation && isSelectLocation)
            {
                self.searchButton.userInteractionEnabled = YES;
                [self.searchButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
                self.searchButton.layer.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
            }
        }
        
    }];
    
    [self.navigationController pushViewController:search animated:YES];
    
}

- (void)ifViewFrameWithSender:(UIView *)sender YesBlocak:(void(^)())yesBlock NoBlock:(void(^)())noBlock
{
    if (sender.frame.origin.y == upRect.origin.y)
        yesBlock();
    else
        noBlock();
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
