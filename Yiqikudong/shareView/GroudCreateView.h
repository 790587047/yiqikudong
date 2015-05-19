//
//  GroudCreateView.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"

@interface GroudCreateView : BaseController<UITextViewDelegate,UITextFieldDelegate>
{
    UITextField*titleText;
    UITextView*descriptionText;
    UISwitch*switchBtn1;
    UISwitch*switchBtn2;
    UILabel*placeholderLabel;
}
@end
