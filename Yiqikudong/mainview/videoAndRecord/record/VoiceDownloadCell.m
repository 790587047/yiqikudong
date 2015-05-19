//
//  voiceDownloadCell.m
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "VoiceDownloadCell.h"

@implementation VoiceDownloadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithFrame:(CGRect)frame sumTime:(VoiceInfo*)info
{
    self = [super initWithFrame:frame];
    if (self!=nil)
    {
        UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, frame.size.height-10, frame.size.height-10)];
        imageView.image = [UIImage imageNamed:@"voiceimage1"];
        [self.contentView addSubview:imageView];
        
        UILabel*nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width+25, 5, 100, frame.size.height-10)];
        nameLabel.text = info.name;
//        nameLabel.text = @"dsa";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:nameLabel];
        
        UILabel*timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 10, 90, frame.size.height-10)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor lightGrayColor];
        
        int second = (int)info.sumTime%60;
        int mimute = ((int)info.sumTime - second)/60>60?((int)info.sumTime - second)/60%60:((int)info.sumTime - second)/60;
        int hour = ((int)info.sumTime - second)/60>60?((int)info.sumTime - second)/60/60:0;
        timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,mimute,second];
        [self.contentView addSubview:timeLabel];
        
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-1, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
        
        if (isPad)
        {
            nameLabel.font = [UIFont systemFontOfSize:25];
            timeLabel.font = [UIFont systemFontOfSize:25];
        }
    }
    return self;
   
}


@end
