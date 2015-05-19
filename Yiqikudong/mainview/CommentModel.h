//
//  CommonMdel.h
//  Yiqikudong
//
//  Created by wendy on 15/5/11.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

/**
 *  主键ID
 */
@property (nonatomic, strong) NSString   *commentID;
/**
 *  评论的音频ID
 */
@property (nonatomic, strong) NSString   *voiceId;
/**
 *  发表评论的评论人ID
 */
@property (nonatomic, strong) NSString   *commentUserId;
/**
 *  发表评论的评论人名称
 */
@property (nonatomic, strong) NSString   *commentUserName;
/**
 *  头像路径
 */
@property (nonatomic, strong) NSString   *userImage;
/**
 *  评论内容
 */
@property (nonatomic, strong) NSString   *commentConntent;
/**
 *  创建时间（评论时间和回复评论时间）
 */
@property (nonatomic, strong) NSString   *createTime;
/**
 *  标识是否直接评论
 */
@property (nonatomic        ) BOOL       isDirect;
/**
 *  回复人ID
 */
@property (nonatomic, strong) NSString   *replyUserId;
/**
 *  回复人名称
 */
@property (nonatomic, strong) NSString   *replyUserName;
@end
