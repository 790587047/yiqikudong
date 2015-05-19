//
//  DownloadingVoiceCell.m
//  Yiqikudong
//
//  Created by wendy on 15/4/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "DownloadingVoiceCell.h"

@implementation DownloadingVoiceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) downLoadingInfo:(VoiceObject *) obj{
    
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
    
    if (obj.downloadingFlag) {
        if (_downView == nil) {
            _downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lblPlay.frame), SCREENWIDTH, 40)];
            [_downView setBackgroundColor:[UIColor colorWithRed:237/255.0 green:238/255.0 blue:234/255.0 alpha:1]];
        }
        [self addSubview:_downView];
        
        if (_progressView == nil) {
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH / 3, 2)];
            _progressView.center = CGPointMake(self.center.x, _progressView.center.y+10);
            [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
            [_progressView setTintColor:[UIColor orangeColor]];
        }
        [_downView addSubview:_progressView];
        
        if (_btnDown == nil) {
            _btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnDown setFrame:CGRectMake(CGRectGetMidX(_progressView.frame) - 150, 2, 100, 35)];
            _btnDown.center = CGPointMake(_btnDown.center.x, _progressView.center.y);
            [_btnDown setTitle:@"暂停下载" forState:UIControlStateNormal];
            [_btnDown.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
            [_btnDown setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_btnDown setImage:[UIImage redraw:[UIImage imageNamed:@"voiceDownPause"] Frame:CGRectMake(0, 0, 20, 20)] forState:UIControlStateNormal];
        }
        [_downView addSubview:_btnDown];
        
        if (_lblprogress == nil) {
            _lblprogress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_progressView.frame)+5, _btnDown.frame.origin.y, 120, 30)];
            _lblprogress.center = CGPointMake(_lblprogress.center.x, _progressView.center.y);
            _lblprogress.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",0.00,obj.total];
            [_lblprogress setFont:[UIFont systemFontOfSize:13.f]];
            _lblprogress.textColor = [UIColor darkGrayColor];
        }
        [_downView addSubview:_lblprogress];
    }
    else{
        if (_downView != nil) {
            [_downView removeFromSuperview];
        }
    }
}

@end
