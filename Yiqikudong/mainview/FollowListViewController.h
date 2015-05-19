//
//  FollowListViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

/**
 *  标识关注还是粉丝页面
 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, copy) NSString *userId;

@end
