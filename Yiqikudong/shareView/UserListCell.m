//
//  UserListCell.m
//  Yiqikudong
//
//  Created by BK on 15/3/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "UserListCell.h"

@implementation UserListCell
@synthesize imageview,userId,chatTitle,description,timeCreateLabel,stateView;
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
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 46, 46)];
    
        [self addSubview:imageview];
        
        stateView = [[UIImageView alloc]initWithFrame:CGRectMake(51, 7, 10, 10)];
        stateView.image = [UIImage imageNamed:@"MyCard_Reddot@2x"];
        [stateView setHidden:YES];
        [self addSubview:stateView];
        
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 69, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        [self addSubview:line];
        
        chatTitle = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, SCREENWIDTH-150, 25)];

        chatTitle.textColor = [UIColor blackColor];
        chatTitle.font = [UIFont systemFontOfSize:14];
        [self addSubview:chatTitle];
        
        description = [[UILabel alloc]initWithFrame:CGRectMake(75, 35, SCREENWIDTH-90, 25)];
        description.textColor = [UIColor grayColor];
//        description.text = chatDescription;
        description.font = [UIFont systemFontOfSize:13];
        [self addSubview:description];
        
        timeCreateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-130, 10, 120, 25)];
        timeCreateLabel.font = [UIFont systemFontOfSize:12];
//        timeCreateLabel.text = [NSString stringWithFormat:@"%@",timeCreate];
        timeCreateLabel.textAlignment = NSTextAlignmentRight;
        timeCreateLabel.textColor = [UIColor grayColor];
        [self addSubview:timeCreateLabel];
    }
    return self;
}
@end
