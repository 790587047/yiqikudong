//
//  GroudApplyView.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"

@interface GroudApplyView : BaseController<UITextViewDelegate>
{
    UITextView*descriptionText;
    UILabel*placeholderLabel;
}
@property(nonatomic,retain)NSString*titleName;
@property(nonatomic,retain)NSString*descriptionStr;
@end
