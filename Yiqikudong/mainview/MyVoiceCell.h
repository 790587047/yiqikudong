//
//  MyVoiceCell.h
//  Yiqikudong
//
//  Created by BK on 15/3/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceObject.h"

@interface MyVoiceCell : UITableViewCell

@property (nonatomic,strong) UILabel     *titleLabel;
@property (nonatomic,strong) UIImageView *voiceImage;
@property (nonatomic,strong) UILabel     *authorLabel;
@property (nonatomic,strong) UILabel     *playCountLabel;
@property (nonatomic,strong) UILabel     *playTimeLabel;
@property (nonatomic,strong) UILabel     *createKindLabel;
@property (nonatomic,strong) UILabel     *createTimeLabel;
@property (nonatomic,strong) UIButton    *downloadBtn;
@property (nonatomic,strong) UIButton    *btnPlay;
@property (nonatomic,strong) UIView      *uploadView;//上传进度view
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UILabel     *lblSpeed;
@property (nonatomic,strong) UILabel     *lblInfo;

-(void) uploadInfo : (VoiceObject *) obj;
@end
