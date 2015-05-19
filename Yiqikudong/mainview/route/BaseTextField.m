//
//  BaseTextField.m
//  SeeDoctorGuide
//
//  Created by 3024 on 14-9-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

@synthesize keyBoardBtn;

- (void)dealloc
{
    kRemover(self, UIKeyboardWillChangeFrameNotification, nil);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)addKeyboardBtn
{
    kAddObserver(self, @selector(keyboardChangeFrame:), UIKeyboardWillChangeFrameNotification, nil);
    [self initKeyBoardButton];
}

- (void)initKeyBoardButton
{
    keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBoardBtn.frame = CGRectMake(kScreenWidth-40, kScreenHeight-30, 30, 30);
    [keyBoardBtn setImage:[UIImage imageNamed:@"keyboard_btn_hide7@2x"] forState:UIControlStateNormal];
    [keyBoardBtn addTarget:self action:@selector(keyboardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.superview.layer addSublayer:keyBoardBtn.layer];
}

- (void)keyboardChangeFrame:(NSNotification *)sender
{
    
    CGRect rect = [[sender.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        keyBoardBtn.frame = kFrame(kScreenWidth-40, rect.origin.y-30, 30, 30);
        
    }];
}

- (void)keyboardBtnAction:(id)sender
{
    if (self.isFirstResponder)
    {
        [keyBoardBtn setImage:[UIImage imageNamed:@"keyboard_btn_show7@2x"] forState:UIControlStateNormal];
        [self resignFirstResponder];
    }
    else
    {
        [keyBoardBtn setImage:[UIImage imageNamed:@"keyboard_btn_hide7@2x"] forState:UIControlStateNormal];
        [self becomeFirstResponder];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end






