//
//  UIView+CustomActivity.m
//  找医
//
//  Created by 3024 on 14-10-14.
//  Copyright (c) 2014年 author:@zqianhai. All rights reserved.
//

#import "UIView+CustomActivity.h"

@implementation UIView (CustomActivity)

+ (UIView *)creatCustomActivity
{
    static UIView *activityView;
    if (activityView==nil)
    {
        activityView = [[UIView alloc] initWithFrame:kFrame(0, SCREENHEIGHT/2 - 15, SCREENWIDTH, 200)];
        //
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.color = [UIColor brownColor];
        activity.frame = kFrame(80, 20, 30, 30);
        [activity startAnimating];
        [activityView addSubview:activity];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:kFrame(120, 15, 160, 40)];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = [UIColor grayColor];
        lable.text = @"数据加载中,请稍后···";
        [activityView addSubview:lable];
    }
    return activityView;
}

+ (void)setLayerWithView:(UIView *)view
{
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.98];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.4].CGColor;
    view.layer.cornerRadius = 2;
    view.layer.masksToBounds = NO;
}


@end
