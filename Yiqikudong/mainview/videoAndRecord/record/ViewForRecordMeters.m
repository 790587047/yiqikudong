//
//  ViewForRecordMeters.m
//  Yiqikudong
//
//  Created by BK on 15/2/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ViewForRecordMeters.h"

@implementation ViewForRecordMeters
@synthesize peakPowerArray,averagePowerArray;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    float height ,height1;
    for (int i = 0; i<peakPowerArray.count; i++)
    {
        height = [averagePowerArray[i] floatValue]*(8*M_PI/(SCREENWIDTH/70));
        height1 = [peakPowerArray[i] floatValue]*(2*M_PI/50);
//        NSLog(@"%f",height);
        [self drawLinesWithContext:context peakPowerArray:20*sin(height1) averagePowerArray:20*sin(height) width:i*4 alpha:1 percent:1];
    }
//    self.backgroundColor = [UIColor blueColor];
}
- (void) drawLinesWithContext:(CGContextRef)context peakPowerArray:(float)pHeights averagePowerArray:(float)aHeights   width:(float)width alpha:(CGFloat)alpha percent:(CGFloat)percent{
    

    [[UIColor colorWithRed:250/255.0 green:247/255.0 blue:232/255.0 alpha:1] set];
    CGContextSetLineWidth(context, 2);
    
    CGContextStrokePath(context);
//    NSLog(@"%f===%f",aHeights,pHeights);
    CGContextMoveToPoint(context, width, pHeights+aHeights+30);
    CGContextAddLineToPoint(context, width, aHeights+30);
    CGContextStrokePath(context);
}

@end
