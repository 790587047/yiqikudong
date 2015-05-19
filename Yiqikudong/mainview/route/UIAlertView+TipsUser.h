//
//  UIAlertView+TipsUser.h
//  CAVmap
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (TipsUser)

+ (void)showAlertViewWithMessage:(NSString*)message buttonTitles:(NSString *)buttonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
