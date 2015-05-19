//
//  VideoCell.h
//  YiQiWeb
//
//  Created by wendy on 15/1/16.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *lblTime;
@property (strong, nonatomic) UILabel *lblVideoName;
@property (strong, nonatomic) UIButton *btnPlay;

-(void)initData:(VideoModel *) model;

@end
