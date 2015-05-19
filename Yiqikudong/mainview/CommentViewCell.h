//
//  CommentViewCell.h
//  Yiqikudong
//
//  Created by wendy on 15/5/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"
#import "CommentModel.h"

@interface CommentViewCell : UITableViewCell

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UILabel     *lblAuthor;
@property (nonatomic, strong) UILabel     *lblTime;
@property (nonatomic, strong) TQRichTextView  *txtContent;

-(void) initData:(CommentModel *) model;
@end
