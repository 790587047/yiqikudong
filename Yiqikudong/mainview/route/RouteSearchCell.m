//
//  RouteSearchCell.m
//  YiQiWeb
//
//  Created by BK on 14/12/2.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "RouteSearchCell.h"

@implementation RouteSearchCell
@synthesize searchImage,searchBtn,title,subTitle;
- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        searchImage.image = [UIImage imageNamed:@"ta_map_search_icon@2x"];
        [self addSubview:searchImage];
        
        searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setImage:[UIImage imageNamed:@"icon_search_up_retrieval@2x"] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(SCREENWIDTH-40, 20, 16, 16);
        [self addSubview:searchBtn];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(40, 8, SCREENWIDTH-100, 25)];
        title.font = [UIFont systemFontOfSize:16];
        [self addSubview:title];
        
        subTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 36, SCREENWIDTH-100, 18)];
        subTitle.font = [UIFont systemFontOfSize:14];
        [self addSubview:subTitle];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
