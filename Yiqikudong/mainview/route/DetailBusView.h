//
//  DetailBusView.h
//  YiQiWeb
//
//  Created by BK on 14/12/1.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "BaseViewController.h"
#import "BusRouteTableViewCell.h"
@interface DetailBusView : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSArray*detailArray;
@property(strong,nonatomic)BMKTransitRouteLine*lineDetail;
@property(strong,nonatomic)UITableView*detailTableView;
@end
