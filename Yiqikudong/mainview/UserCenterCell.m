//
//  UserCenterCell.m
//  Yiqikudong
//
//  Created by BK on 15/3/11.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "UserCenterCell.h"

@implementation UserCenterCell
@synthesize imageview,titleLabel;
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
        
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:imageview];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 100, 30)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        NSLog(@"%f==%f",self.frame.size.width,SCREENWIDTH);
        UIImageView*goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.6, 15, 9, 15)];
        goImageView.image = [UIImage imageNamed:@"usercentergo"];
        goImageView.alpha = 0.5;
        [self addSubview:goImageView];
    }
    return self;
}
@end
