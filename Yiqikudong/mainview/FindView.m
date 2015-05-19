//
//  FindView.m
//  亿启FM
//
//  Created by BK on 15/3/3.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "FindView.h"
#import "PersonalAnchorViewController.h"

@interface FindView ()

@end

@implementation FindView{
    NSMutableArray *arrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recordbackground.jpg"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    });
    self.title = @"频道";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                   nil];
    
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    btnSearch.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnSearch;

    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    scrollview.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    scrollview.userInteractionEnabled = YES;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    
    NSArray*imageArray = [[NSArray alloc]initWithObjects:@"hot",@"music",@"comic",@"news",@"pulpit",@"opera",@"children",@"technology",@"health",@"school",@"english",@"movieIcon",@"finance",@"physical",@"other",nil];
    
    NSArray*titleArray = [[NSArray alloc]initWithObjects:@"热门",@"音乐",@"相声",@"新闻资讯",@"百家讲坛",@"戏曲",@"儿童",@"IT科技",@"健康养生",@"校园",@"外语",@"电影",@"财经",@"体育",@"其他",nil];
    
    for (int i = 0; i<imageArray.count; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+((SCREENWIDTH-100)/5+20)*(i%5), 10+i/5*((SCREENWIDTH-100)/5+35), (SCREENWIDTH-100)/5, (SCREENWIDTH-100)/5);
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        btn.tag = 1100+i;
        [btn setBackgroundColor:WHITECOLOR];
        btn.layer.cornerRadius = (SCREENWIDTH-100)/10;
//        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.adjustsImageWhenHighlighted = YES;
        btn.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        [btn addTarget:self action:@selector(gotoListView:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH/5)*(i%5), (SCREENWIDTH-100)/5+10+i/5* ((SCREENWIDTH-100)/5+35), SCREENWIDTH/5, 25)];
        titleLabel.text = titleArray[i];
        titleLabel.tag = 1200+i;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [scrollview addSubview:titleLabel];
    }
    
    UIView*baseView = [[UIView alloc]initWithFrame:CGRectMake(0, ((SCREENWIDTH-100)/5+35)*3+0, SCREENWIDTH, 380)];
    baseView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    baseView.userInteractionEnabled = YES;
    baseView.tag = 1000;
    [scrollview addSubview:baseView];
    
    arrays = [[NSMutableArray alloc] init];
    
    NSString *path = [NSString stringWithFormat:@"%@yiqiVideoInterface.asp",VOICEHEADPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"recomm" forKey:@"sign"];
    [params setValue:@1 forKey:@"pnum"];
    [params setValue:@3 forKey:@"pagcnt"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"message = %@",operation.responseString);
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
        if ([result isEqual: @"1"]) {
            NSArray *arrs = [dictionary objectForKey:@"info"];
            for (NSDictionary *eachDict in arrs) {
                VoiceObject *obj = [[VoiceObject alloc] init];
                obj.voiceId      = [eachDict objectForKey:@"id"];
                obj.voiceClassId = [[eachDict objectForKey:@"tid"] integerValue];
                obj.voiceName    = [eachDict objectForKey:@"title"];
                obj.voiceUrl     = [eachDict objectForKey:@"url"];
                obj.picPath      = [eachDict objectForKey:@"picurl"];
                obj.voiceType    = [[eachDict objectForKey:@"flg"] integerValue];
                obj.playSumCount = [eachDict objectForKey:@"playsu"];
                obj.voiceAuthor  = [eachDict objectForKey:@"sname"];
                [arrays addObject:obj];
            }
            if (arrays.count > 0) {
                for (int i = 0; i < arrays.count-1; i++) {
                    
                    if (i == 0) {
                        VoiceObject *obj = [arrays objectAtIndex:i];
                        UIImageView*hotImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 200)];
                        hotImage1.layer.borderWidth = 1;
                        hotImage1.layer.borderColor = [UIColor colorWithRed:225/255.0 green:226/255.0 blue:218/255.0 alpha:1].CGColor;
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.picPath]];
                        obj.voicePic = imageData;
                        [hotImage1 setImage:[UIImage imageWithData:imageData]];
                        hotImage1.tag = 2000 + i;
                        [baseView addSubview:hotImage1];
                        [self clickImageView:hotImage1];
                    }
                    else{
                        for (int j = 0; j<2; j++)
                        {
                            VoiceObject *obj = [arrays objectAtIndex:i+j];
                            UIImageView*hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+(SCREENWIDTH/2-5)*j, 220, SCREENWIDTH/2-15, 150)];
                            hotImage.layer.borderWidth = 1;
                            hotImage.layer.borderColor = [UIColor colorWithRed:225/255.0 green:226/255.0 blue:218/255.0 alpha:1].CGColor;
                            if (i == 1) {
                                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.picPath]];
                                [hotImage setImage:[UIImage imageWithData:imageData]];
                                obj.voicePic = imageData;
                                hotImage.tag = 2000 + i+j;
                            }
                            else{
                                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.picPath]];
                                [hotImage setImage:[UIImage imageWithData:imageData]];
                                obj.voicePic = imageData;
                                hotImage.tag = 2000 + i+j;
                            }
                            [baseView addSubview:hotImage];
                            [self clickImageView:hotImage];
                        }
                    }
                }
            }
            scrollview.contentSize = CGSizeMake(SCREENWIDTH, baseView.frame.size.height+baseView.frame.origin.y);
        }
        else{
            [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail = %@",error);
        NSLog(@"failure = %@",operation);
        [Common showMessage:@"加载数据失败，请稍候再试" withView:self.view];
    }];
}

-(void) clickImageView:(UIImageView *) imageView{
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPlayView:)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:singleTap];
    UIView *singleTapView = [singleTap view];
    singleTapView.tag = imageView.tag;
}

//跳到播放页
-(void) goToPlayView:(UITapGestureRecognizer *) sender{
    NSInteger index = [sender view].tag - 2000;
    VoiceObject *obj = [arrays objectAtIndex:index];
    PlayVoiceViewController *viewController = [[PlayVoiceViewController alloc] init];
    viewController.model = obj;
//    NSLog(@"%@",obj.voiceName);
    [self presentViewController:viewController animated:YES completion:nil];
}


//进入搜索页
-(void)searchAction
{
    self.navigationController.navigationBarHidden = YES;
    SearchView*searchView =[[SearchView alloc]init];
    [self.navigationController pushViewController:searchView animated:YES];
}
//进入列表页
-(void)gotoListView:(UIButton*)btn
{
    UILabel*label = (UILabel*)[scrollview viewWithTag:btn.tag+100];
    ListVoiceView*listView = [[ListVoiceView alloc]init];
    listView.kind = label.text;
    [self.navigationController pushViewController:listView animated:YES];
//    PersonalAnchorViewController *viewController = [[PersonalAnchorViewController alloc] init];
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIButton*myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.tag = 1001;
    myBtn.frame = CGRectMake(0, 0, 40, 40);
    [myBtn setImage:[UIImage imageNamed:@"usertitle"] forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(goToMyView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:myBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//进入个人中心
-(void)goToMyView:(UIButton*)btn
{
    [self presentLeftMenuViewController:nil];
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
