//
//  MyView.h
//  JieTu
//
//  Created by 1026 on 14-8-18.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderView.h"

@interface MyView : UIView
{
    UIImageView*imageBefore,*imageNow;
//    UIView*view1;
    NSMutableArray*arr;
//    int flag;
//    CGContextRef context;
}
@property(nonatomic,strong)UIImagePickerController*picker;
@property(nonatomic,strong)UIViewController*controller;
@property(nonatomic,strong)UIImage*originalImage;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)img;
-(UIImage*)jietu;
@end
