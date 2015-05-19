//
//  VoicePlayView.h
//  YiQiWeb
//
//  Created by BK on 15/1/9.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceInfo.h"
@interface VoicePlayView : UIView

@property(nonatomic,retain)UIProgressView*progress;
@property(nonatomic,retain)UIButton*starBtn;
@property(nonatomic,retain)UIButton*nextBtn;
@property(nonatomic,retain)UIButton*lastBtn;
@property(nonatomic,retain)UILabel*timeLabel;
@property(nonatomic,retain)UILabel*titleLabel;
-(instancetype)initWithFrame:(CGRect)frame info:(VoiceInfo*)info;
-(NSAttributedString*)getTimeStringWithCurrentTime:(float)currentTime sumTime:(float)sumTime;
@end
