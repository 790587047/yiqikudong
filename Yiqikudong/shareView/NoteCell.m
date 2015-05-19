//
//  NoteCell.m
//  Yiqikudong
//
//  Created by BK on 15/2/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell
@synthesize title,image;
- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self)
    {
        title = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH-60, 50)];
        title.textColor =[UIColor blackColor];
        [self addSubview:title];
        image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 16, 18, 18)];
        [self addSubview:image];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
