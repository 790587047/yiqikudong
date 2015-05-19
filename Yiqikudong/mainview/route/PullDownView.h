//
//  KZJPullDownView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullDownViewProtocol.h"

@interface PullDownView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    int height,flag;
    float width;
    NSArray*titleArr;
}
@property(retain,nonatomic)NSString*type;
@property(assign,nonatomic)id<PullDownViewProtocol>delegate;

-(PullDownView*)initWithFrame:(CGRect)frame withTitles:(NSArray*)titleArray withBackgroud:(UIColor*)color;

@end
