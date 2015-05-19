//
//  VoiceListView.h
//  Yiqikudong
//
//  Created by BK on 15/2/25.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "BaseController.h"
#import "UploadVoiceTable.h"
#import "VoiceDownloadingTable.h"
@interface VoiceListView : BaseController
{
    UIButton*lastBtn;
    
    UploadVoiceTable*uploadVoiceTable;
    VoiceInfo*downloadInfo;
}
@property(nonatomic,retain)NSArray*uploadingArray;
@property(nonatomic,retain)UIView*baseView;
@property(nonatomic,retain)NSString*kind;
@end
