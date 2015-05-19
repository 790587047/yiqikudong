//
//  MyView.m
//  JieTu
//
//  Created by 1026 on 14-8-18.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MyView.h"

@implementation MyView
@synthesize picker,controller,originalImage;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)img
{
    self = [super initWithFrame:frame];
    if (self) {
//        flag = 0;
        self.backgroundColor = [UIColor blackColor];
        imageNow = [[UIImageView alloc]init];
//        view1 = [[UIView alloc]initWithFrame:CGRectMake(60, 100, 200, 300)];
        imageBefore = [[UIImageView alloc]initWithFrame:CGRectMake(30, 94, SCREENWIDTH-60, SCREENHEIGHT-64-60)];
        imageBefore.image = img;
        originalImage = img;
        NSLog(@"%@",img);
        [self sendSubviewToBack:imageBefore];
        self.backgroundColor = [UIColor colorWithPatternImage:[self imageWithImage:img scaledToSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT-64)]];
    }
    return self;
}
#pragma mark 图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


-(UIImage*)jietu
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960),YES,0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect =CGRectMake([arr[0] CGPointValue].x*2+1, [arr[0] CGPointValue].y*2+1,([arr[[arr count]-1] CGPointValue].x - [arr[0] CGPointValue].x)*2-2, ([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y)*2-2);//这里可以设置想要截图的区域
//    CGRect rect =CGRectMake(100 , 100,540, 860);
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);

    return sendImage;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    arr = [[NSMutableArray alloc]init];
    CGPoint startPoint = [[touches anyObject] locationInView:self];
    [arr addObject:[NSValue valueWithCGPoint:startPoint]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint movePoint = [[touches anyObject] locationInView:self];
    [arr addObject:[NSValue valueWithCGPoint:movePoint]];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    [arr addObject:[NSValue valueWithCGPoint:endPoint]];
    
    CGRect rect =CGRectMake([arr[0] CGPointValue].x+1, [arr[0] CGPointValue].y+1,([arr[[arr count]-1] CGPointValue].x - [arr[0] CGPointValue].x)-2, ([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y)-2);
    UIView *view1 = [self viewWithTag:1200];
    if (view1 ==nil)
    {
        view1 = [[UIView alloc]initWithFrame:rect];
        view1.backgroundColor = [UIColor clearColor];
        view1.tag = 1200;
        [self addSubview:view1];
    }else
    {
        view1.frame = rect;
    }
    for (int i = 0; i<4; i++)
    {
        UIView*view = [self viewWithTag:1100+i];
        float x = [arr[0] CGPointValue].x<[arr[[arr count]-1] CGPointValue].x?[arr[0] CGPointValue].x:[arr[[arr count]-1] CGPointValue].x;
        float y = [arr[0] CGPointValue].y<[arr[[arr count]-1] CGPointValue].y?[arr[0] CGPointValue].y:[arr[[arr count]-1] CGPointValue].y;
        
        if (view==nil)
        {
            if (i==0)
            {
                view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, y)];
            }else if (i==1)
            {
                view = [[UIView alloc]initWithFrame:CGRectMake(0, y, x, fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y))];
            }else if (i==2)
            {
                view = [[UIView alloc]initWithFrame:CGRectMake(x+fabs([arr[[arr count]-1] CGPointValue].x - [arr[0] CGPointValue].x), y, SCREENWIDTH-(x+fabs([arr[[arr count]-1] CGPointValue].x - [arr[0] CGPointValue].x)), fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y))];
            }else if (i==3)
            {
                view = [[UIView alloc]initWithFrame:CGRectMake(0, y+fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y), SCREENWIDTH, SCREENHEIGHT-y-fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y)-64)];
            }
            view.alpha = 0.7;
            view.tag = 1100+i;
            view.backgroundColor = [UIColor blackColor];
            [self addSubview:view];
        }else
        {
            if (i==0)
            {
                view.frame = CGRectMake(0, 0, SCREENWIDTH, y);
            }else if (i==1)
            {
                view.frame = CGRectMake(0, y, x, fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y));
            }else if (i==2)
            {
                view.frame = CGRectMake(x+fabs([arr[[arr count]-1] CGPointValue].x - [arr[0] CGPointValue].x), y, SCREENWIDTH-(x+fabs([arr[[arr count]-1] CGPointValue].x - [arr[0] CGPointValue].x)), fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y));
            }else if (i==3)
            {
                view.frame = CGRectMake(0, y+fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y), SCREENWIDTH, SCREENHEIGHT-y-fabs([arr[[arr count]-1] CGPointValue].y - [arr[0] CGPointValue].y)-64);
            }
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);//color有个属性cgcolor
    //设置画笔大小
    CGContextSetLineWidth(context, 1);
    
    //lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    //注意count的值等于lengths数组的长度
    //phase参数表示在第一个虚线绘制的时候跳过多少个点,也就是说是一开始少画了几点实线部分的
    //CGContextSetLineDash(<#CGContextRef c#>, <#CGFloat phase#>, <#const CGFloat *lengths#>, <#size_t count#>)
    
    CGFloat lenghts[] = {10,10};
    CGContextSetLineDash(context, 0, lenghts, 2);
    CGContextMoveToPoint(context, [arr[0] CGPointValue].x, [arr[0] CGPointValue].y);
    CGContextAddLineToPoint(context, [arr[0] CGPointValue].x, [arr[[arr count]-1] CGPointValue].y);
    CGContextAddLineToPoint(context, [arr[[arr count]-1] CGPointValue].x, [arr[[arr count]-1] CGPointValue].y);
    CGContextAddLineToPoint(context, [arr[[arr count]-1] CGPointValue].x, [arr[0] CGPointValue].y);
    CGContextAddLineToPoint(context, [arr[0] CGPointValue].x, [arr[0] CGPointValue].y);
    CGContextStrokePath(context);
}


@end
