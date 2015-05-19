//
//  FollowCell.h
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface FollowCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) UILabel *lblFollowCount;
@property (nonatomic, strong) UILabel *lblVoiceCount;


-(void) initData:(UserModel *) model;
@end
