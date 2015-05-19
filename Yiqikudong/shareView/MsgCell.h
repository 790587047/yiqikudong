//
//  MsgCell.h
//  Yiqikudong
//
//  Created by BK on 15/3/23.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgObject.h"
#import "JXEmoji.h"
@interface MsgCell : UITableViewCell
{
    JXEmoji*contentLabel;
}
@property(nonatomic,assign)MsgObject*msgObject;
@end
