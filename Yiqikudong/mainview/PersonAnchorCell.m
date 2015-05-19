//
//  PersonAnchorCell.m
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "PersonAnchorCell.h"

@implementation PersonAnchorCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initData:(VoiceObject *) obj{
    
    if (_middleView == nil) {
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(25, 10, SCREENWIDTH * 0.7, 65)];
        _middleView.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
        _middleView.layer.borderWidth = 1;
        [self addSubview:_middleView];
    }
    
    if (_btnPlay == nil) {
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPlay setFrame:CGRectMake(CGRectGetMinX(_middleView.frame)-15, CGRectGetMidY(_middleView.frame) , 25, 25)];
        _btnPlay.center = CGPointMake(_btnPlay.center.x, _middleView.center.y);
        [_btnPlay setImage:[UIImage imageNamed:@"voiceDownloadPlay"] forState:UIControlStateNormal];
        [_btnPlay setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_btnPlay];
    }
    
    if (_lblTitle == nil) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 250, 25)];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont systemFontOfSize:16.f];
    }
    _lblTitle.text = obj.voiceName;
    [_middleView addSubview:_lblTitle];
    
    if (_lblAuthor == nil) {
        _lblAuthor = [[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.frame.origin.x, CGRectGetMaxY(_lblTitle.frame), 80, 30)];
        _lblAuthor.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        _lblAuthor.font = [UIFont systemFontOfSize:16.f];
    }
    _lblAuthor.text = [NSString stringWithFormat:@"BY %@",obj.voiceAuthor];
    [_middleView addSubview:_lblAuthor];
    
    UIFont *letterFont = [UIFont systemFontOfSize:12.f];
    UIColor *letterColor = [UIColor grayColor];
    
    if (_imagePlay == nil) {
        _imagePlay = [[UIImageView alloc] initWithFrame:CGRectMake(_middleView.frame.origin.x, CGRectGetMaxY(_middleView.frame)+10, 10, 10)];
        [_imagePlay setImage:[UIImage imageNamed:@"voicedPlay"]];
    }
    [self addSubview:_imagePlay];
    
    if (_lblPlay == nil) {
        _lblPlay = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imagePlay.frame), CGRectGetMaxY(_middleView.frame)+5, 40, 20)];
        _lblPlay.font = letterFont;
        _lblPlay.textColor = letterColor;
    }
    _lblPlay.text = [NSString stringWithFormat:@"%@",obj.playSumCount == nil ? @"0" : obj.playSumCount];
    [self addSubview:_lblPlay];
    
    if (_imageCollect == nil) {
        _imageCollect = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lblPlay.frame), _imagePlay.frame.origin.y, 10, 10)];
        _imageCollect.image = [UIImage imageNamed:@"voiceCollect"];
    }
    [self addSubview:_imageCollect];
    
    if (_lblCollect == nil) {
        _lblCollect = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageCollect.frame), _lblPlay.frame.origin.y, 40, 20)];
        _lblCollect.font = letterFont;
        _lblCollect.textColor = letterColor;
    }
    _lblCollect.text = @"179";
    [self addSubview:_lblCollect];
    
    if (_imageComment == nil) {
        _imageComment = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lblCollect.frame), _imagePlay.frame.origin.y, 10, 10)];
        _imageComment.image = [UIImage imageNamed:@"voiceComment"];
    }
    [self addSubview:_imageComment];
    
    if (_lblComment == nil) {
        _lblComment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageComment.frame)+2, _lblPlay.frame.origin.y, 40, 20)];
        _lblComment.font = letterFont;
        _lblComment.textColor = letterColor;
    }
    _lblComment.text = @"39";
    [self addSubview:_lblComment];
    
    if (_imageDown == nil) {
        _imageDown = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lblComment.frame), _imagePlay.frame.origin.y, 10, 10)];
        _imageDown.image = [UIImage imageNamed:@"voiceDownload"];
    }
    [self addSubview:_imageDown];
    
    if (_lblDown == nil) {
        _lblDown = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageDown.frame)+2, _lblPlay.frame.origin.y, 40, 20)];
        _lblDown.font = letterFont;
        _lblDown.textColor = letterColor;
    }
    _lblDown.text = @"39";
    [self addSubview:_lblDown];
    
    if (_imageTime == nil) {
        _imageTime = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lblDown.frame), _imagePlay.frame.origin.y, 10, 10)];
        _imageTime.image = [UIImage imageNamed:@"voiceTime"];
    }
    [self addSubview:_imageTime];
    
    if (_lblTime == nil) {
        _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageTime.frame)+2, _lblPlay.frame.origin.y, 50, 20)];
        _lblTime.font = letterFont;
        _lblTime.textColor = letterColor;
    }
    _lblTime.text = obj.voiceSumTime;
    [self addSubview:_lblTime];
    
    if (_thumImage == nil) {
        _thumImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_middleView.frame)+1, _middleView.frame.origin.y, CGRectGetHeight(_middleView.frame), CGRectGetHeight(_middleView.frame))];
    }
    if (obj.voicePic != nil) {
        _thumImage.image = [UIImage imageWithData:obj.voicePic];
    }
    else
        _thumImage.image = [UIImage imageNamed:@"voiceDefault"];
    [self addSubview:_thumImage];
    
}


@end
