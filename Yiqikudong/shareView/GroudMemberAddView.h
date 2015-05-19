//
//  GroudMemberAddView.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "GroudRecentCell.h"
@interface GroudMemberAddView : BaseController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*recentMenberTable;
    NSMutableArray*personInfo;
    NSMutableArray*numArray;
    UIButton*selectAll;
    UIButton*sureAction;
}
@property(nonatomic,retain)NSArray*recentArray;
@property(nonatomic,retain)UIViewController*viewController;
@end
