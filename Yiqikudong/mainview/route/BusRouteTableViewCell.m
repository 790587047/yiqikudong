//
//  BusRouteTableViewCell.m
//  CAVmap
//
//  Created by Ibokan on 14-10-29.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BusRouteTableViewCell.h"


@implementation BusRouteTableViewCell

@synthesize infoView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
       
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
