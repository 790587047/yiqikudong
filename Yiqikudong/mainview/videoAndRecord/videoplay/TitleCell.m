//
//  TitleCell.m
//  YiQiWeb
//
//  Created by wendy on 15/1/19.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import "TitleCell.h"
#import "VideoModel.h"

@implementation TitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"UpAccessory"];
    }
    else{
        self.arrowImageView.image = [UIImage imageNamed:@"DownAccessory"];
    }
}

-(void)initView:(NSString *)title{
    if (self.lblTitle == nil) {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 280, 21)];
        [self addSubview:self.lblTitle];
        [self.lblTitle setTextColor:[UIColor lightGrayColor]];
        [self.lblTitle setFont:[UIFont boldSystemFontOfSize:[VideoModel iPad] ? 32.0f : 18.0f]];
        [self.lblTitle setTextAlignment: NSTextAlignmentLeft];
    }
    [self.lblTitle setText:title];
    
    if (self.arrowImageView == nil) {
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 30, 17, 18, 10)];
        [self.arrowImageView setImage:[UIImage imageNamed:@"UpAccessory"]];
        [self addSubview:self.arrowImageView];
    }
}

@end
