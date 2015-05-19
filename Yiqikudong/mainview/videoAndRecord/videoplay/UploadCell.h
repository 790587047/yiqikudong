//
//  UploadCell.h
//  YiQiWeb
//
//  Created by wendy on 15/1/19.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface UploadCell : UITableViewCell

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *lblName;
@property (strong, nonatomic) UILabel *lblSpeed;
@property (strong, nonatomic) UILabel *lblProgress;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIButton *btnUpload;
@property (strong, nonatomic) UILabel *lblLayer;
@property (strong, nonatomic) UIButton *btnDown;

-(void)initData:(VideoModel *)model;

@end
