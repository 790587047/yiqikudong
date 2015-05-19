//
//  ChatView.h
//  Yiqikudong
//
//  Created by BK on 15/3/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKChatDelegate.h"
#import "ChatController.h"
#import "UserListCell.h"
#import "ChatDealClass.h"
#import "GroudObject.h"
#import "GroudChatController.h"
@interface ChatView : BaseController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray*onlineUsers;
    NSMutableArray*groudArray;
    
     NSString *chatUserName;
    
    NSMutableArray*stateArray;
    
    UITextField*textfield;
    //实时获取聊天列表的timer
    NSTimer*talkTimer;
    NSTimer*textTimer;
    UIButton*lastBtn;
    UILabel*redLine;
    
    UITableView*groudListTable;
}
@property(nonatomic,strong)UITableView*chatTable;

+(ChatView*)chatView;

@end
