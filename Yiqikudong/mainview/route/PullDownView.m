//
//  KZJPullDownView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "PullDownView.h"

@implementation PullDownView
-(PullDownView*)initWithFrame:(CGRect)frame withTitles:(NSArray*)titleArray withBackgroud:(UIColor *)color
{
    height = titleArray.count>5?5:(int)titleArray.count;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height*35)];
    if ( self)
    {
        titleArr = [NSArray arrayWithArray:titleArray];
        UITableView*tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, height*35) style:UITableViewStylePlain];
//        NSLog(@"===%f",frame.size.width);
        width = frame.size.width;
        tableview.delegate = self;
        tableview.dataSource =self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (color==nil)
        {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.9725, 0.9725, 0.9725, 1 });
            tableview.layer.backgroundColor = colorref;
            CGColorRelease(colorref);
            CGColorSpaceRelease(colorSpace);
            flag = 0;
        }else
        {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.165, 0.165, 0.165, 1 });
            tableview.layer.backgroundColor = colorref;
            CGColorRelease(colorref);
            CGColorSpaceRelease(colorSpace);
            flag = 1;
        }
        
        [self addSubview:tableview];
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markpull";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    NSLog(@"%f",cell.frame.size.width);
    UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(10, 34, width-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = titleArr[indexPath.row];
    if ([[[UIDevice currentDevice]systemVersion] intValue]<8)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (flag == 0)
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }else if (flag ==1)
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate clickTable:cell.textLabel.text];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
