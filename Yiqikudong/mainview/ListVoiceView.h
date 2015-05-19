//
//  ListVoiceView.h
//  Yiqikudong
//
//  Created by BK on 15/3/19.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "SearchView.h"
#import "ListViewCell.h"

@interface ListVoiceView : BaseController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *voiceInfoArray;
    UITableView    *listTable;
}
@property (nonatomic,retain) NSString            *kind;

@property (nonatomic,strong) UISegmentedControl  *segment;

@end
