//
//  KZJShareSheet.m
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "ShareSheet.h"
#import "Common.h"

@implementation ShareSheet

@synthesize webview,item,imageData;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//自定义弹出框
+(ShareSheet*)shareWeiboView
{
    ShareSheet*view1 = nil;
    
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:kAppKey];
    if (view1==nil)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.89, 0.89, 0.89, 1 });
        CGColorRef colorref1 = CGColorCreate(colorSpace,(CGFloat[]){ 0.925, 0.925, 0.925, 1 });
        
        int num = 8;
        NSMutableArray*titleArray = [[NSMutableArray alloc]init];
//        ,@"face"
        //        NSMutableArray*imageArray = [[NSMutableArray alloc]initWithObjects:@"Action_MyFavAdd@2x",@"collection",@"saomiao",@"copy",@"flashlight",nil];
        NSMutableArray*imageArray = [[NSMutableArray alloc]initWithObjects:@"Action_MyFavAdd@2x",@"collection",@"movie",@"voicelogo",@"location_icon",@"refresh",@"saomiao",@"copy",@"flashlight",nil];
        
        if ([TencentApiInterface isTencentAppInstall:kIphoneQQ])
        {
        
            [titleArray insertObject:@"QQ空间" atIndex:0];
            [imageArray insertObject:@"qqkongjian" atIndex:0];
        }
        
//        if ([MFMessageComposeViewController canSendText])
//        {
        if (ABAddressBookGetAuthorizationStatus()!=2)
        {
            [titleArray insertObject:@"通讯录" atIndex:0];
            [imageArray insertObject:@"note" atIndex:0];
        }
        
//        }
        [titleArray insertObject:@"聊天" atIndex:0];
        [imageArray insertObject:@"qqkongjian" atIndex:0];
        
        [titleArray insertObject:@"腾讯微博" atIndex:0];
        [titleArray insertObject:@"新浪微博" atIndex:0];
        [imageArray insertObject:@"txweibo" atIndex:0];
        [imageArray insertObject:@"xlweibo" atIndex:0];
//        [imageArray insertObject:@"weibo_logo@2x" atIndex:0];
//        if ([WXApi isWXAppInstalled])
//        {
            [titleArray insertObject:@"微信朋友圈" atIndex:0];
            [titleArray insertObject:@"微信好友" atIndex:0];
            [imageArray insertObject:@"sharetowxmoments" atIndex:0];
            [imageArray insertObject:@"sharetowxfriend" atIndex:0];
//            [imageArray insertObject:@"Action_Moments@2x" atIndex:0];
//            [imageArray insertObject:@"Action_Share@2x" atIndex:0];
//        }
        [titleArray addObject:@"收藏"];
        [titleArray addObject:@"查看收藏"];
        [titleArray addObject:@"视频音频"];
        [titleArray addObject:@"录音"];
        [titleArray addObject:@"地图"];
//        [titleArray addObject:@"人脸识别"];
        [titleArray addObject:@"刷新"];
        [titleArray addObject:@"扫一扫"];
        [titleArray addObject:@"复制链接"];
        
        //        num = num+1;
        AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch])
        {
            num = num+1;
            [titleArray addObject:@"手电筒"];
        }
        
        view1 =[[ShareSheet alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-[UIApplication sharedApplication].statusBarFrame.size.height+20)];
        UIView*view;
        if (SCREENWIDTH==414)
        {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 170+(SCREENWIDTH-20)/5+SCREENWIDTH/7)];
        }else if(SCREENWIDTH==320)
        {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 170-10+(SCREENWIDTH-20)/4+SCREENWIDTH/7)];
        }else
        {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 160+(SCREENWIDTH-20)/5+SCREENWIDTH/7)];
        }
        
        view.tag=1200;
        view.layer.backgroundColor = colorref;
        
        UILabel*line1;
        if (SCREENWIDTH>320)
        {
            line1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25+(SCREENWIDTH-20)/5+25, SCREENWIDTH-20, 1)];
        }else
        {
            line1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25+(SCREENWIDTH-20)/4+25, SCREENWIDTH-20, 1)];
        }
        
        line1.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
        [view addSubview:line1];
        
        [view1 createScrollView:view];
        UIScrollView*shareScrollView = (UIScrollView*)[view viewWithTag:1201];
        UIScrollView*otherScrollView = (UIScrollView*)[view viewWithTag:1203];
        
        for (int i =0; i<[titleArray count]; i++)
        {
            UIButton*btn;
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UILabel*titleLabel;
            if (SCREENWIDTH>320)
            {
                if (i<[titleArray count]-num)
                {
                    btn.frame = CGRectMake(20+(SCREENWIDTH-20)/5*i, 15, (SCREENWIDTH-20)/5-18, (SCREENWIDTH-20)/5-18);
                    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, (SCREENWIDTH-20)/5-3, (SCREENWIDTH-20)/5-18, 30)];
                }else
                {
                    btn.frame = CGRectMake(20+(SCREENWIDTH-20)/5*(i-([titleArray count]-num)), 15, (SCREENWIDTH-20)/5-18, (SCREENWIDTH-20)/5-18);
                    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, (SCREENWIDTH-20)/5-3, (SCREENWIDTH-20)/5-18, 30)];
                }
            }else
            {
                if (i<[titleArray count]-num)
                {
                    btn.frame = CGRectMake(20+(SCREENWIDTH-20)/4*i, 15, (SCREENWIDTH-20)/4-18, (SCREENWIDTH-20)/4-18);
                    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, (SCREENWIDTH-20)/4-3, (SCREENWIDTH-20)/4-18, 30)];
                }else
                {
                    btn.frame = CGRectMake(20+(SCREENWIDTH-20)/4*(i-([titleArray count]-num)), 15, (SCREENWIDTH-20)/4-18, (SCREENWIDTH-20)/4-18);
                    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, (SCREENWIDTH-20)/4-3, (SCREENWIDTH-20)/4-18, 30)];
                }
            }
            titleLabel.font = [UIFont systemFontOfSize:12];
            
            //            NSLog(@"%f",btn.frame.size.width);
            [btn setBackgroundColor:[UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1]];
            btn.tag = 1000+i;
            [btn setImage:[UIImage redraw:[UIImage imageNamed:imageArray[i]] Frame:CGRectMake(0, 0, (SCREENWIDTH-20)/5-18, (SCREENWIDTH-20)/5-18)] forState:UIControlStateNormal];
            //            [btn setTitle:@"adsa" forState:UIControlStateHighlighted];
            btn.showsTouchWhenHighlighted = YES;
            btn.layer.cornerRadius = 10;
            //            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //            btn.layer.borderWidth = 1;
            btn.layer.masksToBounds = YES;
            [btn addTarget:view1 action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titleArray[i];
            titleLabel.tag = 1100+i;
            titleLabel.textColor = [UIColor colorWithRed:0.459 green:0.459 blue:0.459 alpha:1];
            if ([titleLabel.text isEqualToString:@"微信朋友圈"]&&SCREENWIDTH<400)
            {
                titleLabel.frame = CGRectMake(titleLabel.frame.origin.x-10, titleLabel.frame.origin.y, titleLabel.frame.size.width+20, titleLabel.frame.size.height);
            }
            if (i<[titleArray count]-num)
            {
                [shareScrollView addSubview:btn];
            }else
            {
                [otherScrollView addSubview:btn];
            }
            
            if (i<[titleArray count]-num)
            {
                [shareScrollView addSubview:titleLabel];
            }else
            {
                [otherScrollView addSubview:titleLabel];
            }
        }
        UIButton*cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, view.frame.size.height-SCREENWIDTH/7, SCREENWIDTH, SCREENWIDTH/7);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.layer.backgroundColor = colorref1;
        CGColorRelease(colorref1);
        cancel.layer.cornerRadius = 5;
        
        cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:view1 action:@selector(cancel1)];
        [cancel addGestureRecognizer:tap1];
        //        [cancel addTarget:view1.superview action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancel];
        
        UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        view2.backgroundColor= [UIColor blackColor];
        view2.alpha = 0.5;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:view1 action:@selector(cancel1)];
        [view2 addGestureRecognizer:tap];
        
        [view1 addSubview:view2];
        
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        
        [view1 addSubview:view];
        [UIView commitAnimations];
        //定义uiview动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];//动画运行时间
        if (SCREENWIDTH==414)
        {
            view.frame = CGRectMake(0, SCREENHEIGHT-[UIApplication sharedApplication].statusBarFrame.size.height+20 - 170-(SCREENWIDTH-20)/5-SCREENWIDTH/7, SCREENWIDTH, 170+(SCREENWIDTH-20)/5+SCREENWIDTH/7);//结束的位置
        }else if(SCREENWIDTH==320)
        {
            view.frame = CGRectMake(0, SCREENHEIGHT-[UIApplication sharedApplication].statusBarFrame.size.height+20 - 170+10-(SCREENWIDTH-20)/4-SCREENWIDTH/7, SCREENWIDTH, 170-10+(SCREENWIDTH-20)/4+SCREENWIDTH/7);//结束的位置
        }else
        {
            view.frame = CGRectMake(0, SCREENHEIGHT-[UIApplication sharedApplication].statusBarFrame.size.height+20 - 160-(SCREENWIDTH-20)/5-SCREENWIDTH/7, SCREENWIDTH, 160+(SCREENWIDTH-20)/5+SCREENWIDTH/7);//结束的位置
        }
        
        [UIView commitAnimations];//提交动画
    }
    view1.tag = 999;
    return view1;
}

-(void)cancel1
{
//    NSLog(@"%f",SCREENWIDTH);
    UIView*view = [self viewWithTag:1200];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];//动画运行时间
    if (SCREENWIDTH==414)
    {
        view.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 170+(SCREENWIDTH-20)/5+SCREENWIDTH/7);
    }else if(SCREENWIDTH==320)
    {
        view.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 170-10+(SCREENWIDTH-20)/4+SCREENWIDTH/7);

    }else
    {
        view.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 160+(SCREENWIDTH-20)/5+SCREENWIDTH/7);
    }
    
    [UIView commitAnimations];//提交动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
-(void)createScrollView:(UIView*)view
{
    NSMutableArray*titleArray = [[NSMutableArray alloc]init];
    int num=8;
    
    if ([TencentApiInterface isTencentAppInstall:kIphoneQQ])
    {
        [titleArray insertObject:@"QQ空间" atIndex:0];
    }
    if ([MFMessageComposeViewController canSendText])
    {
    
        [titleArray insertObject:@"通讯录" atIndex:0];
        NSLog(@"ABAddressBookGetAuthorizationStatus==%lu",ABAddressBookGetAuthorizationStatus());
    }

    [titleArray insertObject:@"聊天" atIndex:0];
    
    [titleArray insertObject:@"腾讯微博" atIndex:0];
    [titleArray insertObject:@"新浪微博" atIndex:0];
//    if ([WXApi isWXAppInstalled])
//    {
        [titleArray insertObject:@"微信朋友圈" atIndex:0];
        [titleArray insertObject:@"微信好友" atIndex:0];
//    }
    [titleArray addObject:@"收藏"];
    [titleArray addObject:@"查看收藏"];
    [titleArray addObject:@"扫一扫"];
    [titleArray addObject:@"地图"];
//    [titleArray addObject:@"人脸识别"];
    [titleArray addObject:@"复制链接"];
    [titleArray addObject:@"刷新"];
    [titleArray addObject:@"视频音频"];
    [titleArray addObject:@"录音"];
    //    num = num+1;
    AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        num = num+1;
        [titleArray addObject:@"手电筒"];
    }

    UIScrollView*shareScrollView;
    if (SCREENWIDTH>320)
    {
        shareScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 25+(SCREENWIDTH-20)/5)];
        shareScrollView.contentSize = CGSizeMake(([titleArray count]-num)*(SCREENWIDTH-20)/5+20, 25+(SCREENWIDTH-20)/5);
    }else
    {
        shareScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 25+(SCREENWIDTH-20)/4)];
        shareScrollView.contentSize = CGSizeMake(([titleArray count]-num)*(SCREENWIDTH-20)/4+20, 25+(SCREENWIDTH-20)/4);
    }
    
    shareScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    shareScrollView.tag = 1201;
    shareScrollView.delegate = (id<UIScrollViewDelegate>)self;
    shareScrollView.showsHorizontalScrollIndicator = NO;
    [view addSubview:shareScrollView];
    
    UIScrollView*otherScrollView;
    if (SCREENWIDTH>320)
    {
        otherScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 25+(SCREENWIDTH-20)/5+25, SCREENWIDTH, 25+(SCREENWIDTH-20)/5)];
        otherScrollView.contentSize = CGSizeMake((SCREENWIDTH-20)/5*num+20, 25+(SCREENWIDTH-20)/5);
    }else
    {
        otherScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 25+(SCREENWIDTH-20)/4+25, SCREENWIDTH, 25+(SCREENWIDTH-20)/4)];
        otherScrollView.contentSize = CGSizeMake((SCREENWIDTH-20)/4*num+20, 25+(SCREENWIDTH-20)/4);
    }
    otherScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    otherScrollView.tag = 1203;
    otherScrollView.delegate = (id<UIScrollViewDelegate>)self;
    otherScrollView.showsHorizontalScrollIndicator = NO;
    [view addSubview:otherScrollView];
}

-(void)btnAction:(UIButton*)btn
{
    //    NSLog(@"%@",btn);
    //    UIButton*btn = (UIButton*)tap.view;
    NSString *imgUrl = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[0].src;"];
    
    UILabel*label = (UILabel*)[self viewWithTag:btn.tag+100];
    //    NSLog(@"==%@",webview.request.URL);
    NSMutableDictionary*dict = [[NSMutableDictionary alloc]init];
    if (webview.request.URL!=nil)
    {
        [dict setObject:webview.request.URL forKey:@"shareUrl"];
    }
    if (label.text!=nil)
    {
        [dict setObject:label.text forKey:@"shareKind"];
    }
    if (imgUrl!=nil)
    {
        [dict setObject:imgUrl forKey:@"imageUrl"];
    }
    if(imageData!=nil)
    {
        [dict setObject:imageData forKey:@"imageData"];
    }
    if ([webview stringByEvaluatingJavaScriptFromString:@"document.title"]!=nil)
    {
        [dict setObject:[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL] forKey:@"content"];
    }
    NSNotification *notification = [NSNotification notificationWithName:@"shareKind" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    if ([label.text isEqualToString:@"新浪微博"])
    {
        NSDictionary*dict;
        
        if (([[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]||webview.request.URL==nil)&&item.imgData==nil)
        {
            dict = @{@"shareKind":label.text};
        }
        if ((![[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]&&webview.request.URL!=nil)&&item.imgData!=nil) {
            dict = @{@"shareKind":label.text,@"shareContent":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL],@"imageData":item.imgData};
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil userInfo:dict];
        
    }else if ([label.text isEqualToString:@"腾讯微博"])
    {
        NSDictionary*dict;
        
        if (([[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]||webview.request.URL==nil)&&item.imgData==nil)
        {
            dict = @{@"shareKind":label.text};
        }
        if ((![[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]&&webview.request.URL!=nil)&&item.imgData!=nil) {
            dict = @{@"shareKind":label.text,@"shareContent":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL],@"imageData":item.imgData};
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil userInfo:dict];
    }else if ([label.text isEqualToString:@"微信好友"])
    {
        
//        UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//        if (item.imgData!=nil)
//        {
//            if (item.imgData.length/1024>30)
//            {
//                image.image = [self imageWithImage:[UIImage imageWithData:item.imgData] scaledToSize:CGSizeMake(200, 200)];
//            }else
//            {
//                image.image = [UIImage imageWithData:item.imgData];
//            }
//        }
//        image.image = [UIImage imageWithData:item.imgData];
//        [self.superview addSubview:image];
        if ([WXApi isWXAppInstalled]) {
            [self changeScene:WXSceneSession];
            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WXNOTInstalled" object:nil];
        }
    }else if ([label.text isEqualToString:@"微信朋友圈"])
    {
//        NSLog(@"%lu",(unsigned long)item.imgData.length);
//        if ([WXApi isWXAppInstalled]) {
//            [self changeScene:WXSceneTimeline];
//            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil];
//        }
//        else {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"WXNOTInstalled" object:nil];
//        }

//        [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]
        
//        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"])
//        {
//            if ([self tokenValid])
//            {
//                
//            }else
//            {
//                
//            }
//        }else

//        {
            SendAuthReq* req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo,snsapi_base";
            req.state = @"0744" ;
            [WXApi sendReq:req];
        
//        }

//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services:///?action=download-manifest&url=https://dn-yiqikudong.qbox.me/yiqikudong.plist"]];
    }else if ([label.text isEqualToString:@"QQ空间"])
    {
        NSDictionary*dict;
        
        if (([[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]||webview.request.URL==nil)&&item.imgData==nil)
        {
            dict = @{@"shareKind":label.text};
        }
        if ((![[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]&&webview.request.URL!=nil)&&item.imgData!=nil) {
            dict = @{@"shareKind":label.text,@"shareContent":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL],@"imageData":item.imgData};
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil userInfo:dict];
        
    }else if ([label.text isEqualToString:@"收藏"])
    {
        NSString *message;
//        NSLog(@"===%@",item.title);
        if (item.url.length > 0) {
            Collection *info = [Collection getCollectionInfo:item.url];
            if (info.cId.length == 0) {
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                item.publishDate = [dateFormat stringFromDate:[NSDate date]];
                NSData *iData = item.imgData;
                iData = [Common dealImage:iData];
                if ([Collection addCollection:item WithImgData:iData]) {
                    message = @"收藏成功";
                }
                else
                    message = @"收藏失败";
            }
            else
            {
                //更新图片
                if (info.imgData.length == 0) {
                    if ([Collection updateImage:item.imgData withId:info.cId]) {
                        message = @"已收藏";
                    }
                    else
                        message = @"收藏失败";
                }
                else{
                    message = @"已收藏";
                }
            }
        }else
        {
            message = @"收藏失败，请检查网络";
        }
        [Common showMessage:message withView:self.superview];
    }
    else if ([label.text isEqualToString:@"查看收藏"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushCollections" object:nil];
    }else if ([label.text isEqualToString:@"复制链接"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *msg;
//        ReminderView*remiderView;
        NSLog(@"%@",webview.request.URL);
        if ([[NSString stringWithFormat:@"%@",webview.request.URL] isEqualToString:@""]||webview.request.URL==nil)
        {
            msg = @"复制链接失败";
//            remiderView = [ReminderView reminderViewFrameWithTitle:@"复制链接失败"];
//            [self.superview addSubview:remiderView];
        }else
        {
            pasteboard.string = [NSString stringWithFormat:@"%@",webview.request.URL];
            msg = @"复制链接成功";
//            remiderView = [ReminderView reminderViewFrameWithTitle:@"复制链接成功"];
//            [self.superview addSubview:remiderView];
        }
        [Common showMessage:msg withView:self.superview];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationDuration:0.5];//动画运行时间
//            remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//            [UIView commitAnimations];//提交动画
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [remiderView removeFromSuperview];
//            });
//        });
    }else if ([label.text isEqualToString:@"手电筒"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"flashlight" object:nil];
    }else if ([label.text isEqualToString:@"扫一扫"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"camera" object:nil];
    }else if ([label.text isEqualToString:@"视频音频"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"video" object:nil];
    }else if ([label.text isEqualToString:@"地图"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"map" object:nil];
    }else if ([label.text isEqualToString:@"人脸识别"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"face" object:nil];
    }else if ([label.text isEqualToString:@"刷新"])
    {
        if (!webview.canGoBack)
        {
            NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:APPURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
            [webview loadRequest:request];
//            webview.delegate = 
        }else
        {
            [webview stringByEvaluatingJavaScriptFromString:@"window.location.reload()"];
        }
    }else if ([label.text isEqualToString:@"录音"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"record" object:nil];
    }else if ([label.text isEqualToString:@"通讯录"])
    {
        if (ABAddressBookGetAuthorizationStatus()!=2)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"sendnote" object:nil];
        }else
        {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您设置了应用拒绝访问您的通讯录信息，请到设置中重新设置才能调用通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else if ([label.text isEqualToString:@"聊天"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chat" object:nil];
        [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"群聊界面"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [self cancel1];
}
#pragma mark 判断微信token有效与否
-(BOOL)tokenValid
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"], [[NSUserDefaults standardUserDefaults] valueForKey:@"openid"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
//                NSLog(@"%@===%@",[dic objectForKey:@"nickname"],[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]]);
//                NSLog(@"%@===%@===%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"],[[NSUserDefaults standardUserDefaults] valueForKey:@"openid"],[[NSUserDefaults standardUserDefaults] valueForKey:@"refresh_token"]);
            }
        });
        
    });
    return YES;
}
-(void)changeScene:(int)scene{
    _scene = (enum WXScene) scene;
    [self sendImageContent];
}

-(void) sendImageContent{
    if ((![[NSString stringWithFormat:@"%@",item.url] isEqualToString:@""]&&item.url!=nil)&&item.imgData!=nil)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = item.title;
        message.description = item.title;
        if (item.imgData!=nil)
        {
            if (item.imgData.length/1024>30)
            {
                [message setThumbImage:[self imageWithImage:[UIImage imageWithData:item.imgData] scaledToSize:CGSizeMake(200, 200)]];
            }else
            {
                [message setThumbImage:[UIImage imageWithData:item.imgData]];
            }
        }
//        UIImageView*
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = item.url;
        //    NSLog(@"%@===%@===%@===%@",item.title,item.title,item.url,imageData);
        message.mediaObject = ext;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = (int)_scene;
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WXApi sendReq:req];
    }else
    {
        ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"请求数据出错，请稍后重试"];
        [self.superview addSubview:remiderView];
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
}
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
+(UIView*)shareCardView
{
    UIView*view;
    return view;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    if (scrollView.tag==1201)
    //    {
    //        UIPageControl*pageControl = (UIPageControl*)[self viewWithTag:1202];
    //        pageControl.currentPage = (int)scrollView.contentOffset.x/SCREENWIDTH;
    //    }else if (scrollView.tag ==1203)
    //    {
    //        UIPageControl*pageControl = (UIPageControl*)[self viewWithTag:1204];
    //        pageControl.currentPage = (int)scrollView.contentOffset.x/SCREENWIDTH;
    //    }
}
@end
