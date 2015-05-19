//
//  MineView.h
//  亿启FM
//
//  Created by BK on 15/3/3.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineView : BaseController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIButton *lastButton;//记录点击的上一个按钮
    NSMutableArray *voiceArray;//存储相关信息的数组
    
    UIButton *myBtn;
    UIButton *downloadBtn;
    
    NSString *kind;//记录当前选择的按钮类型
}
@property (nonatomic, strong)UITableView *voiceTable;

@property (nonatomic, copy) NSString *kind;

@end
