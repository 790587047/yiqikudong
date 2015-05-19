//
//  GroudSetView.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"

@interface GroudSetView : BaseController<UITextViewDelegate,UITextFieldDelegate>
{
    UITextField*titleText;
    UITextView*descriptionText;
    UISwitch*switchBtn1;
    UISwitch*switchBtn2;
    UILabel*placeholderLabel;
}
@property(nonatomic,retain)NSString*titleName;
@property(nonatomic,retain)NSString*descriptionStr;

@end
