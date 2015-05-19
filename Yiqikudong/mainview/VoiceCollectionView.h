//
//  VoiceCollectionView.h
//  Yiqikudong
//
//  Created by BK on 15/4/27.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterController.h"
#import "PlayVoiceViewController.h"
@interface VoiceCollectionView : UserCenterController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*collectionTable;
    NSMutableArray*collectionArray;
}
@end
