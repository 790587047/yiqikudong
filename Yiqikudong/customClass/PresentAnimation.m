//
//  PresentAnimation.m
//  Yiqikudong
//
//  Created by BK on 15/4/29.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "PresentAnimation.h"

@implementation PresentAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //1
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2
    CGRect finalRect = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalRect, [[UIScreen mainScreen]bounds].size.width,0);
    
    //3
    [[transitionContext containerView]addSubview:toVC.view];
    
    //4
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.frame = finalRect;
    } completion:^(BOOL finished) {
        //5
        [transitionContext completeTransition:YES];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}
@end
