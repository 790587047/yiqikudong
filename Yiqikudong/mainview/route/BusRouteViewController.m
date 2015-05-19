//
//  BusRouteViewController.m
//  CAVmap
//
//  Created by Ibokan on 14-10-29.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BusRouteViewController.h"
#import "BusRouteTableViewCell.h"

@interface BusRouteViewController ()

@end

@implementation BusRouteViewController

@synthesize busTableView;
@synthesize title;
@synthesize dataArr;
@synthesize taxiInfo;
@synthesize routeData;
@synthesize walkingData,drivingData;

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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 25, 200, 30)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
    if (routeData)
    {
        dataArr = routeData.routes;
        taxiInfo = routeData.taxiInfo;
        [self initTableView];
    }
    if (walkingData)
    {
        dataArr = walkingData.routes;
        taxiInfo = walkingData.taxiInfo;
        [self initTableView];
    }
    if (drivingData)
    {
        dataArr = drivingData.routes;
        taxiInfo = drivingData.taxiInfo;
        [self initTableView];
    }
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [busTableView reloadData];
}

#pragma mark - 数据解析

#pragma mark - 初始化tableView视图
- (void)initTableView
{
    busTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH, SCREENHEIGHT-60) style:UITableViewStylePlain];
    busTableView.delegate = self;
    busTableView.dataSource = self;
    busTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    busTableView.rowHeight = 70;
    busTableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    [self.view addSubview:busTableView];
    
}


#pragma mark - tableView Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == dataArr.count)
    {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != dataArr.count)
    {
        MapSelectPointViewController *map = [[MapSelectPointViewController alloc]init];
        
        if (walkingData)
        {
            map.title = @"步行";
            map.walkingData = walkingData;
        }
        else if(routeData)
        {
            map.title = @"公交";
            map.transitData = routeData;
        }else if(drivingData)
        {
            map.title = @"驾车";
            map.drivingData = drivingData;
        }
        
        map.selectLine = (int)indexPath.row;
        
        [self.navigationController pushViewController:map animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!routeData)
    {
        return dataArr.count;
    }
    return dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellMark";
    BusRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[BusRouteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < dataArr.count)
    {
        if (routeData)
        {
            BMKTransitRouteLine *touteLine = dataArr[indexPath.row];
            
            cell.infoView = [[BusDetialView alloc]initWithFrame:CGRectMake(10, 5,SCREENWIDTH-20 , 60) andData:touteLine];
            
            [cell addSubview:cell.infoView];
        }
        else if(walkingData)
        {
            BMKWalkingRouteLine *walkingLine = dataArr[indexPath.row];
            
            cell.infoView = [[BusDetialView alloc] initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 60) andData:walkingLine];
            
            [cell addSubview:cell.infoView];
        }else if (drivingData)
        {
            BMKDrivingRouteLine *drivingLine = dataArr[indexPath.row];
            
            cell.infoView = [[BusDetialView alloc] initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 60) andData:drivingLine];
            
            [cell addSubview:cell.infoView];
        }
    }
    
    if (indexPath.row == dataArr.count)
    {
        cell.infoView = [[BusDetialView alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 60) andTaxiInfo:taxiInfo];
        cell.infoView.backgroundColor = [UIColor colorWithRed:10/255.0 green:95/255.0 blue:254/255.0 alpha:1];
        [cell addSubview:cell.infoView];
        
    }

    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
