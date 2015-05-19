//
//  CommentViewCell.m
//  Yiqikudong
//
//  Created by wendy on 15/5/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "CommentViewCell.h"
#import "Common.h"

@implementation CommentViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initData:(CommentModel *) model{
//    if (_bgView == nil) {
//        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//        [_bgView setBackgroundColor:[UIColor yellowColor]];
//    }
//    [self addSubview:_bgView];
    
    if (_imgHead == nil) {
        _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [_imgHead setImage:[UIImage imageNamed:@"default"]];
//        [_imgHead setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.userImage]]]];
        _imgHead.layer.masksToBounds = YES;
        _imgHead.layer.cornerRadius = 18;
    }
    [self addSubview:_imgHead];
    
    if (_lblAuthor == nil) {
        _lblAuthor = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgHead.frame) + 5, _imgHead.frame.origin.y, 150, 30)];
        [_lblAuthor setFont:[UIFont systemFontOfSize:16.f]];
        [_lblAuthor setTextColor:[UIColor colorWithRed:250.0/255 green:124.0/255 blue:88.0/255 alpha:1.0]];
    }
//    if (model.isDirect) {
       [_lblAuthor setText:model.commentUserName];
//    }
//    else{
//        [_lblAuthor setText:model.replyUserName];
//    }
    [self addSubview:_lblAuthor];
    
    if (_lblTime == nil) {
        _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 100, _lblAuthor.frame.origin.y, 85, 30)];
        [_lblTime setTextColor:[UIColor grayColor]];
        [_lblTime setTextAlignment:NSTextAlignmentRight];
        [_lblTime setFont:[UIFont systemFontOfSize:14.f]];
    }
    [_lblTime setText:[Common getTimeDifference:model.createTime]];
    [self addSubview:_lblTime];
    
    if (model.commentConntent.length > 0) {
        CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake(SCREENWIDTH - CGRectGetMinX(_imgHead.frame)*2, 500) font:[UIFont systemFontOfSize:14.f] string:model.commentConntent lineSpace:1.0f];
        
        NSLog(@"%@",NSStringFromCGRect(rect));
        
        if (_txtContent == nil) {
            _txtContent = [[TQRichTextView alloc] initWithFrame:CGRectMake(_imgHead.frame.origin.x, CGRectGetMaxY(_imgHead.frame)+5, rect.size.width, rect.size.height)];
            [_txtContent setTextColor:[UIColor blackColor]];
            [_txtContent setBackgroundColor:[UIColor clearColor]];
            [_txtContent setFont:[UIFont systemFontOfSize:14.f]];
            [_txtContent setLineSpace:1.0f];
            [_txtContent setUserInteractionEnabled:NO];
        }
    }
    [_txtContent setText:model.commentConntent];
    [self addSubview:_txtContent];
}

@end
