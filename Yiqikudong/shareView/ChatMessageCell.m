//
//  ChatMessageCell.m
//  Yiqikudong
//
//  Created by BK on 15/3/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ChatMessageCell.h"

@implementation ChatMessageCell
@synthesize senderAndTimeLabel;
@synthesize messageContentView;
@synthesize bgImageView;
@synthesize userImageView,imageview,player,isMoviePlaying,voiceView,isVoicePlaying,voiceUrl,movieUrl,movieImage,logoMovie,voiceTimeLenLable,nameLabel,reSend;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        //日期标签
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-150, 5, 300, 20)];
        //居中显示
        senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
        senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
        //文字颜色
        senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:senderAndTimeLabel];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:11.0];
        nameLabel.textColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
        [self.contentView addSubview:nameLabel];
        
        //背景图
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bgImageView];
        
        //聊天信息
        messageContentView = [[JXEmoji alloc] init];
        messageContentView.backgroundColor = [UIColor clearColor];
        //不可编辑
//        messageContentView.editable = NO;
//        messageContentView.scrollEnabled = NO;
        messageContentView.textAlignment = NSTextAlignmentNatural;
        [messageContentView sizeToFit];
        [self.contentView addSubview:messageContentView];
        
        userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:userImageView];
        
        imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imageview.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imageview];
        
//        movieView = [[MPMoviePlayerController alloc]init];
////        movieView.controlStyle = MPMovieControlStyleDefault;
//        movieView.repeatMode = MPMovieRepeatModeOne;
//        movieView.controlStyle = MPMovieControlStyleNone;
//        movieView.fullscreen = YES;
//        movieView.scalingMode = MPMovieScalingModeAspectFill;
//        [self.contentView addSubview:movieView.view];
//        player = [[AVPlayer alloc]init];
        movieImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        movieImage.userInteractionEnabled = YES;
        [self.contentView addSubview:movieImage];
        logoMovie = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/5, SCREENWIDTH/5)];
//        logoMovie.center = movieImage.center;
//        logoMovie.backgroundColor = [UIColor blackColor];
        logoMovie.image = [UIImage imageNamed:@"bf"];
        [logoMovie setHidden:YES];
        [self.contentView addSubview:logoMovie];
        
        
        voiceView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:voiceView];
        
        voiceTimeLenLable = [[UILabel alloc]initWithFrame:CGRectZero];
        voiceTimeLenLable.backgroundColor = [UIColor clearColor];
        voiceTimeLenLable.textColor = [UIColor grayColor];

        [self.contentView addSubview:voiceTimeLenLable];
        
        
        reSend = [UIButton buttonWithType:UIButtonTypeCustom];
        reSend.frame = CGRectZero;
        [reSend setImage:[UIImage imageNamed:@"MessageSendFail"] forState:UIControlStateNormal];
        [self.contentView addSubview:reSend];
    }
    
    return self;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
