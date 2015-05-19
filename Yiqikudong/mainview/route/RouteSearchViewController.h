//
//  RouteSearchViewController.h
//  CAVmap
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BaseViewController.h"
#import "MapSelectPointViewController.h"
#import "BaseTextField.h"
#import "RouteSearchCell.h"
#import "BDVRDataUploader.h"
#import "BDVRSConfig.h"
#import "BDVRCustomRecognitonViewController.h"
#import "BDRecognizerViewController.h"
typedef void(^addressBlock)(id);


@interface RouteSearchViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MVoiceRecognitionClientDelegate>
{
    addressBlock block;
//    addressBlock selectBlock;
    
    NSArray*placeArray;
    NSArray*cityArray;
    NSArray*streetArray;
    
    NSTimer*timer;
    NSString*textBefore;
    
    int flag;
    BDRecognizerViewController *tmpRecognizerViewController;
}
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
@property (strong, nonatomic) NSString *selectPointText;  // 提示文本
@property (assign, nonatomic) CLLocationCoordinate2D selectLocation;
@property (strong, nonatomic) BaseTextField *textfield;
@property (strong,nonatomic)UITableView*tableview;
@property (nonatomic, retain) BDVRCustomRecognitonViewController *audioViewController;
- (void)realizeBlock:(addressBlock)sender;

@end
