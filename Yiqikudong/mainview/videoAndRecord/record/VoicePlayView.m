//
//  VoicePlayView.m
//  YiQiWeb
//
//  Created by BK on 15/1/9.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "VoicePlayView.h"

@implementation VoicePlayView
@synthesize progress,starBtn,nextBtn,lastBtn,timeLabel,titleLabel;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame info:(VoiceInfo*)info
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = WHITECOLOR;
        
        UIImageView*imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, frame.size.height-10, frame.size.height-10)];
        imageview.image = [UIImage imageNamed:@"voiceimage1"];
        [self addSubview:imageview];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width+20, 2, 120, frame.size.height/2)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = info.name;
        if (isPad)
        {
            titleLabel.font = [UIFont systemFontOfSize:28];
        }else
        {
            titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [self addSubview:titleLabel];
        
        if (isPad)
        {
            timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, frame.size.height/2-20, 140, frame.size.height/2)];
        }else
        {
            timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, frame.size.height/2-20, 140, frame.size.height/2)];
        }
        
        titleLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.attributedText = [self getTimeStringWithCurrentTime:0 sumTime:info.sumTime];
        if (isPad)
        {
            timeLabel.font = [UIFont systemFontOfSize:24];
        }else
        {
            timeLabel.font = [UIFont systemFontOfSize:17];
        }
        [self addSubview:timeLabel];
        int height,length;
        if (isPad)
        {
            height = frame.size.height*5/9;
            length = frame.size.height*0.26;
        }else
        {
            height = frame.size.height/2;
            length = frame.size.height*0.3;
        }
        
        starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        starBtn.frame = CGRectMake(imageview.frame.size.width+15+frame.size.height*2/5+10, height, frame.size.height*2/5, frame.size.height*2/5);
        
        [starBtn setImage:[UIImage redraw:[UIImage imageNamed:@"voiceplay"] Frame:CGRectMake(0, 0, length, length)] forState:UIControlStateNormal];
        [self addSubview:starBtn];
        
        nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(imageview.frame.size.width+15+frame.size.height*4/5+20, height, frame.size.height*2/5, frame.size.height*2/5);
        [nextBtn setImage:[UIImage redraw:[UIImage imageNamed:@"voicenext"] Frame:CGRectMake(0, 0, length, length)] forState:UIControlStateNormal];
        [self addSubview:nextBtn];
        
        lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lastBtn.frame = CGRectMake(imageview.frame.size.width+15, height, frame.size.height*2/5, frame.size.height*2/5);
        [lastBtn setImage:[UIImage redraw:[UIImage imageNamed:@"voicelast"] Frame:CGRectMake(0, 0, length, length)] forState:UIControlStateNormal];
        [self addSubview:lastBtn];
        
        progress = [[UIProgressView alloc]initWithFrame:CGRectMake(nextBtn.frame.origin.x+nextBtn.frame.size.width+15, frame.size.height-10, SCREENWIDTH-(nextBtn.frame.origin.x+nextBtn.frame.size.width+25), 10)];
        progress.tintColor = [UIColor redColor];
        progress.progress = info.progress;
        [self addSubview:progress];
        
    }
    return self;
}

-(NSAttributedString*)getTimeStringWithCurrentTime:(float)currentTime sumTime:(float)sumTime
{
    int currentSecond = (int)currentTime%60;
    int currentMimute = (int)currentTime/60>60?(int)currentTime/60%60:(int)currentTime/60;
    int currentHour = (int)currentTime/60>60?(int)currentTime/60/60:00;
    int sumSecond = (int)sumTime%60;
    int sumMimute = (int)sumTime/60>60?(int)sumTime/60%60:(int)sumTime/60;
    int sumHour = (int)sumTime/60>60?(int)sumTime/60/60:00;
    
    
    NSString *tempStr = [NSString stringWithFormat:@"%.2d:%.2d:%.2d/%.2d:%.2d:%.2d",currentHour,currentMimute,currentSecond,sumHour,sumMimute,sumSecond];
//    NSLog(@"length=%lu",(unsigned long)tempStr.length);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSRange range = [tempStr rangeOfString:@"/"];
    int location = (int)range.location;
    
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:17.f]} range:NSMakeRange(0, location)];
    
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17.f]} range:NSMakeRange(location, tempStr.length-location)];
    
    return attributedString;
}

@end
