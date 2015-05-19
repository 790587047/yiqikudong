//
//  ReminderView.m
//  YiQiWeb
//
//  Created by BK on 14/11/24.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "ReminderView.h"

@implementation ReminderView
+(ReminderView *)reminderView
{
    static ReminderView*view;
    if (view==nil)
    {
        view = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
        view.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2+10);
        view.backgroundColor = [UIColor blackColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.alpha = 0.7;
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        label.center =CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2+20);
        label.text = @"loading";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [view addSubview:label];
        
        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2-10);
        [indicator startAnimating];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [view addSubview:indicator];
        
    }
    return view;
}
+(ReminderView *)reminderView1
{
    static ReminderView*view3;
    if (view3==nil)
    {
        view3 = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
        view3.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2+10);
        view3.backgroundColor = [UIColor blackColor];
        view3.layer.cornerRadius = 5;
        view3.layer.masksToBounds = YES;
        view3.alpha = 0.7;
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        label.center =CGPointMake(view3.bounds.size.width/2, view3.bounds.size.height/2+20);
        label.text = @"loading";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [view3 addSubview:label];
        
        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(view3.bounds.size.width/2, view3.bounds.size.height/2-10);
        [indicator startAnimating];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [view3 addSubview:indicator];
        
    }
    return view3;
}
+(ReminderView*)reminderViewWithTitle:(NSString*)title
{
    static ReminderView*view1;
    if (view1==nil)
    {
        view1 = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
        view1.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2+10);
        if ([title isEqualToString:@"正在加载中"]||[title isEqualToString:@"正在读取中"])
        {
            view1.backgroundColor = [UIColor blackColor];
        }else
        {
            view1.backgroundColor = [UIColor clearColor];
        }
       
        view1.layer.cornerRadius = 5;
        view1.layer.masksToBounds = YES;
//        view1.alpha = 0.7;
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        label.center =CGPointMake(view1.bounds.size.width/2, view1.bounds.size.height/2+20);
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [view1 addSubview:label];
        
        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(view1.bounds.size.width/2, view1.bounds.size.height/2-10);
        [indicator startAnimating];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [view1 addSubview:indicator];
    }else if (view1!=nil)
    {
        if ([title isEqualToString:@"正在加载中"]||[title isEqualToString:@"正在读取中"])
        {
            view1.backgroundColor = [UIColor blackColor];
        }
        for (UIView*uiview in view1.subviews)
        {
            if ([uiview isKindOfClass:[UILabel class]])
            {
                UILabel*label = (UILabel*)uiview;
                label.text = title;
            }
        }
    }
    return view1;
}
+(ReminderView*)reminderViewFrameWithTitle:(NSString*)title
{
    static ReminderView*view2;
    if (view2==nil)
    {
        int length = (int)title.length;
        if (length<15)
        {
            view2 = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, length*20, 40)];
        }else
        {
            view2 = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, 15*20, 40)];
        }
//        (length/15)*
        NSLog(@"%d",length);
        view2.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        view2.backgroundColor = [UIColor blackColor];
        view2.layer.cornerRadius = 5;
        view2.layer.masksToBounds = YES;
//        view2.alpha = 0.7;

        UILabel*label;
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view2.frame.size.width, view2.frame.size.height)];
        label.center =CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
        label.text = title;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [view2 addSubview:label];
    }else if (view2!=nil)
    {
        for (UIView*uiview in view2.subviews)
        {
            if ([uiview isKindOfClass:[UILabel class]])
            {
                UILabel*label = (UILabel*)uiview;
                int length = (int)title.length;
                if (length<15)
                {
                    label.frame = CGRectMake(0, 0, length*20, 40);
                }else
                {
                    label.frame = CGRectMake(0, 0, 300, 40);
                }
                
                label.text = title;
            }
        }
    }
    int length = (int)title.length;
    if (length<15)
    {
        view2.frame = CGRectMake(0, 0, length*20, 40);
    }else
    {
        view2.frame = CGRectMake(0, 0, 15*20, 40);
    }
    
    view2.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    return view2;
}

+(ReminderView*)reminderViewTitle:(NSString*)title withLevel:(NSString *)level withFlag:(BOOL)flag
{
    static ReminderView*videoView;
    if (videoView==nil)
    {
        videoView = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        videoView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        videoView.backgroundColor = [UIColor clearColor];
        videoView.layer.cornerRadius = 5;
        videoView.layer.masksToBounds = YES;
        
        UIView*baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        baseView.layer.cornerRadius = 5;
        baseView.layer.masksToBounds = YES;
        baseView.backgroundColor = [UIColor blackColor];
        baseView.alpha = 0.7;
        [videoView addSubview:baseView];
     
        UILabel*label;
        label = [[UILabel alloc]initWithFrame:CGRectMake(5, 120, videoView.frame.size.width-10, 25)];
        label.text = title;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [videoView addSubview:label];
        
        UIImageView*voiceLogo = [[UIImageView alloc]initWithFrame:CGRectMake(25, 30, 50, 75)];
        voiceLogo.tag = 110;
        voiceLogo.image = [UIImage imageNamed:@"chat_voice"];
        [videoView addSubview:voiceLogo];
        
        UIImageView*levelView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 30, 50, 75)];
        levelView.image = [UIImage imageNamed:@"chat_voice_p1"];
        levelView.tag = 111;
        [videoView addSubview:levelView];
        
        UIImageView*cancelView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 40, 80, 60)];
        cancelView.image = [UIImage imageNamed:@"chat_voice_cancel"];
        cancelView.tag = 112;
        [videoView addSubview:cancelView];
        [cancelView setHidden:YES];
    }else if (videoView!=nil)
    {
        for (UIView*uiview in videoView.subviews)
        {
            if ([uiview isKindOfClass:[UILabel class]])
            {
                UILabel*label = (UILabel*)uiview;
                UIImageView*voiceLogo = (UIImageView*)[videoView viewWithTag:110];
                UIImageView*levelView = (UIImageView*)[videoView viewWithTag:111];
                UIImageView*cancelView = (UIImageView*)[videoView viewWithTag:112];
                
                if (flag)
                {
                    label.text = title;
                    if ([title hasPrefix:@"手指"])
                    {
                        label.backgroundColor = [UIColor clearColor];
                        [voiceLogo setHidden:NO];
                        [levelView setHidden:NO];
                        [cancelView setHidden:YES];
                    }else
                    {
                        label.backgroundColor = [UIColor redColor];
                        [voiceLogo setHidden:YES];
                        [levelView setHidden:YES];
                        [cancelView setHidden:NO];
                    }
                }else
                {
                    levelView.image = [UIImage imageNamed:[NSString stringWithFormat:@"chat_voice_p%@",level]];
                }
            }
        }
    }
    videoView.frame = CGRectMake(0, 0, 150, 150);
    videoView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    return videoView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
