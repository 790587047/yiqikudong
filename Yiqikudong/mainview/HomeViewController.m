//
//  HomeViewController.m
//  Yiqikudong
//
//  Created by wendy on 15/5/13.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchView.h"
#import "ListVoiceView.h"
#import "PersonalAnchorViewController.h"

#define lineCount 4

@interface HomeViewController ()

@end

@implementation HomeViewController{
    NSArray *imageArray;
    NSArray *titleArray;
    NSArray *picArray;//滚动图片
    NSArray *hotArray;//火热主播内容
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
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
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    imageArray = @[@"hot",@"music",@"comic",@"news",@"pulpit",@"opera",@"children",@"technology",@"health",@"school",@"english",@"movieIcon",@"finance",@"physical",@"other"];
    
    titleArray = @[@"热门",@"音乐",@"相声",@"新闻资讯",@"百家讲坛",@"戏曲",@"儿童",@"IT科技",@"健康养生",@"校园",@"外语",@"电影",@"财经",@"体育",@"其他"];

    [self initButtonList];
    
    _conView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstView.frame) + 10, SCREENWIDTH, 0)];
    [_scrollView addSubview:_conView];
    
    picArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    
    [self pictureScroll];
    [self InitHot];
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetHeight(_firstView.frame)+CGRectGetHeight(_conView.frame)+50);
}

#pragma mark -- uibutton处理
/**
 *  初始化按钮
 */
-(void) initButtonList{
    CGFloat y = 10;
    CGFloat width = SCREENWIDTH/4;
    CGFloat height = width;
    CGFloat x ;
    
    _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 110)];
    _firstView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:1.0];
    [_scrollView addSubview:_firstView];
    
    for (int i = 0; i < 8; i ++) {
        if (i > 0 && i % lineCount == 0) {
            int t = i % lineCount;
            y = y + height + 5;
            x = t * width + 15;
        }
        else{
            int t = i;
            if (i >= lineCount) {
                t = t % lineCount;
            }
            x = t * width + 15;
        }
        UIButton *btn = [self createButton];

        [btn setFrame:CGRectMake(x, y, 60, 85)];
        btn.tag = 10000 + i;
    
        UIImage *image;
        if (i == 7) {
            image = [UIImage redraw:[UIImage imageNamed:@"open"] Frame:CGRectMake(0, 0, 55, 55)];
            [btn setTitle:@"更多" forState:UIControlStateNormal];
        }
        else{
            image = [UIImage redraw:[UIImage imageNamed:imageArray[i]] Frame:CGRectMake(0, 0, 55, 55)];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(dealButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage: image forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 30, -image.size.width,0.0, 0.0)];
        
        if (i > 0 && i % lineCount == 0) {
            [_firstView setFrame:CGRectMake(_firstView.frame.origin.x, _firstView.frame.origin.y, SCREENWIDTH, _firstView.frame.size.height + y)];
        }
    }
}

-(UIButton *) createButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10,0,10, 0)];
    [btn.imageView setContentMode:UIViewContentModeCenter];
    btn.imageView.layer.cornerRadius = 26.f;
    [btn.imageView setBackgroundColor:WHITECOLOR];
    btn.imageView.layer.masksToBounds = YES;
    
    [btn.titleLabel setContentMode:UIViewContentModeCenter];
    [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_firstView addSubview:btn];
    return btn;
}

-(void) dealButtonClick:(UIButton *) sender{
//    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"更多"]) {
        [self getMore:sender];
    }
    else if([sender.titleLabel.text isEqualToString:@"收起"]){
        [self hideMoreView:sender];
    }
    else{
        [self gotoListView:sender];
    }
}

/**
 *  展开更多
 *
 *  @param sender
 */
-(void) getMore:(UIButton *) sender{
//    NSLog(@"最后一个button = %ld",(long)sender.tag);
    
    [sender setImage:[UIImage redraw:[UIImage imageNamed:imageArray[7]] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
    [sender setTitle:titleArray[7] forState:UIControlStateNormal];

    if (_moreView == nil) {
        
        CGFloat y = 0;
        CGFloat width = SCREENWIDTH/4;
        CGFloat height = width;
        CGFloat x ;
        
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sender.frame)+20, SCREENWIDTH, height)];
        _moreView.hidden = NO;
        [_firstView addSubview:_moreView];
        
        for (int i = 0; i < imageArray.count - 8 + 1; i++) {
            
            if (i > 0 && i % lineCount == 0) {
                int t = i % lineCount;
                y = y + height + 5;
                x = t * width + 15;
            }
            else{
                int t = i;
                if (i >= lineCount) {
                    t = t % lineCount;
                }
                x = t * width + 15;
            }
            UIButton *btn = [self createButton];
            [btn setFrame:CGRectMake(x, y, 60, 85)];
            btn.tag = 10000 + i + 8;
            
            UIImage *image;
            if (i == 7) {
                image = [UIImage redraw:[UIImage imageNamed:@"packup"] Frame:CGRectMake(0, 0, 55, 55)];
                [btn setTitle:@"收起" forState:UIControlStateNormal];
            }
            else{
                image = [UIImage redraw:[UIImage imageNamed:imageArray[i+8]] Frame:CGRectMake(0, 0, 55, 55)];
                [btn setTitle:titleArray[i+8] forState:UIControlStateNormal];
                
            }
            [btn addTarget:self action:@selector(dealButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage: image forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 30, -image.size.width,0.0, 0.0)];
            
            if (i > 0 && i % lineCount == 0) {
                [_moreView setFrame:CGRectMake(_moreView.frame.origin.x, _moreView.frame.origin.y, CGRectGetWidth(self.view.frame), _moreView.frame.size.height + height+15)];
            }
            [_moreView addSubview:btn];
        }
    }else{
        if (_moreView.hidden) {
            _moreView.hidden = NO;
        }
    }
    [_firstView setFrame:CGRectMake(_firstView.frame.origin.x, _firstView.frame.origin.y, SCREENWIDTH, _firstView.frame.size.height + CGRectGetHeight(_moreView.frame))];
    [_conView setFrame:CGRectMake(0, CGRectGetMaxY(_firstView.frame) + 10, SCREENWIDTH, _conView.frame.size.height)];
     _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetHeight(_firstView.frame)+CGRectGetHeight(_conView.frame)+50);
}

/**
 *  收起按钮事件
 *
 *  @param sender
 */
-(void) hideMoreView:(UIButton *) sender{
    if (!_moreView.hidden) {
        _moreView.hidden = YES;
    }
    UIButton *btn = (UIButton *) [self.view viewWithTag:10007];
    [btn setImage:[UIImage redraw:[UIImage imageNamed:@"open"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    
     [_firstView setFrame:CGRectMake(_firstView.frame.origin.x, _firstView.frame.origin.y, SCREENWIDTH, _firstView.frame.size.height - CGRectGetHeight(_moreView.frame))];
    [_conView setFrame:CGRectMake(0, CGRectGetMaxY(_firstView.frame) + 10, SCREENWIDTH, _conView.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetHeight(_firstView.frame)+CGRectGetHeight(_conView.frame)+50);
}

/**
 *  进入搜索页
 */
-(void)searchAction{
    self.navigationController.navigationBarHidden = YES;
    SearchView *searchView = [[SearchView alloc]init];
    [self.navigationController pushViewController:searchView animated:YES];
}

/**
 *  进入列表页
 *
 */
-(void)gotoListView:(UIButton*)sender{
    UIButton *btnTitle = (UIButton *) [_scrollView viewWithTag:sender.tag + 10000];
    ListVoiceView*listView = [[ListVoiceView alloc]init];
    listView.kind = btnTitle.titleLabel.text;
    [self.navigationController pushViewController:listView animated:YES];
}

#pragma mark -- 图片滚动
-(void) pictureScroll{
    _picView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 180)];
    [_conView addSubview:_picView];

    _picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _picView.frame.size.height)];
    [_picScrollView setContentSize:CGSizeMake(SCREENWIDTH * picArray.count, _picScrollView.frame.size.height)];
    _picScrollView.delegate = self;
    _picScrollView.scrollsToTop = NO;
    _picScrollView.pagingEnabled = YES;
    _picScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    _picScrollView.showsHorizontalScrollIndicator = NO;
    _picScrollView.showsVerticalScrollIndicator = NO;
    [_picView addSubview:_picScrollView];
    
    for (int i = 0; i < picArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, _picView.frame.size.height)];
        imageView.image = [UIImage imageNamed:picArray[i]];
        [_picScrollView addSubview:imageView];
        imageView.tag = i + 2000;
        [self clickImageView:imageView];
    }
    
    _picPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 20, CGRectGetMaxY(_picView.frame) - 20, 40, 18)];
    _picPageControl.numberOfPages = picArray.count;
    _picPageControl.currentPage = 0;
    _picPageControl.currentPageIndicatorTintColor = WHITECOLOR;
    _picPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_picView addSubview:_picPageControl];
    
    [self addTimer];
}

-(void) clickImageView:(UIImageView *) imageView{
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToView:)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:singleTap];
    UIView *singleTapView = [singleTap view];
    singleTapView.tag = imageView.tag;
}

-(void) goToView:(UITapGestureRecognizer *) tap{
    NSLog(@"you click button %ld",(long)tap.view.tag);
}


/**
 *  开启定时器
 */
-(void) addTimer{
    self.picTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.picTimer forMode:NSRunLoopCommonModes];
}

/**
 *  关闭定时器
 */
-(void) removeTimer{
    [self.picTimer invalidate];
}

/**
 *  下一张图片
 */
-(void) nextImage{
    int page = (int)[_picPageControl currentPage];
    if (page == picArray.count-1) {
        page = 0;
    }
    else
        page ++;
    //  滚动scrollview
    CGFloat x = page * _picScrollView.frame.size.width;
    _picScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma mark-- UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _picPageControl.currentPage = scrollView.contentOffset.x / SCREENWIDTH;
}

/**
 *  滚动时调用
 *
 *  @param scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = _picScrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW / 2) / scrollViewW;
    _picPageControl.currentPage = page;
}

/**
 *  开始拖拽的时候调用
 *
 *  @param scrollView
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

#pragma mark -- 火热主播和今日焦点
-(void) InitHot{
    
    /*火热主播*/
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_picView.frame) + 10, SCREENWIDTH, 180)];
    [hotView setBackgroundColor:WHITECOLOR];
    [_conView addSubview:hotView];
    
    NSString *title = @"火热主播";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
    CGSize lblHotSize = [title boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    UILabel *lblHot = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, lblHotSize.width, lblHotSize.height)];
    [lblHot setText:title];
    lblHot.center = CGPointMake(self.view.center.x, lblHot.center.y);
    [lblHot setTextColor:[UIColor blackColor]];
    [lblHot setFont:[UIFont systemFontOfSize:18.f]];
    [hotView addSubview:lblHot];
    
    UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblHot.frame) - 20, lblHot.frame.origin.y, 20, 20)];
    imgLeft.center = CGPointMake(imgLeft.center.x, lblHot.center.y);
    [imgLeft setImage:[UIImage imageNamed:@"hot_home"]];
    [hotView addSubview:imgLeft];
    
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMore setFrame:CGRectMake(CGRectGetMaxX(lblHot.frame)+2, imgLeft.frame.origin.y, 20, 20)];
    [btnMore setImage:[UIImage imageNamed:@"more_home"] forState:UIControlStateNormal];
//    [btnMore addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
    [hotView addSubview:btnMore];
    
    for (int i = 0; i < 3; i ++) {
        
        UIButton *btnHot = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnHot setFrame:CGRectMake(10+SCREENWIDTH / 3 * i, CGRectGetMaxY(lblHot.frame) + 10, SCREENWIDTH / 3 - 20, SCREENWIDTH / 3)];
        
        [btnHot setImageEdgeInsets:UIEdgeInsetsMake(0,0,20, 0)];
        [btnHot.imageView setContentMode:UIViewContentModeCenter];
        [btnHot setImage:[UIImage imageNamed:@"hot1"] forState:UIControlStateNormal];
        [btnHot.titleLabel setContentMode:UIViewContentModeCenter];
        [btnHot.titleLabel setBackgroundColor:[UIColor clearColor]];
        [btnHot.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [btnHot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHot.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btnHot setTitle:@"热门相声" forState:UIControlStateNormal];
        [btnHot setTitleEdgeInsets:UIEdgeInsetsMake(btnHot.imageView.image.size.height - 45, -btnHot.imageView.image.size.width,0.0, 0.0)];
        
        btnHot.tag = 3000+i;
//        btnHot.tag = 3000 + USERID;
        [btnHot addTarget:self action:@selector(goToPersonalView:) forControlEvents:UIControlEventTouchUpInside];
        [hotView addSubview:btnHot];
    }
    
    /*今日焦点*/
    UIView *todayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotView.frame) + 10, SCREENWIDTH, 290)];
    [todayView setBackgroundColor:WHITECOLOR];
    [_conView addSubview:todayView];
    
    UILabel *lblToday = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, lblHotSize.width, lblHotSize.height)];
    [lblToday setText:@"今日焦点"];
    lblToday.center = CGPointMake(self.view.center.x, lblToday.center.y);
    [lblToday setTextColor:[UIColor blackColor]];
    [lblToday setFont:[UIFont systemFontOfSize:18.f]];
    [todayView addSubview:lblToday];
    
    UIImageView *imgTodayLeft = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblToday.frame) - 20, lblToday.frame.origin.y, 20, 20)];
    imgTodayLeft.center = CGPointMake(imgTodayLeft.center.x, lblToday.center.y);
    [imgTodayLeft setImage:[UIImage imageNamed:@"hot_home"]];
    [todayView addSubview:imgTodayLeft];
    
    UIButton *btnTodayMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTodayMore setFrame:CGRectMake(CGRectGetMaxX(lblToday.frame)+2, imgTodayLeft.frame.origin.y, 20, 20)];
    [btnTodayMore setImage:[UIImage imageNamed:@"more_home"] forState:UIControlStateNormal];
    //    [btnTodayMore addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
    [todayView addSubview:btnTodayMore];

    UIButton *btnToday = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToday setFrame:CGRectMake(10, CGRectGetMaxY(lblToday.frame) + 10, SCREENWIDTH - 20, 150)];
    [btnToday setImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
//    [btnToday addTarget:self action:@selector(getToday:) forControlEvents:UIControlEventTouchUpInside];
    [todayView addSubview:btnToday];
    
    int h = 0;
    for (int i = 0; i < 2; i ++) {
        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(btnToday.frame.origin.x, CGRectGetMaxY(btnToday.frame)+(h * i), btnToday.frame.size.width, 50)];
        [fView setBackgroundColor:[UIColor clearColor]];
        [todayView addSubview:fView];
        h = CGRectGetHeight(fView.frame)+1;
        
        UILabel *lblCellInfo = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREENWIDTH * 0.65, 30)];
        [lblCellInfo setTextColor:[UIColor blackColor]];
        [lblCellInfo setFont:[UIFont systemFontOfSize:14.f]];
        lblCellInfo.center = CGPointMake(lblCellInfo.center.x, CGRectGetMidY(fView.frame) - CGRectGetMinY(fView.frame));
        lblCellInfo.text = @"重返20岁 10本书带你回忆青春";
        [fView addSubview:lblCellInfo];
        
        UIImageView *imgCell = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(fView.frame) - 45, 5, 40, 40)];
        imgCell.center = CGPointMake(imgCell.center.x, lblCellInfo.center.y);
        [imgCell setImage:[UIImage imageNamed:@"6_69"]];
        [fView addSubview:imgCell];
        
        if (i == 0) {
            UILabel *lblSeparate = [[UILabel alloc] initWithFrame:CGRectMake(fView.frame.origin.x, CGRectGetMaxY(fView.frame), fView.frame.size.width, 1)];
            [lblSeparate setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
            [todayView addSubview:lblSeparate];
        }
        fView.tag = 4000+i;
        [self clickViewCell:fView];
    }
    [_conView setFrame:CGRectMake(0, _conView.frame.origin.y, SCREENWIDTH, CGRectGetHeight(_picView.frame)+CGRectGetHeight(hotView.frame) + CGRectGetHeight(todayView.frame))];
}

-(void) clickViewCell:(UIView *) view{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToView:)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:singleTap];
    UIView *singleTapView = [singleTap view];
    singleTapView.tag = view.tag;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.tag = 1001;
    myBtn.frame = CGRectMake(0, 0, 40, 40);
    [myBtn setImage:[UIImage imageNamed:@"usertitle"] forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(goToMyView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:myBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

/**
 *  进入个人中心
 *
 *  @param btn
 */
-(void)goToMyView:(UIButton*) btn{
    [self presentLeftMenuViewController:nil];
}

/**
 *  进入个人播放主页
 *
 *  @param sender
 */
-(void) goToPersonalView:(UIButton *) sender{
    NSString *userId = [NSString stringWithFormat:@"%ld",sender.tag - 3000];
    PersonalAnchorViewController *viewController = [[PersonalAnchorViewController alloc] init];
    self.navigationController.navigationBarHidden = YES;
    viewController.userId = userId;
    [self.navigationController pushViewController:viewController animated:YES];

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
