//
//  FindView.h
//  亿启FM
//
//  Created by BK on 15/3/3.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserCenterController.h"
#import "ListVoiceView.h"
#import "SearchView.h"
@interface FindView : UserCenterController<UIScrollViewDelegate>
{
    UIScrollView*scrollview;
}
@end
