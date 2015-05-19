//
//  VideoCell.m
//  YiQiWeb
//
//  Created by wendy on 15/1/16.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        rect = frame;
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;

//        NSArray *arrayOfviews = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
//        if (arrayOfviews.count < 1) {
//            return nil;
//        }
//        if (![[arrayOfviews firstObject] isKindOfClass:[UICollectionViewCell class]]) {
//            return nil;
//        }
//        self = [arrayOfviews firstObject];
    }
    return self;
}

-(void) initData:(VideoModel *)model{
    if (self.imgView == nil) {
        self.imgView = [[UIImageView alloc] initWithFrame:[VideoModel iPad]?CGRectMake(0, 0, SCREENWIDTH/3-15, SCREENWIDTH/3+30):CGRectMake(0, 0, 98, 130)];
        [self addSubview:self.imgView];
    }
    [self.imgView setUserInteractionEnabled:YES];
    
    self.imgView.image =[UIImage imageWithData:model.v_imageData];
    
    if (self.btnPlay == nil) {
        self.btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btnPlay];
    }
    [self.btnPlay setFrame:[VideoModel iPad] ? CGRectMake(0, 0, 120, 120):CGRectMake(27, 40, 50, 50)];
    CGPoint center = self.imgView.center;
    center.y -= 20;
    self.btnPlay.center = center;
    [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    if (self.lblTime == nil) {
        self.lblTime = [[UILabel alloc] initWithFrame:[VideoModel iPad] ? CGRectMake(4, 180, 84, 41):CGRectMake(1, 80, 42, 21)];
        [self addSubview:self.lblTime];
    }
    NSString *timescale ;
    int second = (int)model.v_timeScale;
    if (second >= 60) {
        int index = second / 60;
        second = second - index*60;
        NSString *indexStr = [NSString stringWithFormat:index < 10 ? @"0%d" : @"%d",index];
        timescale = [NSString stringWithFormat:second < 10 ? @"%@:0%d":@"%@:%d",indexStr,second];
    }
    else{
        timescale = [NSString stringWithFormat:second < 10 ? @"00:0%d":@"00:%d",second];
    }
    self.lblTime.text = timescale;
    self.lblTime.textColor = [UIColor whiteColor];
    [self.lblTime setFont:[UIFont systemFontOfSize:[VideoModel iPad] ? 26.0f : 13.0f]];
    [self.lblTime setTextAlignment:NSTextAlignmentLeft];
    
    
    if (self.lblVideoName == nil) {
        self.lblVideoName = [[UILabel alloc] initWithFrame:[VideoModel iPad] ? CGRectMake(0, 220, self.imgView.frame.size.width, 60) : CGRectMake(0, 103, self.imgView.frame.size.width, 27)];
        [self addSubview:self.lblVideoName];
    }
    self.lblVideoName.text = model.v_Name;
    [self.lblVideoName setTextAlignment:NSTextAlignmentCenter];
    [self.lblVideoName setTextColor:[UIColor whiteColor]];
    [self.lblVideoName setFont:[UIFont boldSystemFontOfSize:[VideoModel iPad] ? 30.0f : 17.0f]];
    self.lblVideoName.backgroundColor = [UIColor blackColor];
    
}

@end
