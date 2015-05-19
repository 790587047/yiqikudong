//
//  NoteView.h
//  Yiqikudong
//
//  Created by BK on 15/2/15.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import "NoteCell.h"
@interface NoteView : BaseController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray*personInfo;
    NSMutableArray*phoneArray;
    NSMutableArray*numArray;
    UITableView*tableview;
    
    MFMessageComposeViewController*messageController;
}
@property(nonatomic,retain)NSMutableArray*noteArray;
@property(nonatomic,retain)NSString*contentStr;
@end
