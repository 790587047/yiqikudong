//
//  UIImageView+SeparateLine.m
//  CAVmap
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "UIImageView+SeparateLine.h"

@implementation UIImageView (SeparateLine)


+ (id)addSeparateLineWithFrame:(CGRect)frame
{
    UIImageView *separaLine = [[UIImageView alloc]initWithFrame:frame];
    separaLine.image = [UIImage imageNamed:@"sendtocar_dotted_line.jpg"];
    
    return separaLine;
}

+ (UIImageView *)addYSeparateLine:(UIImage *)image Frame:(CGRect)frame
{
    if (!image)
    {
        image = [UIImage imageNamed:@"Aboutpage_SeparatorLine_Vertical@2x"];
    }
    UIImageView *YSeparateLine = [[UIImageView alloc] initWithImage:image highlightedImage:image];
    YSeparateLine.frame = frame;
    
    return YSeparateLine;
}
@end
