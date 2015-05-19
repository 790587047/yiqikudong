//
//  LocalVoiceCell.h
//  YiQiWeb
//
//  Created by BK on 15/1/8.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceInfo.h"
@interface LocalVoiceCell : UITableViewCell
{
    
}
@property(nonatomic,retain)UIImageView*image;
-(id)initWithFrame:(CGRect)frame info:(VoiceInfo*)info;
-(void)data:(VoiceInfo*)info;
@end
