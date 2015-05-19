

#import "UIImage+Redraw.h"
@implementation UIImage (Redraw)
+(UIImage*)redraw:(UIImage *)newImage Frame:(CGRect)frame{
    UIImage*image=newImage;
    UIGraphicsBeginImageContext(frame.size);
    [image drawInRect:frame];
    image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation UIButton(addtion)
// tabBar
+(UIButton*)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame image:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action{
    UIButton*button=[UIButton buttonWithType:buttonType];
    button.frame=frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:kFrame(0, 0, 20, 20)];
    imageV.image = image;
    [button addSubview:imageV];
    
    UILabel *label = [[UILabel alloc]initWithFrame:kFrame(20, 0, 40,20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    [button addSubview:label];
    
    return button;
}

+(UIButton *)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame image:(UIImage *)image title:(NSString *)title target:(id)target andAction:(SEL)action
{
    UIButton*button=[UIButton buttonWithType:buttonType];
    button.frame=frame;
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 封装导航按钮
+ (UIButton *)packageButtonWithImage:(UIImage *)image Title:(NSString *)title Frame:(CGRect)frame
{
    UIButton *navgationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    navgationBtn.frame = frame;
    // 图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kFrame(0, 0, 25, 25)];
    imageView.image = image;
    imageView.center = CGPointMake(frame.size.width/2 -25, frame.size.height/2);
    [navgationBtn addSubview:imageView];
    // 文字
    UILabel *navgationTitle = [[UILabel alloc] initWithFrame:kFrame(0, 0, 60, 30)];
    navgationTitle.text = title;
    navgationTitle.textAlignment = NSTextAlignmentLeft;
    navgationTitle.font = [UIFont systemFontOfSize:14];
    navgationTitle.center = CGPointMake(frame.size.width/2 + 20, frame.size.height/2);
    [navgationBtn addSubview:navgationTitle];
    
    return navgationBtn;
}

//  蓝色按钮
+ (UIButton *)blueSystemButtonWithButtonType:(UIButtonType)type title:(NSString *)title frame:(CGRect)rect
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = rect;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = NO;
    return btn;
}

+(UIButton*)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage title:(NSString *)title target:(id)target action:(SEL)action{
    UIButton*button=[UIButton buttonWithType:buttonType];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
