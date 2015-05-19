//
//  GroudObject.h
//  Yiqikudong
//
//  Created by BK on 15/4/9.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroudObject : NSObject
@property (nonatomic,retain) NSString* chatID;
@property (nonatomic,retain) NSString* groudName;
@property (nonatomic,retain) NSString* myID;
@property (nonatomic,retain) NSArray* chatUserIDs;
@property (nonatomic,retain) NSString* maxID;
@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSString* time;
@property (nonatomic,retain) NSString* picUrl;
@property (nonatomic,retain) NSArray* chatUserNames;
@property (nonatomic,retain) NSArray* chatPicUrls;
@property (nonatomic,retain) NSString* msgID;
@end
