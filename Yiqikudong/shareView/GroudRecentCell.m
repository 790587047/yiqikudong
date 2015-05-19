//
//  GroudRecentCell.m
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "GroudRecentCell.h"

@implementation GroudRecentCell
@synthesize selectedImage,userImage,userName,userSelected;
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
        selectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 25, 25)];
        selectedImage.image = [UIImage imageNamed:@"groud_add_round"];
        selectedImage.layer.cornerRadius = 12.5;
//        selectedImage.layer.masksToBounds = YES;
        [self.contentView addSubview:selectedImage];
        
        userImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, 9, 37, 37)];
        [self.contentView addSubview:userImage];
        
        userName = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, SCREENWIDTH-100, 35)];
        [self.contentView addSubview:userName];
        
        
    }
    return self;
}



@end
