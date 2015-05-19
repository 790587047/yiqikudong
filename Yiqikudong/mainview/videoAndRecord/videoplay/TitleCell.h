//
//  TitleCell.h
//  YiQiWeb
//
//  Created by wendy on 15/1/19.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleCell : UITableViewCell

@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
- (void) initView : (NSString *)title;

@end
