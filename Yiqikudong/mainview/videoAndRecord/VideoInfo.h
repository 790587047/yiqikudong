//
//  VideoInfo.h
//  YiQiWeb
//
//  Created by BK on 14/12/30.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject
@property(nonatomic,strong)UIImage*image;
@property(nonatomic)float progress;
@property(nonatomic,strong)NSString*nameTitle;
@property(nonatomic)float sumMemory;
@property(nonatomic)float downloadMemory;
@property(nonatomic)BOOL state;
@property(nonatomic,strong)NSURL*url;
@end
