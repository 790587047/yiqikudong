//
//  PersonalAnchorViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalAnchorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;

@property (nonatomic, strong) NSMutableArray *voiceArray;

/**
 *  接收用户ID
 */
@property (nonatomic, copy  ) NSString       *userId;
/**
 *  用户头像
 */
@property (nonatomic, strong) UIImageView    *imgHead;
@property (nonatomic, strong) UILabel        *lblUserName;
@property (nonatomic, strong) UILabel        *lblInfo;
@property (nonatomic, strong) UILabel        *lblCount;
@end
