//
//  NoteBaseView.h
//  Yiqikudong
//
//  Created by BK on 15/2/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
@interface NoteBaseView : BaseController<UITextViewDelegate>
{
    NSMutableArray*noteArray;
    NSMutableArray*phoneArray;
    NSMutableArray*nameArray;
}
@property(nonatomic)UITextView*receiveText;
@property(nonatomic)UITextView*contentText;
@property(nonatomic)UIButton*sendBtn;
@property(nonatomic)UIButton*addPersonBtn;
@property(nonatomic)NSString*contentStr;

@end
