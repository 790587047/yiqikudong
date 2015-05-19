//
//  FXRecordArcView.h
//  FXRecordArc
//
//  Created by 方 霄 on 14-6-10.
//  Copyright (c) 2014年 方 霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_RECORD_DURATION 60.0
#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   60
#define SOUND_METER_COUNT  8
#define HUD_SIZE  320.0

@class ViewForRecording;
@protocol ViewForRecordingDelegate <NSObject>

- (void)recordArcView:(ViewForRecording *)arcView voiceRecorded:(NSString *)recordPath length:(float)recordLength;

@end

@interface ViewForRecording : UIView<AVAudioRecorderDelegate>
@property(weak, nonatomic) id<ViewForRecordingDelegate> delegate;
- (void)startForFilePath:(NSString *)filePath;
- (void)commitRecording;

@end

