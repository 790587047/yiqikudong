//
//  Common.m
//  Yiqikudong
//
//  Created by wendy on 15/3/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "Common.h"

@implementation Common

+(NSData *) dealImage : (NSData *) data{
    int imageWidth = 64;
    UIImage *image = [UIImage imageWithData:data];
    float width = image.size.width;
    float height = image.size.height;
    int temp = 0,h = 0,w = 0;
    if (width <= imageWidth && height <= imageWidth) {
        return data;
    }
    else{
        if (width >= height) {
            if (width > imageWidth) {
                temp = width / imageWidth;
                h = height / temp > imageWidth ? imageWidth : height / temp;
                w = imageWidth;
            }
        }
        else{
            if (height > imageWidth) {
                temp = height / imageWidth;
                w = width / temp > imageWidth ? imageWidth : width / temp;
                h = imageWidth;
            }
        }
        UIImage *currentImage = [self scaleToSize:image width:w height:h];
        NSData *iData = UIImageJPEGRepresentation(currentImage, 1.0);
        return iData;
    }
}


//压缩图片
+(UIImage *)scaleToSize:(UIImage *)img width:(int)width height:(int) height{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+(void) showMessage:(NSString *) msg withView:(UIView *)view{
    ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:msg];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:remiderView];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];//动画运行时间
        remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
        [UIView commitAnimations];//提交动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [remiderView removeFromSuperview];
        });
    });
}

//删除文件
+(void)deleteFile : (NSString *) path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

//获取视频的缩略图
+(UIImage *)getImage:(NSURL *)videoURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error ;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

//获取时长
+(CGFloat) getVideoLength:(NSURL *)movieURL{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;//视频的总时长，单位秒
    return second;
}

//获取当前时间
+(NSString *)getCurrentDate : (NSString *) dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}
+(NSString *)getVoiceTimeLength:(NSURL *)url{
    CGFloat sumTime = [self getVideoLength:url];
    int second = (int)sumTime % 60;
    int mimute = ((int)sumTime - second) / 60 > 60 ? ((int)sumTime - second) / 60 % 60 : ((int)sumTime - second) / 60;
    int hour   = ((int)sumTime - second) / 60 > 60 ? ((int)sumTime - second) / 60 / 60 : 0;
    NSString *strTime;
    if (hour == 0) {
        strTime = [NSString stringWithFormat:@"%.2d:%.2d",mimute,second];
    }
    else
        strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour,mimute,second];
    return strTime;
}

+(NSString *)dealDateTime:(NSString *)dateTime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateTime];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

//计算当前日期和创建日期的时间差
+(NSString *) getTimeDifference:(NSString *) inDay{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit;
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:inDay];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"fromdate=%@",fromDate);
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"enddate=%@",localeDate);
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger years = [components year];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    
    NSString *dateStr;
    if (years > 0) {
        dateStr = [NSString stringWithFormat:@"%ld年前",(long)years];
    }
    else if (months > 0){
        dateStr = [NSString stringWithFormat:@"%ld个月前",(long)months];
    }
    else if (days > 0){
        dateStr = [NSString stringWithFormat:@"%ld日前",(long)days];
    }
    else if (hours > 0){
        dateStr = [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    else if (minutes > 1){
        dateStr = [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
    }
    else{
        dateStr = @"刚刚";
    }
    return dateStr;
}
@end
