//
//  BusDetialView.h
//  CAVmap
//
//  Created by Ibokan on 14-10-30.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKRouteSearch.h"
#import "UIImageView+SeparateLine.h"
@interface BusDetialView : UIView
{
    NSArray*detailArray;
    BMKTransitRouteLine*lineDetail;
}
@property (strong, nonatomic) UILabel *busTitleLabel;
@property (strong, nonatomic) UILabel *timerLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *walkingLabel;
@property (strong, nonatomic) UIButton *detailButton;

- (id)initWithFrame:(CGRect)frame andData:(id)touteLine;

- (id)initWithFrame:(CGRect)frame andTaxiInfo:(BMKTaxiInfo *)taxiInfo;
@end
