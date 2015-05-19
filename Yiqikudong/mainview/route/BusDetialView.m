//
//  BusDetialView.m
//  CAVmap
//
//  Created by Ibokan on 14-10-30.
//  Copyright (c) 2014年 CAV. All rights reserved.
//

#import "BusDetialView.h"
#import "UIView+CustomActivity.h"

@implementation BusDetialView

@synthesize busTitleLabel,timerLabel,distanceLabel,walkingLabel,detailButton;
-(void)nihao
{
//    [NSDictionary dictionaryWithObject:detailArray forKey:@"detailArray"]
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"detailRoute" object:nil userInfo:@{@"detailArray":detailArray,@"TransitRouteLine":lineDetail}];
//    for (BMKTransitStep *step in detailArray) {
//        NSLog(@"%@",step.instruction);
//    }
    
}
- (id)initWithFrame:(CGRect)frame andData:(id )touteLine
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [UIView setLayerWithView:self];
        
        void(^initLableBlock)(UILabel *) = ^(UILabel *label){
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor grayColor];
            [self addSubview:label];
        };
        
        busTitleLabel = [[UILabel alloc]initWithFrame:kFrame(10, 10, SCREENWIDTH-80, 20)];
        busTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:busTitleLabel];
        
        timerLabel = [[UILabel alloc]initWithFrame:kFrame(10, 35, 0, 15)];
        initLableBlock(timerLabel);
        
        distanceLabel = [[UILabel alloc]initWithFrame:kFrame(100, 35, 0, 15)];
        initLableBlock(distanceLabel);
        
        if (![touteLine isKindOfClass:[BMKDrivingRouteLine class]]) {
            walkingLabel = [[UILabel alloc]initWithFrame:kFrame(190, 35, 0, 15)];
            initLableBlock(walkingLabel);
        }
        
        
        detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailButton.frame = CGRectMake(self.frame.size.width-40, 15, 40, 30);
        detailButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [detailButton setTitle:@"详情" forState:UIControlStateNormal];
        [detailButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [detailButton setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
        [detailButton addTarget:self action:@selector(nihao) forControlEvents:UIControlEventTouchUpInside];
        
        
        int count = 0;
        NSMutableString *string = [[NSMutableString alloc]init];
        int distance = 0;  // 步行米数
        
       
        if ([touteLine isKindOfClass:[BMKTransitRouteLine class]])
        {
            lineDetail = [[BMKTransitRouteLine alloc]init];
            lineDetail = touteLine;
            [self addSubview:detailButton];
            detailArray = [[NSArray alloc]initWithArray:((BMKTransitRouteLine *)touteLine).steps];
           
            for (BMKTransitStep *step in  ((BMKTransitRouteLine *)touteLine).steps)
            {
//                NSLog(@"%@",step.instruction);
                if (step.stepType == BMK_BUSLINE || step.stepType == BMK_SUBWAY)
                {
                    if (count > 0)
                    {
                        [string appendString:[NSString stringWithFormat:@"→%@",step.vehicleInfo.title]];
                    }
                    else
                    {
                        [string appendString:step.vehicleInfo.title];
                    }
                    count++;
                }
                else
                {
                    distance += step.distance;
                }
            }
        }
        else if([touteLine isKindOfClass:[BMKWalkingRouteLine class]])
        {
            [string appendString:@"方案1"];
        }else if([touteLine isKindOfClass:[BMKDrivingRouteLine class]])
        {
            [string appendString:@"方案1"];
            lineDetail = [[BMKTransitRouteLine alloc]init];
            lineDetail = touteLine;
            detailArray = [[NSArray alloc]initWithArray:((BMKTransitRouteLine *)touteLine).steps];
            [self addSubview:detailButton];
        }
        
        busTitleLabel.text = string;
        
        // 时间Label
        NSMutableString *timer = [[NSMutableString alloc]initWithFormat:@"约"];
        void(^appendTimer)(int,NSString *) = ^(int num,NSString *str){
            
            if (num > 0)
            {
                [timer appendFormat:@"%d%@",num,str];
            }
            
        };
        if ([touteLine isKindOfClass:[BMKTransitRouteLine class]])
        {
            BMKTransitRouteLine *line = (BMKTransitRouteLine *)touteLine;
            appendTimer(line.duration.dates,@"天");
            appendTimer(line.duration.hours,@"小时");
            appendTimer(line.duration.minutes,@"分钟");
        }
        else
        {
            BMKWalkingRouteLine *line = (BMKWalkingRouteLine *)touteLine;
            appendTimer(line.duration.dates,@"天");
            appendTimer(line.duration.hours,@"小时");
            appendTimer(line.duration.minutes,@"分钟");
        }
        
        __block float width = 0;
        void(^widthBlock)(UIView *) = ^(UIView *view){
            
            width = view.frame.origin.x + view.frame.size.width;
        };
        
        
        timerLabel.text = timer;
        
        CGSize timerSize = [self textHeightWithString:timer Font:15 height:15];
        timerLabel.frame = kFrame(timerLabel.frame.origin.x, timerLabel.frame.origin.y,timerSize.width, 15);
        
        widthBlock(timerLabel);  // 调用块重设X轴
        
        
        // 分割线
        UIImageView *separate = [UIImageView addYSeparateLine:nil Frame:kFrame(width+5, 36, 1, 15)];
        [self addSubview:separate];
        
        widthBlock(separate);  // 调用块重设X轴
        
        // 公里Label
        if ([touteLine isKindOfClass:[BMKTransitRouteLine class]])
        {
            BMKTransitRouteLine *line = (BMKTransitRouteLine *)touteLine;
            distanceLabel.text = [NSString stringWithFormat:@"%0.1f公里",line.distance/1000.0];
        }
        else
        {
            BMKWalkingRouteLine *line = (BMKWalkingRouteLine *)touteLine;
            distanceLabel.text = [NSString stringWithFormat:@"%0.1f公里",line.distance/1000.0];
        }
        
        CGSize distanceSize = [self textHeightWithString:distanceLabel.text Font:15 height:15];
        distanceLabel.frame = kFrame(width+5, 35, distanceSize.width, 15);
        
        widthBlock(distanceLabel);  // 调用块重设X轴
        
        // 分隔线
        UIImageView *separate2 = [UIImageView addYSeparateLine:nil Frame:kFrame(width+5, 36, 1, 15)];
        [self addSubview:separate2];
        
        widthBlock(separate2);
        
        // 步行米数Label
        if ([touteLine isKindOfClass:[BMKTransitRouteLine class]])
        {
            walkingLabel.text = [NSString stringWithFormat:@"步行%d米",distance];
        }
        else
        {
            BMKWalkingRouteLine *line = (BMKWalkingRouteLine *)touteLine;
            walkingLabel.text = [NSString stringWithFormat:@"步行%d米",line.distance];
        }
        
        CGSize walkingSize = [self textHeightWithString:walkingLabel.text Font:15 height:15];
        walkingLabel.frame = kFrame(width+5, 35, walkingSize.width, 15);
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTaxiInfo:(BMKTaxiInfo *)taxiInfo
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [UIView setLayerWithView:self];
        
        void(^initLableBlock)(UILabel *) = ^(UILabel *label){
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            [self addSubview:label];
        };
        
        busTitleLabel = [[UILabel alloc]initWithFrame:kFrame(10, 10, SCREENWIDTH-40, 20)];
        busTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:busTitleLabel];
        
        timerLabel = [[UILabel alloc]initWithFrame:kFrame(10, 35, 0, 15)];
        initLableBlock(timerLabel);
        
        distanceLabel = [[UILabel alloc]initWithFrame:kFrame(100, 35, 0, 15)];
        initLableBlock(distanceLabel);
        
        walkingLabel = [[UILabel alloc]initWithFrame:kFrame(190, 35, 0, 15)];
        initLableBlock(walkingLabel);
        
        busTitleLabel.text = @"打车信息";
    
        
        __block float width = 0;
        void(^widthBlock)(UIView *) = ^(UIView *view){
            
            width = view.frame.origin.x + view.frame.size.width;
        };
        
        
        timerLabel.text = [NSString stringWithFormat:@"约%d分钟",taxiInfo.duration/60];
        
        CGSize timerSize = [self textHeightWithString:timerLabel.text Font:15 height:15];
        timerLabel.frame = kFrame(timerLabel.frame.origin.x, timerLabel.frame.origin.y,timerSize.width, 15);
        
        widthBlock(timerLabel);  // 调用块重设X轴
        
        
        // 分割线
        UIImageView *separate = [UIImageView addYSeparateLine:nil Frame:kFrame(width+5, 36, 1, 15)];
        [self addSubview:separate];
        
        widthBlock(separate);  // 调用块重设X轴
        
        // 公里Label
        distanceLabel.text = [NSString stringWithFormat:@"%0.1f公里",taxiInfo.distance/1000.0];
        CGSize distanceSize = [self textHeightWithString:distanceLabel.text Font:15 height:15];
        distanceLabel.frame = kFrame(width+5, 35, distanceSize.width, 15);
        
        widthBlock(distanceLabel);  // 调用块重设X轴
        
        // 分隔线
        UIImageView *separate2 = [UIImageView addYSeparateLine:nil Frame:kFrame(width+5, 36, 1, 15)];
        [self addSubview:separate2];
        
        widthBlock(separate2);
        
        // 步行米数Label
        walkingLabel.text = [NSString stringWithFormat:@"约%d元",taxiInfo.totalPrice];
        CGSize walkingSize = [self textHeightWithString:walkingLabel.text Font:15 height:15];
        walkingLabel.frame = kFrame(width+5, 35, walkingSize.width, 15);
        
        
        
        
    }
    
    return self;
}

//以一个字符串，和字体大小，宽度。返回一个label高度
-(CGSize)textHeightWithString:(NSString*)str Font:(CGFloat)font height:(CGFloat)height
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return size;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
