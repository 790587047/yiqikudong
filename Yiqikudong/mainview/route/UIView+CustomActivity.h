//
//  UIView+CustomActivity.h
//  找医
//
//  Created by 3024 on 14-10-14.
//  Copyright (c) 2014年 author:@zqianhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomActivity)

// 加载中
+ (UIView *)creatCustomActivity;

// 默认cell layer
+ (void)setLayerWithView:(UIView *)view;

@end
