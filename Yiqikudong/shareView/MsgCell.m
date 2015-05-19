
//
//  MsgCell.m
//  Yiqikudong
//
//  Created by BK on 15/3/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell
@synthesize msgObject;
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
//        if (msgObject.index)
//        {
            UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 5, 40, 40)];
            imageView.image = [UIImage imageNamed:@"usertitle"];
            [self addSubview:imageView];
            
            contentLabel = [[JXEmoji alloc]initWithFrame:CGRectMake(5, 5, SCREENWIDTH-65, 40)];
//            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.text = msgObject.content;
            [self addSubview:contentLabel];
//        }
    }
    return self;
}
@end
