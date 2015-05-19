//
//  UserListCell.h
//  Yiqikudong
//
//  Created by BK on 15/3/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListCell : UITableViewCell
@property (nonatomic,retain) NSString* userId;
@property (nonatomic,retain) UILabel*chatTitle;
@property (nonatomic,retain) UILabel*description;
@property (nonatomic,retain) UIImageView*imageview;
@property (nonatomic,retain) UILabel*timeCreateLabel;
@property (nonatomic,retain) UIImageView*stateView;
@end
