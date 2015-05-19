//
//  RecordCustomView.m
//  YiQiWeb
//
//  Created by BK on 15/1/6.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "RecordCustomView.h"

@interface RecordCustomView ()

@end

@implementation RecordCustomView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)VoiceRecognitionClientWorkStatus:(int)aStatus obj:(id)aObj
//{
//    switch (aStatus)
//    {
//        case EVoiceRecognitionClientWorkStatusFinish: // 识别正常完成并获得结果
//        {
//            NSMutableArray *audioResultData = (NSMutableArray *)aObj;
//            NSLog(@"%@",audioResultData);
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"dealVoice" object:nil userInfo:[NSDictionary dictionaryWithObject:audioResultData forKey:@"voice"]];
//            break;
//        }
//        case EVoiceRecognitionClientWorkStatusCancel:
//        {
//            if (self.view.superview)
//            {
//                [self.view removeFromSuperview];
//            }
//            break;
//        }
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
