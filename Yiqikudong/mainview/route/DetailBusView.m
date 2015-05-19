//
//  DetailBusView.m
//  YiQiWeb
//
//  Created by BK on 14/12/1.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "DetailBusView.h"

@interface DetailBusView ()

@end

@implementation DetailBusView
@synthesize detailArray,detailTableView,lineDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    for (BMKTransitStep *step in detailArray) {
//        NSLog(@"%@",step.instruction);
//    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 25, 200, 30)];
    titleLabel.text = @"路线详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREENWIDTH, SCREENHEIGHT-60) style:UITableViewStylePlain];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.rowHeight = 70;
    detailTableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    [self.view addSubview:detailTableView];
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}
#pragma mark tableview代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString*mark = @"CellMark";
        BusRouteTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell ==nil)
        {
            cell = [[BusRouteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BusDetialView*detailView =[[BusDetialView alloc]initWithFrame:CGRectMake(10, 5,SCREENWIDTH-20 , 60) andData:lineDetail];
        [detailView.detailButton setHidden:YES];
        cell.infoView = detailView;
        [cell addSubview:cell.infoView];
        return cell;
    }else
    {
        static NSString*mark = @"markDetail";
         UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row ==0)
        {
            cell.detailTextLabel.text = @"我的位置";
        }else if (indexPath.row ==[detailArray count]+1)
        {
            cell.detailTextLabel.text = @"目的地";
        }else
        {
            if ([detailArray[indexPath.row-1] isKindOfClass:[BMKTransitStep class]])
            {
//                NSLog(@"dfggddsasadad");
                BMKTransitStep*step = detailArray[indexPath.row-1];
                cell.detailTextLabel.text = step.instruction;
            }else
            {
//                NSLog(@"--d=d-d=d-d=");
//                BMKTransitStep*step = detailArray[indexPath.row-1];
                cell.detailTextLabel.text = detailArray[indexPath.row-1];
            }
            
        }
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return [detailArray count]+2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
