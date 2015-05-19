//
//  UserCenterView.h
//  Yiqikudong
//
//  Created by BK on 15/3/11.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "UserCenterController.h"
#import "UserCenterCell.h"
#import "RecordingView.h"
#import "VoiceCollectionView.h"
#import "VoiceHistoryView.h"
#import "UseStepsView.h"
#import "AboutUsView.h"
#import "PresentAnimation.h"
#import "DismissAnimation.h"
@interface UserCenterView : UserCenterController<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
{
    NSArray*titleArray;//存储cell的标题
    NSArray*imageArray;//存储cell的图片
}
@property(nonatomic,strong)PresentAnimation *presentAnimation;
@property(nonatomic,strong)DismissAnimation *dismissAnimation;
@end
