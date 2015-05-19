//
//  SearchView.h
//  Yiqikudong
//
//  Created by BK on 15/3/20.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "VoiceObject.h"
#import "ListViewCell.h"
#import "MJRefresh.h"
#import "Common.h"
@interface SearchView : BaseController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*voiceInfoArray;
    UITableView*searchTable;
    UISearchBar*searchbar;
    int page;
}
@end
