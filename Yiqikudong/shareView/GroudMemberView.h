//
//  GroudMemberView.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "GroudMemberAddView.h"
#import "ChatView.h"
@interface GroudMemberView : BaseController
{
    UIScrollView*baseView;
    int flagDelete;
}
@property(nonatomic,retain)NSArray*memberArray;
@property(nonatomic,retain)UIViewController*viewController;
@property(nonatomic,retain)UIViewController*chatListController;
@end
