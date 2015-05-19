//
//  UserModel.h
//  Yiqikudong
//
//  Created by wendy on 15/5/12.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *userImagePic;

@property (nonatomic, strong) NSString *userDescription;

/**
 *  粉丝数
 */
@property (nonatomic, assign) NSInteger followCount;

/**
 *  声音数
 */
@property (nonatomic, assign) NSInteger voiceCount;

@end
