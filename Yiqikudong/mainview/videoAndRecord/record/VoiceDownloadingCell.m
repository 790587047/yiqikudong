//
//  voiceDownloadingCell.m
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "VoiceDownloadingCell.h"

@implementation VoiceDownloadingCell

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
    if (self)
    {
        rect = frame;
        [self updateInfo:info];
        
    }
    return self;
}
-(void)updateInfo:(VoiceInfo*)info
{
    if (imageView ==nil)
    {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, rect.size.height-10, rect.size.height-10)];
        imageView.image = [UIImage imageNamed:@"voiceimage2"];
        [self.contentView addSubview:imageView];
    }
    
    if (nameLabel==nil)
    {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width+25, 5, 100, rect.size.height/2)];
                nameLabel.text = info.name;
//        nameLabel.text = @"dsadsda";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:nameLabel];
    }else
    {
        nameLabel.text = info.name;
    }
    
    if (timeLabel==nil)
    {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 5, 90, rect.size.height-25)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor lightGrayColor];
        int second = (int)info.sumTime%60;
        int mimute = ((int)info.sumTime - second)/60>60?((int)info.sumTime - second)/60%60:((int)info.sumTime - second)/60;
        int hour = ((int)info.sumTime - second)/60>60?((int)info.sumTime - second)/60/60:0;
        timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,mimute,second];
        [self.contentView addSubview:timeLabel];
    }else
    {
        int second = (int)info.sumTime%60;
        int mimute = ((int)info.sumTime - second)/60>60?((int)info.sumTime - second)/60%60:((int)info.sumTime - second)/60;
        int hour = ((int)info.sumTime - second)/60>60?((int)info.sumTime - second)/60/60:0;
        timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,mimute,second];
    }
    if (progress==nil)
    {
        if (isPad)
        {
            progress = [[UIProgressView alloc]initWithFrame:CGRectMake(imageView.frame.size.width+25, nameLabel.frame.size.height+22, SCREENWIDTH-(imageView.frame.size.width+10)*2.5, 15)];
        }else
        {
            progress = [[UIProgressView alloc]initWithFrame:CGRectMake(imageView.frame.size.width+25, nameLabel.frame.size.height+15, SCREENWIDTH-(imageView.frame.size.width+10)*2.5, 15)];
        }
        
        progress.progress = info.progress;
        progress.tintColor = [UIColor redColor];
        [self.contentView addSubview:progress];
    }else
    {
        progress.progress = info.progress;
    }
    
    if (progressLabel==nil)
    {
        progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-55, nameLabel.frame.size.height+5, 40, 20)];
        float a = info.downloadMemory/1024/1024;
        float b =info.sumMemory/1024/1024;
        int c = (int)(a/b);
        int num = c>0?(int)c:0;
        progressLabel.textColor = [UIColor redColor];
        progressLabel.text = [NSString stringWithFormat:@"%d%@",num,@"%"];
        progressLabel.font = [UIFont systemFontOfSize:14];
        progressLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:progressLabel];
    }else
    {
        float a = info.downloadMemory/1024/1024;
        float b =info.sumMemory/1024/1024;
        int c = (int)((a/b)*100);
        int num = c>0?(int)c:0;
        progressLabel.text = [NSString stringWithFormat:@"%d%@",num,@"%"];
    }
    if (isPad)
    {
        progressLabel.font = [UIFont systemFontOfSize:25];
        nameLabel.font = [UIFont systemFontOfSize:25];
        timeLabel.font = [UIFont systemFontOfSize:25];
    }
}

@end
