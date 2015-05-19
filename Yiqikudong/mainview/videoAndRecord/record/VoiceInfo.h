//
//  VoiceInfo.h
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceInfo : NSObject
@property(nonatomic,strong)NSString*name;
@property(nonatomic)float sumTime;
@property(nonatomic)float progress;
@property(nonatomic)float sumMemory;
@property(nonatomic)float downloadMemory;
@property(nonatomic,strong)NSURL*url;
@property(nonatomic,strong)NSString*dateStr;
@property(nonatomic,strong)NSURL*uploadUrl;
@end
