//
//  CommentListViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/5/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBFaceView.h"

@interface CommentListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate,ZBFaceViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView      *sendView;
@property (nonatomic, strong) UIButton    *btnChange;
@property (nonatomic, strong) UITextView  *txtMessage;
@property (nonatomic, strong) UIButton    *btnSend;

@property (nonatomic, strong) NSMutableArray *commentList;

@property (nonatomic, copy) NSString *voiceId;

@end
