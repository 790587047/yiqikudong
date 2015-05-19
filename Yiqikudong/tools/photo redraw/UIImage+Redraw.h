//
//  UIImage+Redraw.h
//  UI_ScrollView
//
//  Created by Jerry Li on 13-7-1.
//  Copyright (c) 2013年 Li Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Redraw)

+(UIImage*)redraw:(UIImage*)newImage Frame:(CGRect)frame;

@end

@interface  UIButton (addtion)
// main tabBarBtn
+(UIButton*)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame image:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;

// btn
+(UIButton*)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame image:(UIImage *)image title:(NSString *)title target:(id)target andAction:(SEL)action;

// imageAndTitleBtn
+ (UIButton *)packageButtonWithImage:(UIImage *)image Title:(NSString *)title Frame:(CGRect)frame;

// blueSystemBtn
+ (UIButton *)blueSystemButtonWithButtonType:(UIButtonType)type title:(NSString *)title frame:(CGRect)rect;

+(UIButton*)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame backgroundImage:(UIImage*)backgroundImage title:(NSString*)title target:(id)target action:(SEL)action;
@end
