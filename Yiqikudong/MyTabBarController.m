//
//  KZJMyTabBarController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

@synthesize selectedBtn,seletedImageArr,imageArr,direction,btnArr,titleArray,baseView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithImage:(NSMutableArray *)image SeletedImage:(NSMutableArray *)seletedImage
{
    if (self = [super init])
    {
        NSLog(@"12");
        imageArr = image;
        seletedImageArr = seletedImage;
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nav_mine" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nav_mine) name:@"nav_mine" object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nav_mine_download" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nav_mine) name:@"nav_mine_download" object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"startAnimation" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation:) name:@"startAnimation" object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"stopAnimation" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:@"stopAnimation" object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:@"hide" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"show" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"show" object:nil];
}
-(void)hide
{
    [baseView setHidden:YES];
}
-(void)show
{
    [baseView setHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化原来的tabbar的image
    //隐藏原有的tabBar
    self.tabBar.hidden =YES;  //隐藏TabBarController自带的下部的条s
    static int i =1;
    if (i) {
        for (int i=0; i<self.imageArr.count; i++)
        {
//                    UINavigationController* nav = [self.viewControllers objectAtIndex:i];
            UIImage* selectImg = [self.imageArr objectAtIndex:i];
            if (self.tabBarItem.image==NULL || self.tabBarItem.image==nil)
            {
                [self.tabBarItem setImage:selectImg];
                [self.tabBarController.view setHidden:YES];
            }
        }
        [self btn];
        i=0;
    }
}
-(void)nav_mine
{
    UIButton*btn = (UIButton*)[baseView viewWithTag:1003];
    [self clickBtn:btn];
}

-(void)btn
{
    //    self.tabBar.backgroundColor = [UIColor blackColor];
    
    if (SCREENWIDTH==320)
    {
        baseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-45, SCREENWIDTH, 45)];
    }else
    {
        baseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-55, SCREENWIDTH, 55)];
    }
    UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 2)];
    line.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    [baseView addSubview:line];
    baseView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:baseView];
    CGRect rect = baseView.frame;
    //在视图上添加按钮
    for (int i = 0; i<5; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==2)
        {
            btn.frame = CGRectMake(i*rect.size.width/5, -0.4*rect.size.height, rect.size.width/5, rect.size.height*1.4);
            btn.tag = 1000+i;
            [self.tabBar bringSubviewToFront:btn];
            //            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setBackgroundImage:[self.imageArr objectAtIndex:i] forState:UIControlStateNormal];
//            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"playvoice"] Frame:CGRectMake(0, 0, 25, 45)] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//            UITapGestureRecognizer*tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtn:)];
//            [btn addGestureRecognizer:tap];
            [baseView addSubview:btn];
            [self.btnArr addObject:btn];
        }else
        {
            btn.frame = CGRectMake(i*rect.size.width/5, 0, rect.size.width/5, rect.size.height);
            btn.tag = 1000+i;
            //            [btn setBackgroundColor:[UIColor whiteColor]];
            if (SCREENWIDTH==320)
            {
                UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width/5-29)/2, 4, 29, 29)];
                image.image = [self.imageArr objectAtIndex:i];
                image.tag = 1200+i;
                [btn addSubview:image];
            }else
            {
                UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width/5-30)/2, 6, 30, 30)];
                image.image = [self.imageArr objectAtIndex:i];
                image.tag = 1200+i;
                [btn addSubview:image];
//                [btn setImage:[UIImage redraw:[self.imageArr objectAtIndex:i] Frame:CGRectMake(0, 0, 33, 33)] forState:UIControlStateNormal];
            }
            
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
            
            //调整标题位置
            UILabel* label;
            if (SCREENWIDTH==320)
            {
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, rect.size.width/5, 18)];
            }else
            {
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, rect.size.width/5, 18)];
            }
            
            [label setBackgroundColor:[UIColor clearColor]];
            label.font=[UIFont boldSystemFontOfSize:12];
            label.tag =1100+i;
            if (i>2)
            {
                label.text = titleArray[i-1];
            }else
            {
                label.text = titleArray[i];
            }
            
            label.textColor = [UIColor grayColor];
            label.textAlignment=NSTextAlignmentCenter;
            [btn addSubview:label];
            
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:btn];
            [self.btnArr addObject:btn];
            if (i == 0 &&flag==0)
            {
                
                UIImageView*image = (UIImageView*)[baseView viewWithTag:1200];
                image.image = [self.seletedImageArr objectAtIndex:i];
                [btn addSubview:image];
                

//                [btn setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:i] Frame:CGRectMake(0, 0, 33, 33)] forState:UIControlStateSelected];
                label.textColor = [UIColor orangeColor];
                btn.selected = YES;
                self.selectedBtn = btn;
            }
        }
        
    }
   
}

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
//    self.selectedBtn.selected = NO;
    if (button.tag-1000==2)
    {
        PlayVoiceViewController*playVoiceView = [[PlayVoiceViewController alloc]init];
        playVoiceView.model = nil;
        [self presentViewController:playVoiceView animated:YES completion:^{
//            [self startAnimation];
        }];
//        UIButton*btn = (UIButton*)[baseView viewWithTag:1000+self.selectedIndex];
//        btn.selected = NO;
//        UILabel*label1 = (UILabel*)[baseView viewWithTag:1100+self.selectedIndex];
//        label1.textColor = [UIColor grayColor];
//        self.selectedIndex = button.tag - 1000;
    }else if(button.tag-1000==4)
    {
        
        RecordingView*recordingview = [[RecordingView alloc]init];
        [self presentViewController:recordingview animated:YES completion:^{
            
        }];
    }else
    {
//        [self stopAnimation];
        //        self.selectedBtn.selected = NO;
        UIButton*btn = (UIButton*)[baseView viewWithTag:1000+self.selectedIndex];
        btn.selected = NO;
        UILabel*label1 = (UILabel*)[baseView viewWithTag:1100+self.selectedIndex];
        label1.textColor = [UIColor grayColor];
        
//        UIImageView*image = (UIImageView *)[baseView viewWithTag:1200+self.selectedIndex];
//        image.frame = CGRectMake((SCREENWIDTH/5-29)/2, 4, 29, 29);
//        image.image = [self.imageArr objectAtIndex:self.selectedIndex];
        
        if (SCREENWIDTH==320) {
            UIImageView*image = (UIImageView *)[baseView viewWithTag:1200+self.selectedIndex];
            image.frame = CGRectMake((SCREENWIDTH/5-29)/2, 4, 29, 29);
            image.image = [self.imageArr objectAtIndex:self.selectedIndex];
        }else
        {
            UIImageView*image = (UIImageView *)[baseView viewWithTag:1200+self.selectedIndex];
            image.frame = CGRectMake((SCREENWIDTH/5-30)/2, 6, 30, 30);
            image.image = [self.imageArr objectAtIndex:self.selectedIndex];
        }
        
        //2.再将当前按钮设置为选中
        if (self.selectedIndex!=button.tag-1000)
        {
            if (SCREENWIDTH==320) {
                UIImageView*image = (UIImageView *)[baseView viewWithTag:button.tag+200];
                image.frame = CGRectMake((SCREENWIDTH/5-29)/2, 4, 29, 29);
                image.image = [self.seletedImageArr objectAtIndex:button.tag-1000];
            }else
            {
                UIImageView*image = (UIImageView *)[baseView viewWithTag:button.tag+200];
                image.frame = CGRectMake((SCREENWIDTH/5-30)/2, 6, 30, 30);
                image.image = [self.seletedImageArr objectAtIndex:button.tag-1000];
            }
            
//            [button setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:button.tag-1000] Frame:CGRectMake(0, 0, 33, 33)] forState:UIControlStateSelected];
            self.selectedIndex = button.tag-1000;
        }else
        {
            if (SCREENWIDTH==320) {
                UIImageView*image = (UIImageView *)[baseView viewWithTag:button.tag+200];
                image.frame = CGRectMake((SCREENWIDTH/5-29)/2, 4, 29, 29);
                image.image = [self.seletedImageArr objectAtIndex:button.tag-1000];
            }else
            {
                UIImageView*image = (UIImageView *)[baseView viewWithTag:button.tag+200];
                image.frame = CGRectMake((SCREENWIDTH/5-30)/2, 6, 30, 30);
                image.image = [self.seletedImageArr objectAtIndex:button.tag-1000];
            }
//            [button setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:button.tag-1000] Frame:CGRectMake(0, 0, 33, 33)] forState:UIControlStateSelected];
            self.selectedIndex = button.tag-1000;
        }
        UILabel*label = (UILabel*)[baseView viewWithTag:1100+self.selectedIndex];
        label.textColor = [UIColor orangeColor];
    }
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    if (button.tag>1002)
    {
//        [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:button.tag-1000-1]];
    }else if(button.tag<1002)
    {
//        [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:button.tag-1000]];
    }
    
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)startAnimation:(NSNotification*)notif
{
    VoiceObject *_model = [[notif userInfo]objectForKey:@"image"];
    flagStart = 1;
    UIButton*btn = (UIButton*)[baseView viewWithTag:1002];
    UIImageView*imageview = (UIImageView*)[btn viewWithTag:100];
    if (imageview==nil)
    {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 8, baseView.frame.size.width/5-10, baseView.frame.size.width/5-10)];
        imageview.layer.cornerRadius = (baseView.frame.size.width/5-10)/2;
        imageview.tag = 100;
        imageview.layer.masksToBounds = YES;
        [btn addSubview:imageview];
    }
    if([_model.picPath hasSuffix:@"png"]||[_model.picPath hasSuffix:@"jpg"]||[_model.picPath hasSuffix:@"jpeg"]||[_model.picPath hasSuffix:@"gif"]){
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.picPath]];
        [imageview setImage:[UIImage imageWithData:imageData]];
    }
    else if(_model.voicePic != nil){
        [imageview setImage:[UIImage imageWithData:_model.voicePic]];
    }
    else{
        imageview.image = [UIImage imageNamed:@"voiceDefault"];
    }
//    imageview.image = [UIImage imageNamed:@"takeVideo"];
    [self rotateAction];
}
-(void)rotateAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton*btn = (UIButton*)[baseView viewWithTag:1002];
        UIImageView*imageview = (UIImageView*)[btn viewWithTag:100];
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 8;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 9999;
        [imageview.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}

-(void)stopAnimation
{
    UIButton*btn = (UIButton*)[baseView viewWithTag:1002];
    UIImageView*imageview = (UIImageView*)[btn viewWithTag:100];
    [imageview.layer removeAllAnimations];
}
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
