//
//  ChatMessageCell.h
//  Yiqikudong
//
//  Created by BK on 15/3/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXEmoji.h"
@interface ChatMessageCell : UITableViewCell
@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UILabel *nameLabel;//用户名字显示文本框
@property(nonatomic, retain) JXEmoji *messageContentView;
@property(nonatomic, retain) UIImageView *bgImageView;
@property(nonatomic, retain) UIImageView *userImageView;
@property(nonatomic, retain) UIImageView*imageview;
@property(nonatomic, retain) AVPlayer*player;
@property(nonatomic, retain) AVPlayerLayer*playerLayer;
@property(nonatomic, retain) AVPlayerItem *playerItem;
@property(nonatomic, assign) BOOL isMoviePlaying;

@property(nonatomic, retain) UIImageView*movieImage;
@property(nonatomic, retain) UIImageView*logoMovie;
@property(nonatomic, retain) NSString*movieUrl;

@property(nonatomic, retain) UIImageView*voiceView;
@property(nonatomic, retain) UILabel*voiceTimeLenLable;
@property(nonatomic, retain) NSString*voiceUrl;
@property(nonatomic, assign) BOOL isVoicePlaying;

@property(nonatomic, retain) NSString*sender;

@property(nonatomic, retain) UIButton*reSend;
@end
