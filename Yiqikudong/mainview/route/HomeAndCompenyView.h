//
//  HomeAndCompenyView.h
//  CAVmap
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteSearchViewController.h"

@interface HomeAndCompenyView : UIView

@property (strong, nonatomic) UIViewController *currenViewController;  // 当前viewController
@property (assign, nonatomic) CLLocationCoordinate2D homeLocation;
@property (assign, nonatomic) CLLocationCoordinate2D compenyLocation;
@property (strong, nonatomic) UILabel *home;
@property (strong, nonatomic) UILabel *compeny;


+ (id)onlyHomeAndCompenyView;

@end
