//
//  UIImageView+SeparateLine.h
//  CAVmap
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SeparateLine)

+ (id)addSeparateLineWithFrame:(CGRect)frame;
// 添加垂直的分隔线
+ (UIImageView *)addYSeparateLine:(UIImage *)image Frame:(CGRect)frame;
@end
