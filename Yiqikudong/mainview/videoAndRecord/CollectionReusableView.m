//
//  CollectionReusableView.m
//  UIConnectionViewDEMO
//
//  Created by admin on 14/11/25.
//  Copyright (c) 2014年 com.woosii. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height)];

        titleLabel.textColor = [UIColor lightGrayColor];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.949, 0.949, 0.949, 1 });
        titleLabel.layer.backgroundColor = colorref;
        CGColorRelease(colorref);
        CGColorSpaceRelease(colorSpace);
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
