//
//  CollectionReusableCell.h
//  UIConnectionViewDEMO
//
//  Created by admin on 14/11/25.
//  Copyright (c) 2014年 com.woosii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIProgressView+AFNetworking.h"
@interface CollectionReusableCell : UICollectionViewCell

@property (strong ,nonatomic)UIImageView *image;
@property (strong ,nonatomic)UIButton*btn;
@property (strong ,nonatomic)UILabel*timeLabel;
@property (strong ,nonatomic)UIProgressView*progress;
@property (strong ,nonatomic)UIButton*btnDownload;

@property (strong ,nonatomic)UILabel*backdroundLabel;
@property (strong ,nonatomic)UILabel*progressLabel;
@end
