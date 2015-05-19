//
//  GroudRecentCell.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroudRecentCell : UITableViewCell
@property(nonatomic,retain)UIImageView*userImage;
@property(nonatomic,retain)UIImageView*selectedImage;
@property(nonatomic,retain)UILabel*userName;
@property(nonatomic,assign)BOOL userSelected;
@end
