//
//  PlayVoiceViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/3/11.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceObject.h"
#import "UserCenterController.h"

@interface PlayVoiceViewController :UserCenterController<UIAlertViewDelegate>
{
    UIButton *btnBack;
    UIButton *btnRecord;
}
@property (strong, nonatomic) UILabel     *lblTitle;
@property (strong, nonatomic) UIImageView *imgShowRecord;
@property (strong, nonatomic) UIButton    *btnPlay;
@property (strong, nonatomic) UIButton    *btnCircle;
@property (strong, nonatomic) UISlider    *slider;
@property (strong, nonatomic) UIImageView *imgHead;
@property (strong, nonatomic) UILabel     *lblName;
@property (strong, nonatomic) UILabel     *lblDate;
@property (strong, nonatomic) UIView      *playView;
@property (strong, nonatomic) UILabel     *curLabel;
@property (strong, nonatomic) UILabel     *duLabel;
@property (strong, nonatomic) UILabel     *lblInfo;
@property (strong, nonatomic) NSArray     *mp3Arrays;
@property (nonatomic        ) BOOL        isHome;

@property (strong, nonatomic) UIButton    *btnAttention;
/**
 *  是否关注
 */
@property (nonatomic) BOOL        isFollow;


@property (copy, nonatomic  ) VoiceObject *model;

-(AVPlayer *)player;
+(PlayVoiceViewController*)playVoiceView;

@end
