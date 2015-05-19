//
//  FollowCell.m
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initData:(UserModel *) model{
    
    if (_imgHead == nil) {
        _imgHead = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 60, 60)];
        _imgHead.center = CGPointMake(_imgHead.center.x,self.center.y + 20);
        _imgHead.layer.masksToBounds = YES;
        _imgHead.layer.cornerRadius = 30.f;
    }
//     [_imgHead setImage:[UIImage imageNamed:@"downloadimage.jpg"]];
    [_imgHead setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.userImagePic]]]];
    [self addSubview:_imgHead];
    
    if (_lblUserName == nil) {
        _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgHead.frame)+10, 10, 100, 30)];
        _lblUserName.textColor = [UIColor blackColor];
        [_lblUserName setFont:[UIFont systemFontOfSize:18.f]];
    }
    [_lblUserName setText:model.userName];
    
    [self addSubview:_lblUserName];
    
    if (_lblVoiceCount == nil) {
        _lblVoiceCount = [[UILabel alloc] initWithFrame:CGRectMake(_lblUserName.frame.origin.x, CGRectGetMaxY(_lblUserName.frame)+5, 80, 30)];
        [_lblVoiceCount setFont:[UIFont systemFontOfSize:14.f]];
        _lblVoiceCount.textColor = [UIColor grayColor];
    }
    [_lblVoiceCount setText:[NSString stringWithFormat:@"声音 %ld",(long)model.voiceCount]];
    [self addSubview:_lblVoiceCount];
    
    if (_lblFollowCount == nil) {
        _lblFollowCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lblVoiceCount.frame), _lblVoiceCount.frame.origin.y, 100, 30)];
        [_lblFollowCount setFont:[UIFont systemFontOfSize:14.f]];
        [_lblFollowCount setTextColor:[UIColor grayColor]];
    }
    [_lblFollowCount setText:[NSString stringWithFormat:@"粉丝 %ld",(long)model.followCount]];
    [self addSubview:_lblFollowCount];
}

@end
