//
//  DownloadCell.m
//  YiQiWeb
//
//  Created by BK on 14/12/30.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell
@synthesize info,deleteBtn,downloadingBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self!=nil)
    {
        rect = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 1;
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.831, 0.831, 0.831, 1 });
//        self.layer.borderColor = colorref;
//        CGColorRelease(colorref);
//        CGColorSpaceRelease(colorSpace);
        [self data:info];
    }
    return self;
}
-(void)data:(VideoInfo*)infovideo
{
//    if (label ==nil)
//    {
//        label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREENWIDTH-10, rect.size.height-10)];
////        label.backgroundColor =[UIColor whiteColor];
//        [self addSubview:label];
//    }
    if (imageview==nil)
    {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 100, rect.size.height-10)];
        imageview.image = infovideo.image;
        UILabel*backgroud = [[UILabel alloc]initWithFrame:imageview.bounds];
        backgroud.alpha = 0.5;
        backgroud.backgroundColor = [UIColor blackColor];
        [imageview addSubview:backgroud];
        imageview.userInteractionEnabled = YES;
        [self addSubview:imageview];
    }else
    {
        imageview.userInteractionEnabled = YES;
        imageview.image = infovideo.image;
    }
    
//    if (deleteBtn ==nil )
//    {
//        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        deleteBtn.frame = CGRectMake(SCREENWIDTH-60, 20, 30, 35);
//        [deleteBtn setImage:[UIImage imageNamed:@"delete_03"] forState:UIControlStateNormal];
//        [self addSubview:deleteBtn];
//    }
    
    if (downloadingBtn==nil)
    {
        downloadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadingBtn.frame = CGRectMake(0, 0, 100, 20);
        downloadingBtn.center = CGPointMake(imageview.frame.size.width/2, imageview.frame.size.height/2);
        [downloadingBtn setTitle:@"下载中" forState:UIControlStateNormal];
        [downloadingBtn setImage:[UIImage redraw:[UIImage imageNamed:@"pause"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
        [downloadingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        downloadingBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [imageview addSubview:downloadingBtn];
    }
    
    if (progress ==nil)
    {
        if (isPad)
        {
            progress = [[UIProgressView alloc]initWithFrame:CGRectMake(imageview.frame.size.width+20, rect.size.height-10, SCREENWIDTH - imageview.frame.size.width-100, 10)];
        }else
        {
            progress = [[UIProgressView alloc]initWithFrame:CGRectMake(imageview.frame.size.width+20, rect.size.height-10, SCREENWIDTH - imageview.frame.size.width-80, 10)];
        }
        
        progress.progressTintColor = [UIColor redColor];
        progress.progress = infovideo.progress;
        [self addSubview:progress];
    }else
    {
        progress.progress = infovideo.progress;
    }
    
    if (timeLabel==nil)
    {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width+20, progress.frame.origin.y-25, 160, 25)];
        float a = infovideo.downloadMemory/1024/1024;
        float b =infovideo.sumMemory/1024/1024;
        timeLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",a,b];
        timeLabel.textColor = [UIColor lightGrayColor];
        if (isPad)
        {
            timeLabel.font = [UIFont systemFontOfSize:18];
        }else
        {
            timeLabel.font = [UIFont systemFontOfSize:13];
        }
        
        [self addSubview:timeLabel];
    }
    else
    {
        float a = infovideo.downloadMemory/1024/1024;
        float b =infovideo.sumMemory/1024/1024;
        timeLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",a,b];
    }
    
    
    if (progressLabel==nil)
    {
        if (isPad)
        {
            progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-75, timeLabel.frame.origin.y, 60, 25)];
        }else
        {
            progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-55, timeLabel.frame.origin.y, 40, 25)];
        }
        
        float a = infovideo.downloadMemory/1024/1024;
        float b =infovideo.sumMemory/1024/1024;
        int c = (int)(a/b);
        int num = c>0?(int)c:0;
        progressLabel.textColor = [UIColor redColor];
        progressLabel.text = [NSString stringWithFormat:@"%d%@",num,@"%"];
        if (isPad)
        {
            progressLabel.font = [UIFont systemFontOfSize:20];
        }else
        {
            progressLabel.font = [UIFont systemFontOfSize:14];
        }
        
        progressLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:progressLabel];
    }else
    {
        float a = infovideo.downloadMemory/1024/1024;
        float b =infovideo.sumMemory/1024/1024;
        int c = (int)((a/b)*100);
        int num = c>0?(int)c:0;
        progressLabel.text = [NSString stringWithFormat:@"%d%@",num,@"%"];
    }
    
    if (nameLabel ==nil)
    {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width+20, 10, 100, 20)];
        if (infovideo.nameTitle==nil)
        {
            nameLabel.text = @"无标题";
        }else
        {
            nameLabel.text = infovideo.nameTitle;
        }
        nameLabel.textColor = [UIColor lightGrayColor];
        if (isPad)
        {
            nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        }else
        {
            nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        }
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nameLabel];
    }
    
}
@end
