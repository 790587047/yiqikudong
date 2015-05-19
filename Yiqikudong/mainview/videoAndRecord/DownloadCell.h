//
//  DownloadCell.h
//  YiQiWeb
//
//  Created by BK on 14/12/30.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoInfo.h"
@interface DownloadCell : UITableViewCell
{
    CGRect rect;
    UIImageView*imageview;
    
    UIProgressView*progress;
    UILabel*timeLabel;
    UILabel*progressLabel;

    UILabel*nameLabel;
    
}
@property(nonatomic,retain)VideoInfo*info;
@property(nonatomic,retain)UIButton*deleteBtn;
@property(nonatomic,retain)UIButton*downloadingBtn;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)data:(VideoInfo*)infovideo;
@end
