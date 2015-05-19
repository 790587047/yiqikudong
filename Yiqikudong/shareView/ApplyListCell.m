//
//  ApplyListCell.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ApplyListCell.h"

@implementation ApplyListCell
@synthesize userImage,userName,agreeBtn,rejectBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        userImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 45, 45)];
        [self.contentView addSubview:userImage];
        
        userName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 35)];
        [self.contentView addSubview:userName];
        
        agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeBtn.frame = CGRectMake(SCREENWIDTH-140, 7, 60, 41);
        agreeBtn.layer.cornerRadius = 5;
        agreeBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green:199/255.0 blue:44/255.0 alpha:1];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:agreeBtn];
        
        rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rejectBtn.frame = CGRectMake(SCREENWIDTH-70, 7, 60, 41);
        rejectBtn.layer.cornerRadius = 5;
        rejectBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:66/255.0 blue:70/255.0 alpha:1];
        [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        rejectBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:rejectBtn];
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
        [self.contentView addSubview:line];
    }
    return self;
}
@end
