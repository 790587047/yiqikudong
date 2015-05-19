//
//  HomeAndCompenyView.m
//  CAVmap
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "HomeAndCompenyView.h"
#import "RouteViewController.h"
#import "UIView+CustomActivity.h"
@implementation HomeAndCompenyView

@synthesize home,compeny;
@synthesize homeLocation,compenyLocation;
@synthesize currenViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)onlyHomeAndCompenyView
{
    static HomeAndCompenyView *homeAndCompeny;
    if (!homeAndCompeny)
    {
        homeAndCompeny = [[HomeAndCompenyView alloc]init];
    }
    
    return homeAndCompeny;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.98];
        self.frame = kFrame(0, 0, kScreenWidth-20, 80);
        
        [UIView setLayerWithView:self];
        
        NSArray *icon = @[[UIImage imageNamed:@"icon_home@2x"],[UIImage imageNamed:@"icon_company@2x"]];
        NSArray *text = @[@"回家",@"去公司"];
        
        void(^labelBlock)(UILabel *) = ^(UILabel *label){
            label.text = @"点击设置";
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:14];
            label.userInteractionEnabled = NO;
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        };
        
        for (int i = 0 ; i < icon.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom
                                               frame:kFrame(0, i*40, kScreenWidth-20, 40)
                                               image:[UIImage imageNamed:@"game_detail_header_bg"]
                                               title:nil
                                              target:self
                                           andAction:@selector(homeOrCompanyAction:)];
            btn.tag = 101+i;
            btn.imageView.layer.opacity = 0.1;
            [self addSubview:btn];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:kFrame(10, 10, 20, 20)];
            imageV.image = icon[i];
            [btn addSubview:imageV];
            
            
            UILabel *label = [[UILabel alloc]initWithFrame:kFrame(40, 10, 40+i*20, 20)];
            label.text = text[i];
            label.userInteractionEnabled = NO;
            label.font = [UIFont systemFontOfSize:14];
            [btn addSubview:label];
            
            UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            editBtn.frame = kFrame(kScreenWidth-50, 10, 20, 20);
            editBtn.tag = 111+i;
            [editBtn setImage:[UIImage imageNamed:@"traffic_edit"] forState:UIControlStateNormal];
            [editBtn addTarget:self action:@selector(eidtAddressAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:editBtn];
            
            if (i == 0)
            {
                home = [[UILabel alloc]initWithFrame:kFrame(80, 10, 180, 20)];
                labelBlock(home);
                if ([kUserDictionary objectForKey:@"homeAddress"])
                {
                    home.text = [kUserDictionary objectForKey:@"homeAddress"];
                    homeLocation.latitude = [[kUserDictionary objectForKey:@"homeLatitude"] doubleValue];
                    homeLocation.longitude = [[kUserDictionary objectForKey:@"homeLongitude"] doubleValue];
                }
                [btn addSubview:home];
            }
            else
            {
                compeny = [[UILabel alloc]initWithFrame:kFrame(100, 10, 160, 20)];
                labelBlock(compeny);
                if ([kUserDictionary objectForKey:@"companyAddress"])
                {
                    compeny.text = [kUserDictionary objectForKey:@"companyAddress"];
                    compenyLocation.latitude = [[kUserDictionary objectForKey:@"companyLatitude"] doubleValue];
                    compenyLocation.longitude = [[kUserDictionary objectForKey:@"companyLongitude"] doubleValue];
                }
                [btn addSubview:compeny];
                
            }
            
        }
        // 添加分隔线
        [self addSubview:[UIImageView addSeparateLineWithFrame:kFrame(0, 40, kScreenWidth-20, 1)]];
        
        
    }
    return self;
}

- (void)homeOrCompanyAction:(UIButton *)sender
{
    if (sender.tag == 101)
    {
        if ([kUserDictionary objectForKey:@"homeAddress"])
        {
            [self isTypeWayWithWhere:homeLocation];
        }
        else
        {
            [self eidtAddressAction:sender];
        }
    }
    else
    {
        if ([kUserDictionary objectForKey:@"companyAddress"])
        {
            [self isTypeWayWithWhere:compenyLocation];
        }
        else
        {
            [self eidtAddressAction:sender];
        }
        
    }
    
}

- (void)isTypeWayWithWhere:(CLLocationCoordinate2D)location
{
    if ([currenViewController isKindOfClass:[RouteViewController class]])
    {
        RouteViewController *toute = (RouteViewController *)currenViewController;
        switch (toute.selectNavBtn)
        {
            case 1:
            {
//                NSLog(@"*-----%@",toute.change.city);
//                NSLog(@"*--%f  %f",toute.change.origin.latitude,toute.change.origin.longitude);
//                NSLog(@"---* %f   %f",location.latitude,location.longitude);
//                
                [toute requestBusDataWithCity:toute.city Start:toute.origin End:location];
            }
                
                break;
                
            case 2:
            {
                [toute requestDrivingWithStart:toute.origin End:location];
            }
                break;
            case 3:
            {
                [toute requestWalkingWithStart:toute.origin End:location];
            }
                break;
                
            default:
                
                break;
        }
    }
}

- (void)eidtAddressAction:(UIButton *)sender
{
    
    RouteSearchViewController *routeSearch = [[RouteSearchViewController alloc]init];
    
    
    [routeSearch realizeBlock:^(BMKReverseGeoCodeResult *result) {
        NSString *latStr, *longStr, *addresStr;
        
        if (sender.tag == 111 || sender.tag == 101)
        {
            home.text = result.address;
//            nameStr = @"home";
            latStr = @"homeLatitude";
            longStr = @"homeLongitude";
            addresStr = @"homeAddress";
            homeLocation = result.location;
            
        }
        else
        {
            compeny.text = result.address;
//            nameStr = @"company";
            latStr = @"companyLatitude";
            longStr = @"companyLongitude";
            addresStr = @"companyAddress";
            compenyLocation = result.location;
        }
        NSNumber *latLocaiton = [NSNumber numberWithDouble:result.location.latitude];
        NSNumber *longLocation = [NSNumber numberWithDouble:result.location.longitude];
        [kUserDictionary setObject:latLocaiton forKey:latStr];
        [kUserDictionary setObject:longLocation forKey:longStr];
        [kUserDictionary setObject:result.address forKey:addresStr];
        
        
    }];
    
    routeSearch.selectPointText = @"输入名称或地址";
    [currenViewController.navigationController pushViewController:routeSearch animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
