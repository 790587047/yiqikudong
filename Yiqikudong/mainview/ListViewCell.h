//
//  ListViewCell.h
//  Yiqikudong
//
//  Created by BK on 15/3/20.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceObject.h"

@interface ListViewCell : UITableViewCell
@property (nonatomic,strong ) UIImageView *imageview;
@property (nonatomic,strong ) UILabel     *titleLabel;
@property (nonatomic,strong ) UIButton    *downloadBtn;
@property (nonatomic,strong ) UIButton    *collectBtn;
@property (nonatomic,strong ) UILabel     *voiceSumTime;
@property (nonatomic,strong ) UILabel     *playSumCount;
@property (nonatomic, strong) UILabel     *lastUploadDateTime;

-(void) initData:(VoiceObject *) obj;

@end
