//
//  GroudApplyListView.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "ApplyListCell.h"
@interface GroudApplyListView : BaseController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*applyListTable;
}
@end
