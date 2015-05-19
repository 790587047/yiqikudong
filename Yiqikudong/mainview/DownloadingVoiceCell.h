//
//  DownloadingVoiceCell.h
//  Yiqikudong
//
//  Created by wendy on 15/4/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceObject.h"

@interface DownloadingVoiceCell : UITableViewCell

@property (nonatomic, strong) UIButton       *btnPlay;
@property (nonatomic, strong) UILabel        *lblTitle;
@property (nonatomic, strong) UILabel        *lblAuthor;
@property (nonatomic, strong) UIImageView    *thumImage;
@property (nonatomic, strong) UIButton       *btnDown;
@property (nonatomic, strong) UILabel        *lblState;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel        *lblprogress;
@property (nonatomic, strong) UIView         *downView;
@property (nonatomic, strong) UIView         *middleView;
@property (nonatomic, strong) UIImageView    *imagePlay;
@property (nonatomic, strong) UILabel        *lblPlay;
@property (nonatomic, strong) UIImageView    *imageCollect;
@property (nonatomic, strong) UILabel        *lblCollect;
@property (nonatomic, strong) UIImageView    *imageComment;
@property (nonatomic, strong) UILabel        *lblComment;
@property (nonatomic, strong) UIImageView    *imageDown;
@property (nonatomic, strong) UILabel        *lblDown;
@property (nonatomic, strong) UIImageView    *imageTime;
@property (nonatomic, strong) UILabel        *lblTime;

-(void) downLoadingInfo:(VoiceObject *) obj;

@end
