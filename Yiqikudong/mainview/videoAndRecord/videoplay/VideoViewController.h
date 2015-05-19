//
//  VideoViewController.h
//  Yiqikudong
//
//  Created by wendy on 15/2/17.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : BaseController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
- (IBAction)takeVideo:(id)sender;
- (IBAction)showVideoList:(id)sender;
@end
