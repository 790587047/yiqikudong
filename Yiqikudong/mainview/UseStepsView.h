//
//  UseStepsView.h
//  Yiqikudong
//
//  Created by BK on 15/4/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterController.h"
@interface UseStepsView : UserCenterController<UIScrollViewDelegate>
{
    UIPageControl*pageControl;
    UIScrollView*stepsScroll;
}
@end