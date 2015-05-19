//
//  CollectionReusableCell.m
//  UIConnectionViewDEMO
//
//  Created by admin on 14/11/25.
//  Copyright (c) 2014年 com.woosii. All rights reserved.
//

#import "CollectionReusableCell.h"

@implementation CollectionReusableCell

@synthesize image,btn,timeLabel,progress,btnDownload,backdroundLabel,progressLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        image.userInteractionEnabled = YES;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(image.frame.size.width/4, image.frame.size.width/4, image.frame.size.width/2, image.frame.size.width/2);
        [btn setImage:[UIImage imageNamed:@"bf"] forState:UIControlStateNormal];
        [image addSubview:btn];
        
        
        
        progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        progress.progressViewStyle = UIProgressViewStyleBar;
        progress.hidden = YES;
        [image addSubview:progress];
        
        btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDownload.frame = CGRectMake(0, frame.size.height-20, frame.size.width, 20);
        [btnDownload setTitle:@"下载" forState:UIControlStateNormal];
        btnDownload.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnDownload.hidden = YES;
        [image addSubview:btnDownload];
        
        
        backdroundLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-15, frame.size.width, 15)];
        backdroundLabel.backgroundColor = [UIColor whiteColor];
        backdroundLabel.alpha = 0.5;
        backdroundLabel.hidden = YES;
        [image addSubview:backdroundLabel];
        
        progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 0, 15)];
        progressLabel.backgroundColor = [UIColor blueColor];
        progressLabel.hidden = YES;
        [image addSubview:progressLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-15, frame.size.width, 15)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor whiteColor];
        [image addSubview:timeLabel];
        
        [self.contentView addSubview:image];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
