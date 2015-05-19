//
//  UserObject.h
//  Yiqikudong
//
//  Created by BK on 15/3/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject
@property (nonatomic,retain) NSString* chatID;
@property (nonatomic,retain) NSString* myID;
@property (nonatomic,retain) NSString* chatUserID;
@property (nonatomic,retain) NSString* maxID;
@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSString* time;
@property (nonatomic,retain) NSString* picUrl;
@property (nonatomic,retain) NSString* chatUserName;
@property (nonatomic,retain) NSString* chatPicUrl;
@property (nonatomic,retain) NSString* zt;
@property (nonatomic,retain) NSString* msgID;
@property (nonatomic,retain) NSString* chatType;
@end
