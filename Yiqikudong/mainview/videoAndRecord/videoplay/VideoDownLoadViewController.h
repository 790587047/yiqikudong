//
//  VideoDownLoadViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/2/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDownLoadViewController : BaseController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *downDictionary;

@property (strong, nonatomic) NSIndexPath *selectIndex;

@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;

@end
