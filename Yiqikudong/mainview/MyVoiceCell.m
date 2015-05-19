//
//  MyVoiceCell.m
//  Yiqikudong
//
//  Created by BK on 15/3/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "MyVoiceCell.h"
#import "Common.h"

@implementation MyVoiceCell
@synthesize titleLabel,voiceImage,authorLabel,playCountLabel,playTimeLabel,createKindLabel,createTimeLabel,downloadBtn,btnPlay,uploadView,progressView,lblSpeed,lblInfo;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) uploadInfo : (VoiceObject *) obj{
    UIColor *letterColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    
    if (voiceImage == nil) {
        voiceImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 70, 70)];
        voiceImage.center = CGPointMake(voiceImage.center.x,self.center.y + 30);
        voiceImage.layer.masksToBounds = YES;
        voiceImage.layer.cornerRadius = 35.f;
    }
    if (btnPlay == nil) {
        btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPlay.backgroundColor = [UIColor clearColor];
    }
    if (obj.voicePic == nil) {
        [voiceImage setImage:[UIImage imageNamed:@"voiceImage"]];
        [btnPlay setFrame:voiceImage.frame];
        [btnPlay setImage:nil forState:UIControlStateNormal];
    }
    else{
        [voiceImage setImage:[UIImage imageWithData:obj.voicePic]];
        [btnPlay setFrame:CGRectMake(0, 0, 40, 40)];
        btnPlay.center = voiceImage.center;
        [btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    [self addSubview:voiceImage];
    [self addSubview:btnPlay];

    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(voiceImage.frame)+10, 10, 100, 30)];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    }
    titleLabel.text = obj.voiceName;
    
    [self addSubview:titleLabel];
    
    if (authorLabel == nil) {
        authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), 100, 30)];
        authorLabel.textColor = letterColor;
        [authorLabel setFont:[UIFont systemFontOfSize:16.f]];

    }
    authorLabel.text = [NSString stringWithFormat:@"BY %@",obj.voiceAuthor];
    [self addSubview:authorLabel];
    
    //        playCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 70, 70, 25)];
    //        playCountLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    //        playCountLabel.font = [UIFont systemFontOfSize:13];
    //        [self addSubview:playCountLabel];
    
    //播放时间
    if (playTimeLabel == nil) {
        playTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(authorLabel.frame), 150, 25)];
        playTimeLabel.textColor = letterColor;
        playTimeLabel.font = [UIFont systemFontOfSize:14.f];
    }
    playTimeLabel.text = obj.voiceSumTime;
    [self addSubview:playTimeLabel];
    
    //创建时间
    if (createTimeLabel == nil) {
        createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 80, 10, 60, 25)];
        createTimeLabel.font = [UIFont systemFontOfSize:14.f];
        createTimeLabel.textColor = letterColor;
        createTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    createTimeLabel.text = [Common getTimeDifference:obj.createTime].length == 0?@"刚刚":[Common getTimeDifference:obj.createTime];
    [self addSubview:createTimeLabel];
    
    //        createKindLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-40, 35, 35, 25)];
    //        createKindLabel.font = [UIFont systemFontOfSize:12];
    //        createKindLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    //        [self addSubview:createKindLabel];
    
    //下载按钮
    if (downloadBtn == nil) {
        downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadBtn.frame = CGRectMake(SCREENWIDTH-50, CGRectGetMaxY(createTimeLabel.frame)+10, 35, 35);
    }
    
    NSString *imageName ;
    if (obj.downloadFlag) {
        imageName = @"voiceDownloaded";
    }
    else{
        imageName = @"voiceDownload";
        downloadBtn.layer.borderColor = letterColor.CGColor;
        downloadBtn.layer.borderWidth = 1;
        downloadBtn.layer.masksToBounds = YES;
        downloadBtn.layer.cornerRadius = 18.0f;
    }
    [downloadBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:downloadBtn];
    
    if (obj.uploadingFlag) {
        btnPlay.hidden = YES;
        //进度显示view
        if (uploadView == nil) {
            uploadView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(playTimeLabel.frame), SCREENWIDTH, 40)];
            [uploadView setBackgroundColor:[UIColor colorWithRed:237/255.0 green:238/255.0 blue:234/255.0 alpha:1]];
        }
        [self addSubview:uploadView];
        
        if (progressView == nil) {
            progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH / 3, 2)];
            progressView.center = CGPointMake(self.center.x, progressView.center.y+10);
            [progressView setProgressViewStyle:UIProgressViewStyleDefault];
            [progressView setTintColor:[UIColor orangeColor]];
        }
        [uploadView addSubview:progressView];
        
        if (lblInfo == nil) {
            lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(progressView.frame) - 120, 5, 80, 30)];
            lblInfo.text = @"正在上传";
            lblInfo.textColor = [UIColor darkGrayColor];
            [lblInfo setFont:[UIFont systemFontOfSize:12]];
        }
        [uploadView addSubview:lblInfo];
        
        if (lblSpeed == nil) {
            lblSpeed = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progressView.frame)+5, lblInfo.frame.origin.y, 120, 30)];
            lblSpeed.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",0.00,obj.total];
            [lblSpeed setFont:[UIFont systemFontOfSize:12.f]];
            lblSpeed.textColor = [UIColor darkGrayColor];
        }
        [uploadView addSubview:lblSpeed];
        
        downloadBtn.enabled = NO;
    }
    else{
        downloadBtn.enabled = YES;
        btnPlay.hidden = NO;
        if (uploadView != nil) {
            [uploadView removeFromSuperview];
        }
        //正在下载
        if (obj.downloadingFlag) {
            downloadBtn.enabled = NO;
        }
        //已下载
        if (obj.downloadFlag) {
            [downloadBtn setImage:[UIImage imageNamed:@"voiceDownloaded"] forState:UIControlStateNormal];
            downloadBtn.enabled = NO;
        }
    }
}

@end
