//
//  BaseTextField.h
//  SeeDoctorGuide
//
//  Created by 3024 on 14-9-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

@property (strong, nonatomic) UIButton *keyBoardBtn;

- (void)addKeyboardBtn;

- (void)keyboardBtnAction:(id)sender;
@end

