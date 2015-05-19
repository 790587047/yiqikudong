//
//  ListViewCell.m
//  Yiqikudong
//
//  Created by BK on 15/3/20.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ListViewCell.h"
#import "Common.h"

@implementation ListViewCell
@synthesize imageview,titleLabel,downloadBtn,collectBtn,voiceSumTime,playSumCount,lastUploadDateTime;
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void) initData:(VoiceObject *) obj{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(-3, 0, SCREENWIDTH+6, 100)];
    view.backgroundColor = WHITECOLOR;
    [self addSubview:view];
    view.layer.borderColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor;
    view.layer.borderWidth = 2;
    
    if (imageview == nil) {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0, 100, CGRectGetHeight(view.frame))];
    }
    if ([obj.picPath hasSuffix:@"png"]||[obj.picPath hasSuffix:@"jpg"]||[obj.picPath hasSuffix:@"jpeg"]||[obj.picPath hasSuffix:@"gif"]) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.picPath]];
        [imageview setImage:[UIImage imageWithData:imageData]];
    }
    else
        [imageview setImage:[UIImage imageNamed:@"voiceDefault"]];
    
    [view addSubview:imageview];
    
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10, 5, SCREENWIDTH / 3, 30)];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
    }
    titleLabel.text = obj.voiceName;
    [view addSubview:titleLabel];
    
    UIImageView *imagePlay = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+12, 10, 10)];
    [imagePlay setImage:[UIImage imageNamed:@"voicedPlay"]];
    [view addSubview:imagePlay];
    
    UIColor *letterColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
    UIFont *letterFont = [UIFont boldSystemFontOfSize:14.f];
    
    if (playSumCount == nil) {
        playSumCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagePlay.frame)+2, CGRectGetMaxY(titleLabel.frame)+7, 50, 20)];
        playSumCount.textColor = letterColor;
        playSumCount.font = letterFont;
    }
    playSumCount.text = [NSString stringWithFormat:@"%@",obj.playSumCount];
    [view addSubview:playSumCount];
    
//    UIImageView *imageTime = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playSumCount.frame), imagePlay.frame.origin.y, 10, 10)];
//    imageTime.image = [UIImage imageNamed:@"voiceTime"];
//    [view addSubview:imageTime];
//    
//    if (voiceSumTime == nil) {
//        voiceSumTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageTime.frame)+2, playSumCount.frame.origin.y, 50, 20)];
//        voiceSumTime.textColor = letterColor;
//        voiceSumTime.font = letterFont;
//    }
//    voiceSumTime.text = obj.voiceSumTime;
//    [view addSubview:voiceSumTime];
    
    if (lastUploadDateTime == nil) {
        lastUploadDateTime = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(playSumCount.frame)+5, SCREENWIDTH * 0.6, 30)];
        lastUploadDateTime.textColor = letterColor;
        lastUploadDateTime.font = letterFont;
    }
    lastUploadDateTime.text = [NSString stringWithFormat:@"最后更新:%@",obj.createTime];
    [view addSubview:lastUploadDateTime];
    
    if (downloadBtn == nil) {
        downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadBtn.frame = CGRectMake(SCREENWIDTH-40, titleLabel.frame.origin.y+5, 20, 30);
        [downloadBtn setImage:[UIImage imageNamed:@"voiceDownload"] forState:UIControlStateNormal];
    }
    [view addSubview:downloadBtn];
    
    if (collectBtn == nil) {
        collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (SCREENWIDTH == 320) {
            collectBtn.frame = CGRectMake(SCREENWIDTH-70, CGRectGetMaxY(lastUploadDateTime.frame) - 40, 70, 30);
        }
        else{
            collectBtn.frame = CGRectMake(SCREENWIDTH-80, CGRectGetMaxY(lastUploadDateTime.frame) - 40, 70, 30);
        }
        [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    }
    [view addSubview:collectBtn];
}

@end
