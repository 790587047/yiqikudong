//
//  voiceDownloadingCell.h
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceInfo.h"
@interface VoiceDownloadingCell : UITableViewCell
{
    CGRect rect;
    UILabel*progressLabel;
    UIProgressView*progress;
    UILabel*nameLabel;
    UIImageView*imageView;
    UILabel*timeLabel;
}
@property(nonatomic,retain)VoiceInfo*info;
-(id)initWithFrame:(CGRect)frame sumTime:(VoiceInfo*)info;
-(void)updateInfo:(VoiceInfo*)info;
@end
