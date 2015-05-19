//
//  UserCenterView.m
//  Yiqikudong
//
//  Created by BK on 15/3/11.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "UserCenterView.h"
#import "AppDelegate.h"
#import "FollowListViewController.h"

@interface UserCenterView ()

@end

@implementation UserCenterView
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.presentAnimation = [[PresentAnimation alloc]init];
        self.dismissAnimation = [[DismissAnimation alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageArray =[NSArray arrayWithObjects:@"usercollection",@"userplayhistory",@"userusestep",@"useraboutus", nil];
    titleArray = [NSArray arrayWithObjects:@"查看收藏",@"播放历史",@"使用步骤",@"关于我们",nil];
    
    UITableView*userCenterTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    userCenterTable.delegate = self;
    userCenterTable.dataSource = self;
    userCenterTable.backgroundColor = [UIColor blackColor];
    userCenterTable.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200+TbarHeight-44)];
        UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TbarHeight-44, SCREENWIDTH, 200)];
        image.image = [UIImage imageNamed:@"userCenterBackground"];
        [view addSubview:image];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView*userImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, 70, 70)];
        userImage.image = [UIImage imageNamed:@"usertitle"];
        userImage.layer.cornerRadius = 35;
        [view addSubview:userImage];
        
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(100, userImage.center.y-20, 150, 40)];
        title.text = @"登录";
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        [view addSubview:title];
        
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40, 140, 190, 45);
        [btn setImage:[UIImage imageNamed:@"userrecordbtn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotorecord) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        view;
    });
    userCenterTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view addSubview:userCenterTable];
}
-(void)gotorecord
{
    RecordingView*recordingview = [[RecordingView alloc]init];
    [self presentViewController:recordingview animated:YES completion:^{
        
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markCell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
        }
        [cell setBackgroundColor:[UIColor blackColor]];
        
        UIColor *buttonColor = [UIColor colorWithRed:255/255.0 green:73/255.0 blue:0/255.0 alpha:1.0];
        UIButton *btnFollow = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFollow setFrame:CGRectMake(35, 5, 80, 35)];
        [btnFollow setTitle:@"关注" forState:UIControlStateNormal];
        [btnFollow setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [btnFollow.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [btnFollow setBackgroundColor:buttonColor];
        btnFollow.tag = 10001;
        [cell.contentView addSubview:btnFollow];
        
        UIButton *btnFollower = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFollower setFrame:CGRectMake(CGRectGetMaxX(btnFollow.frame)+10, btnFollow.frame.origin.y, 80, 35)];
        [btnFollower setTitle:@"粉丝" forState:UIControlStateNormal];
        [btnFollower setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [btnFollower.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [btnFollower setBackgroundColor:buttonColor];
        btnFollower.tag = 10002;
        [cell.contentView addSubview:btnFollower];
        
        [btnFollow addTarget:self action:@selector(goToFollowView:) forControlEvents:UIControlEventTouchUpInside];
        [btnFollower addTarget:self action:@selector(goToFollowView:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        UserCenterCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell==nil)
        {
            cell = [[UserCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        cell.titleLabel.text = titleArray[indexPath.row - 1];
        cell.titleLabel.textColor = WHITECOLOR;
        cell.imageview.image = [UIImage imageNamed:imageArray[indexPath.row - 1]];
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count+1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    UserCenterCell*cell = (UserCenterCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    if (indexPath.row==1)
    {
        VoiceCollectionView*voiceCollection = [[VoiceCollectionView alloc]init];
        voiceCollection.transitioningDelegate=self;
        [self presentViewController:voiceCollection animated:YES completion:^{
            
        }];
    }else if (indexPath.row==2)
    {
        VoiceHistoryView*voiceHistory = [[VoiceHistoryView alloc]init];
        voiceHistory.transitioningDelegate=self;
        [self presentViewController:voiceHistory animated:YES completion:^{

        }];
    }else if (indexPath.row==3)
    {
        UseStepsView*useStepsView = [[UseStepsView alloc]init];
        useStepsView.transitioningDelegate=self;
        [self presentViewController:useStepsView animated:YES completion:^{

        }];
    }else if (indexPath.row==4)
    {
        AboutUsView*aboutUsView = [[AboutUsView alloc]init];
        aboutUsView.transitioningDelegate=self;
        [self presentViewController:aboutUsView animated:YES completion:^{

        }];
    }
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return self.presentAnimation;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关注列表和粉丝列表
-(void)goToFollowView:(UIButton *) sender{
    FollowListViewController *viewController = [[FollowListViewController alloc] init];
    if (sender.tag == 10001) {//关注页面
        viewController.type = @"Follow";
    }
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:viewController animated:YES];
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
