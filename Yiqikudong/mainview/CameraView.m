//
//  CameraView.m
//  YiQiWeb
//
//  Created by BK on 14/11/25.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "CameraView.h"
#import "ReminderView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Common.h"
@interface CameraView ()

@end

@implementation CameraView
@synthesize kind;
-(void)dealloc
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    webView.delegate = nil;
    webView = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor  = [UIColor blackColor];
//    self.view.alpha = 0.4;
    self.title = kind;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;//右滑推出
    item = [[Collection alloc] init];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStylePlain target:self action:@selector(cameraAction)];
    btnMore.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 130, SCREENWIDTH-100, SCREENWIDTH-100)];
    //    imageView.image = [UIImage imageNamed:@"pick_bg"];
    NSArray*imageArray = [[NSArray alloc]initWithObjects:@"ScanQR1@2x",@"ScanQR2@2x",@"ScanQR3@2x",@"ScanQR4@2x",nil];
    for (int i = 0; i<4; i++)
    {
        UIImageView*image ;
        if (i<2)
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake((imageView.frame.size.width-32)*i, 0, 32, 32)];
        }else
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake((imageView.frame.size.width-32)*(i-2), imageView.frame.size.width-32, 32, 32)];
        }
        image.image = [UIImage imageNamed:imageArray[i]];
        [imageView addSubview:image];
        
    }
    imageView.tag = 1100;
//    imageView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    //将二维码/条形码放入框内，即可自动扫描
    
    UILabel*reminderLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x-20, imageView.frame.origin.y+imageView.frame.size.height+10, imageView.frame.size.width+40, 30)];
    if ([kind isEqualToString:@"扫一扫"])
    {
        reminderLabel.text = @"将二维码/条形码放入框内，即可自动扫描";
    }
    reminderLabel.textColor = [UIColor lightGrayColor];
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    reminderLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:reminderLabel];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+10, imageView.frame.origin.y+10, SCREENWIDTH-120, 2)];
    //    NSLog(@"%@",[UIDevice currentDevice].systemVersion);
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

//调用相册
-(void)cameraAction
{
    if ([kind isEqualToString:@"扫一扫"])
    {
//        [_session stopRunning];

        ZBarReaderController *reader = [ZBarReaderController new];
        reader.allowsEditing = NO;
        reader.showsHelpOnFail = YES;
        reader.readerDelegate = self;
        reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:reader animated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
    }else if ([kind isEqualToString:@"人脸识别"])
    {
//        BSImagePicker
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.delegate=self;
            [imagePicker setEditing:YES animated:YES];//允许编辑
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            //            imagePicker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*)kUTTypeMovie,nil];
            [self presentViewController:imagePicker animated:YES completion:^{
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
            
        }
        else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法打开相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }
}
-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    NSLog(@"%u",retry);
}


//打开相册之后选择方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString*mediaType=[info valueForKey:UIImagePickerControllerMediaType];
    //    NSLog(@"%@",info);
    if ([mediaType hasSuffix:@"image"]) {//如果有image后缀
        
        if ([kind isEqualToString:@"扫一扫"])
        {
            id image=[info valueForKey:ZBarReaderControllerResults];//当前图片
            //将选择图片存至相册
            //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            ZBarSymbol*symbol = nil;
            for(symbol in image)
                break;
//            NSLog(@"===%@",symbol.data);
            webUrl = symbol.data;
            //        NSLog(@"%@",image);
            if ([webUrl hasPrefix:@"http"])
            {
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定前往%@吗？",webUrl] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                [alert show];
            }else
            {
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",webUrl] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                [_session startRunning];
            }];//弹出相册界面
        }else if ([kind isEqualToString:@"人脸识别"])
        {
            UIView*view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            [picker.view addSubview:view1];
            
            MyView*view = [[MyView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) withImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
            view.picker = picker;
            view.controller = self;
            view.tag = 1000;
            [view1 addSubview:view];
            
            UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
            view2.backgroundColor = [UIColor whiteColor];
            [view1 addSubview:view2];
            
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 30, 100, 30)];
            label.text = @"选择图片";
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            [view2 addSubview:label];
            
            UIButton*back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame = CGRectMake(10, 30, 50, 30);
            [back setTitle:@"取消" forState:UIControlStateNormal];
            [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:back];
            
            UIButton*confirm = [UIButton buttonWithType:UIButtonTypeCustom];
            confirm.frame = CGRectMake(SCREENWIDTH-60, 30, 50, 30);
            [confirm setTitle:@"确定" forState:UIControlStateNormal];
            [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:confirm];
        }
    }
}
-(void)back:(UIButton*)btn
{
    UIView*view = btn.superview.superview;
    [view removeFromSuperview];
}
-(void)confirm:(UIButton*)btn
{
    
    ReminderView*view = [ReminderView reminderViewWithTitle:@"识别中..."];
    [self.view addSubview:view];
    dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(0, 0), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }];
        MyView*myView = (MyView*)[btn.superview.superview viewWithTag:1000];
        NSLog(@"==%f",[myView jietu].size.width);
        UIImage *image;
        if ([myView jietu].size.width>40)
        {
            image = [self imageWithImage:[myView jietu] scaledToSize:CGSizeMake(200, 200)];
        }else
        {
            image = [self imageWithImage:myView.originalImage scaledToSize:CGSizeMake(200, 200)];
        }
        
        //            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData*data = UIImagePNGRepresentation(image);
        //            NSDictionary*param = @{@"img":data};
        AFHTTPRequestOperationManager*manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://hzwkw.wicp.net/UploadAndDownload"]];
        AFHTTPRequestOperation*request = [manager POST:@"action" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"" mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            NSLog(@"服务器返回的数据为：%@",dict);
            
            if ([dict objectForKey:@"imgurl"])
            {
                dispatch_group_notify(dispatch_group_create(), dispatch_get_global_queue(0, 0), ^{
                    NSURL*url = [NSURL URLWithString:[[dict objectForKey:@"imgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    AFHTTPRequestOperationManager*manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://openapi.baidu.com"]];
                    NSDictionary*param = @{@"access_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"url":url};
                    //            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
                    AFHTTPRequestOperation*request = [manager GET:@"rest/2.0/media/v1/face/detect" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSString *html = operation.responseString;
                        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                        NSLog(@"获取到的数据为：%@",dict);
                        
                        NSString*face_id;
                        NSArray*array =[dict objectForKey:@"face"];
                        if (array.count)
                        {
                            face_id= [[[dict objectForKey:@"face"] objectAtIndex:0] objectForKey:@"face_id"];
                            //                                    NSLog(@"获取到的face_id数据为：%@",face_id);
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView*alert;
                            if (face_id)
                            {
                                alert = [[UIAlertView alloc]initWithTitle:@"提示" message:face_id delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                            }else
                            {
                                alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"所选的图片不是人脸图片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                            }
                            [alert show];
                            [view removeFromSuperview];
                            
                        });
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        //            NSLog(@"==%@",operation.response);
                        //            NSLog(@"%@",error);
                        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不好意思,服务器请求出现问题了，请稍后重新请求。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                        [alert show];
                        [view removeFromSuperview];
                        
                    }];
                    [request start];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不好意思,服务器请求出现问题了，请稍后重新请求。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert show];
            [view removeFromSuperview];
            NSLog(@"dsafgfdsh==%@",error);
        }];
        [request start];
    });
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self dismissViewControllerAnimated:YES completion:^{
//        [self setupCamera];
        [self.navigationController popViewControllerAnimated:YES];
    }];//弹出相机界面
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

//alerview代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1)
    {
        [_session stopRunning];
        UIWebView*webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+[UIApplication sharedApplication].statusBarFrame.size.height, SCREENWIDTH, SCREENHEIGHT-(44+[UIApplication sharedApplication].statusBarFrame.size.height))];
        webview.delegate = self;
        webview.tag = 1000;
        webview.scalesPageToFit = YES;
        webview.scrollView.delegate = self;
        NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:webUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
        [webview loadRequest:request];
        [self.view addSubview:webview];
    }else
    {
        [_session stopRunning];
        [self.navigationController popViewControllerAnimated:YES];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIWebView*webview = (UIWebView*)[self.view viewWithTag:1000];
    NSLog(@"%f==%f==%f",webview.scrollView.contentSize.height,webview.scrollView.contentOffset.y ,SCREENHEIGHT);
    if (webview.scrollView.contentOffset.y < -64||webview.scrollView.contentOffset.y > webview.scrollView.contentSize.height-SCREENHEIGHT+64+[UIApplication sharedApplication].statusBarFrame.size.height-20)
    {
        NSLog(@"%u,%u",webview.scrollView.contentOffset.y > webview.scrollView.contentSize.height-SCREENHEIGHT+[UIApplication sharedApplication].statusBarFrame.size.height-20,webview.scrollView.contentOffset.y < -64);
        scrollView.scrollEnabled = NO;
    }else
    {
        scrollView.scrollEnabled = YES;
    }
}

//webview代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Common showMessage:@"加载失败" withView:self.view];
//    ReminderView*remiderView = [ReminderView reminderViewFrameWithTitle:@"加载失败"];
//    [self.view addSubview:remiderView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.5];//动画运行时间
//        remiderView.center = CGPointMake(SCREENWIDTH/2, 0);
//        [UIView commitAnimations];//提交动画
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [remiderView removeFromSuperview];
//        });
//    });
    ReminderView*view = [ReminderView reminderView];
    [view removeFromSuperview];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ReminderView*view = [ReminderView reminderView];
    [self.view addSubview:view];
    if (webView.canGoBack) {
        UIBarButtonItem*backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backOne)];
        backBtn.tintColor = WHITECOLOR;
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}
-(void)backOne
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    [webView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    btnMore.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    //显示标题
    if (webView!=nil)
    {
         NSString *showTitle = [webView stringByEvaluatingJavaScriptFromString:@"$('p').filter('top_title').val()"];
        if (showTitle.length == 0) {
            showTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        if ([showTitle hasPrefix:@"亿启酷动"])
        {
            self.navigationItem.title = @"亿启酷动";
        }else
        {
            self.navigationItem.title = showTitle;
        }
        

        NSRange range = [webUrl rangeOfString:@"17ll.com/apply/match-pic"];
        NSString *imgUrl;
        if (range.length > 0) {//获取参赛者图片
            imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"$(\"#giftPic\").find(\"div\").css( \"backgroundImage\")"];
            NSRange srange = [imgUrl rangeOfString:@"url"];
            if (srange.length > 0) {
                imgUrl = [imgUrl substringFromIndex:srange.location+srange.length+1];
                imgUrl = [imgUrl substringToIndex:imgUrl.length-1];
            }
        }
        else{//获取第一张图片
            imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[0].src;"];
            //            imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"$(\"img\").attr(\"src\");"];
        }
        if (imgUrl.length > 0) {
            //获取网页中第一张image
            item.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        }
    }
    else{
        //如果网页没有图片，就截图
        CGRect r = [UIScreen mainScreen].applicationFrame;
        r.origin.y = r.origin.y + 44 ;
        UIGraphicsBeginImageContext(self.view.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        UIRectClip(r);
        [self.view.layer renderInContext:context];
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        item.imgData = UIImageJPEGRepresentation(theImage,1.0);
        UIGraphicsEndImageContext();
    }
    
    //    NSLog(@"%@",item.imgData);
    if (webView!=nil)
    {
        item.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSLog(@"==%@",item.title);
        item.url = webView.request.URL.absoluteString;
    }

    
    ReminderView*view = [ReminderView reminderView];
    [view removeFromSuperview];
}
//扫描动画
-(void)animation1
{
    UIImageView*imageview = (UIImageView*)[self.view viewWithTag:1100];
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(imageview.frame.origin.x+10, imageview.frame.origin.y+10+2*num, SCREENWIDTH-120, 2);
        if (2*num == (int)((SCREENWIDTH-120)/2)*2) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(imageview.frame.origin.x+10, imageview.frame.origin.y+10+2*num, SCREENWIDTH-120, 2);
        if (num == 0)
        {
            upOrdown = NO;
        }
    }
}
//返回按钮
-(void)backAction
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    if (webView.canGoBack)
    {
        [webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupCamera];
    });
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    webView.delegate = nil;
    webView = nil;
//    [_session stopRunning];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    NSError*error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error)
    {
        NSLog(@"没摄像头%@",error);
        return;
    }
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    //     条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(50,130,SCREENWIDTH-100,SCREENWIDTH-100);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    // Start
    [_session startRunning];
    flag = 1;
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    NSLog(@"42");
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
//    [_session stopRunning];
    NSLog(@"%@",stringValue);
//    [timer invalidate];
    if (flag)
    {
        flag = 0;
        if ([stringValue hasPrefix:@"http"])
        {
            webUrl = stringValue;
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定前往%@吗？",webUrl] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
            [_session stopRunning];
            [timer invalidate];
        }else
        {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",stringValue] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [_session stopRunning];
            [timer invalidate];
        }
    }
    
}
-(void)more
{
    UIWebView*webview = (UIWebView*)[self.view viewWithTag:1000];
    //把webview中的键盘回收。
    if (webview!=nil)
    {
        [webview stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
    }
    ShareSheet*shareview = [ShareSheet shareWeiboView];
    [shareview becomeFirstResponder];
    shareview.webview = webview;
    shareview.item = item;
    shareview.imageData = item.imgData;
    [self.navigationController.view addSubview:shareview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
