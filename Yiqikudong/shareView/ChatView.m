//
//  ChatView.m
//  Yiqikudong
//
//  Created by BK on 15/3/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "ChatView.h"
#import "AppDelegate.h"

@interface ChatView ()

@end

@implementation ChatView
@synthesize chatTable;
+(ChatView *)chatView
{
    static ChatView*chatView = nil;
    if (chatView==nil)
    {
        chatView = [[ChatView alloc]init];
        
    }
    return chatView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    chatTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT-40)];
    chatTable.delegate = self;
    chatTable.dataSource = self;
    chatTable.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    chatTable.backgroundColor = [UIColor clearColor];
//    [chatTable setEditing:YES animated:YES];
    [self.view addSubview:chatTable];
    
    onlineUsers = [[NSMutableArray alloc]init];
    groudArray = [[NSMutableArray alloc]init];
    stateArray = [[NSMutableArray alloc]init];
    onlineUsers = [[ChatDealClass dealDataClass]getListMan];
    
    
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    self.title = @"C聊";
    
    for (int i = 0; i<3; i++)
    {
        UIButton*btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*SCREENWIDTH/3, TbarHeight, SCREENWIDTH/3, 40);
        if (i==0)
        {
            [btn setTitle:@"最近联系人" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            lastBtn = btn;
            UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/3-1,8 , 1, 24)];
            line.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            [btn addSubview:line];
        }else if (i==1)
        {
            [btn setTitle:@"我的好友" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1] forState:UIControlStateNormal];
            UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/3-1,8 , 1, 24)];
            line.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            [btn addSubview:line];
        }else if (i==2)
        {
            [btn setTitle:@"我的群" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1] forState:UIControlStateNormal];
        }
        btn.tag = 100+i;
        [btn setBackgroundColor:WHITECOLOR];
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self.view insertSubview:btn aboveSubview:chatTable];
    }
    
    redLine = [[UILabel alloc]initWithFrame:CGRectMake(0, TbarHeight+39, SCREENWIDTH/3, 2)];
    redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:redLine];
    
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
//    UIBarButtonItem *btnsure = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
//    btnsure.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = btnsure;
}
-(void)selectBtn:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"我的群"])
    {
        [chatTable setHidden:YES];
        if (groudListTable==nil)
        {
            GroudObject*groudObject = [[GroudObject alloc]init];
            groudObject.groudName = @"测试";
            groudObject.content = @"ceshi";
            [groudArray addObject:groudObject];
            
            [self initGroupList];
        }else
        {
            [groudListTable setHidden:NO];
        }
        
    }else if([btn.titleLabel.text isEqualToString:@"最近联系人"])
    {
        
        [chatTable setHidden:NO];
        [groudListTable setHidden:YES];
    }else if([btn.titleLabel.text isEqualToString:@"我的好友"])
    {
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [redLine setFrame:CGRectMake(btn.frame.origin.x, TbarHeight+39, SCREENWIDTH/3, 2)];
    [UIView commitAnimations];
    [lastBtn setTitleColor:[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    lastBtn = btn;
}
-(void)initGroupList
{
    groudListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, TbarHeight+40, SCREENWIDTH, SCREENHEIGHT-40)];
    groudListTable.delegate = self;
    groudListTable.dataSource = self;
    groudListTable.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    groudListTable.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        [view addSubview:line];
        textfield = [[UITextField alloc]initWithFrame:CGRectMake(12, 7, SCREENWIDTH-24, 36)];
        textfield.delegate = self;
        textfield.layer.cornerRadius = 3;
        textfield.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
        textfield.layer.borderWidth = 1;
        textfield.backgroundColor = WHITECOLOR;
        [view addSubview:textfield];
        
        UIView*view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 36)];
        view1.backgroundColor = WHITECOLOR;
        textfield.leftView = view1;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        
        UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 36)];
        view2.backgroundColor = [UIColor clearColor];
        view2.userInteractionEnabled = YES;
        UIButton*searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(0, 7, 22, 22);
        [searchBtn setImage:[UIImage imageNamed:@"ql_pic11"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:searchBtn];
        
        textfield.rightView = view2;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        view;
    });
    [self.view addSubview:groudListTable];
    [self.view insertSubview:redLine aboveSubview:groudListTable];
}
-(void)searchAction
{
//    NSLog(@"搜索===%@",textfield.text);
}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self searchAction];
//    return YES;
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [stateArray removeAllObjects];
    [talkTimer invalidate];
    [textTimer invalidate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        talkTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(talkTimer) userInfo:nil repeats:YES];
        [talkTimer fire];
        [[NSRunLoop currentRunLoop]run];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        textTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(textTimer) userInfo:nil repeats:YES];
        [textTimer fire];
        [[NSRunLoop currentRunLoop]run];
    });
    
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    [overlay hide];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"是" forKey:@"聊天列表界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"群聊界面"]isEqualToString:@"否"])
    {
        UIButton*btn = (UIButton*)[self.view viewWithTag:100];
        [self selectBtn:btn];
    }
}
-(void)textTimer
{
    if (![textfield.text isEqualToString:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self searchAction];
        });
    }
}
-(void)talkTimer
{
    [stateArray removeAllObjects];
    NSString *userID = @"10";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL*url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@chat/APP_PrivateChat_FriendList.asp",chatUrlPrefix]];
//                NSURL*url = [[NSURL alloc]initWithString:@"http://hzwkwang.vicp.cc:27117/weka/PostS.servlet"];
        //创建可变链接请求http://hzwkwang.vicp.cc:27117/weka/PostS.servlet?userAddress=12312&userSpeed=31232&userAcc=sdfsd&userState=3453432
        NSMutableURLRequest*request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        //设置http请求方式
        [request setHTTPMethod:@"POST"];
        NSString*bodyStr = [NSString stringWithFormat:@"SendID=%@&PageSize=20&PageIndex=1",userID];
//                NSString*bodyStr = [NSString stringWithFormat:@"userAddress=d你打死佛山打工&userSpeed=31232&userAcc=sdfsd&userState=3453432"];
        NSLog(@"%@",[bodyStr dataUsingEncoding:NSUTF8StringEncoding]);
        [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        //response响应信息
        NSHTTPURLResponse*response = nil;
        //错误信息
        NSError*error = nil;
        //开始post同步请求
        NSData*data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //        NSLog(@"response = %@,error = %@",[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]],error);
        NSString*strResult1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"strResult = %@",[strResult1 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]);
        NSString*zyStr = [strResult1 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
//        NSLog(@"%@",zyStr);
        NSMutableDictionary*dictResult = [[zyStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] objectFromJSONString];
//        NSLog(@"%@",dictResult);
        NSMutableArray*arrayResult1 = [dictResult objectForKey:@"PrivateChatsFriends"];
//        NSMutableDictionary*dictResult1 = [arrayResult1 lastObject];
        NSMutableDictionary*returnDict;
        NSMutableArray*arrayResult2 = [[NSMutableArray alloc]init];
        for (NSMutableDictionary*dictResult1 in arrayResult1)
        {
            NSMutableString*jsonResult = [dictResult1 objectForKey:@"message"];
            NSMutableDictionary*returnDict1 = [NSMutableDictionary dictionaryWithDictionary:dictResult1];
            [returnDict1 setObject:[[jsonResult stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] forKey:@"message"];
            [arrayResult2 addObject:returnDict1];
        }
        returnDict = [NSMutableDictionary dictionaryWithDictionary:dictResult];
        [returnDict setObject:arrayResult2 forKey:@"PrivateChatsFriends"];
        NSArray*array = [returnDict objectForKey:@"PrivateChatsFriends"];
        NSMutableArray*userArray = [[NSMutableArray alloc]init];
        for (NSDictionary*dictionary in array)
        {
//            if ([[dictionary objectForKey:@"is_group"] isEqualToString:@"False"])
//            {
                UserObject*info = [[UserObject alloc]init];
                info.myID = userID;
                info.chatUserID = [dictionary objectForKey:@"sender_id"];
                info.maxID = [dictionary objectForKey:@"max_id"];
                info.time = [dictionary objectForKey:@"send_time"];
                info.chatPicUrl = [dictionary objectForKey:@"userpic"];
                info.chatUserName = [dictionary objectForKey:@"sname"];
                info.content = [dictionary objectForKey:@"message"];
                info.zt = [dictionary objectForKey:@"readed"];
                info.msgID = [dictionary objectForKey:@"id"];
                info.chatType = [dictionary objectForKey:@"is_group"];
//                NSLog(@"%@",[dictionary objectForKey:@"is_group"]);
                NSString*str = [dictionary objectForKey:@"readed"];
                //                NSLog(@"%@",str);
                if ([str isEqualToString:@"0"]) {
                    [stateArray addObject:info];
                    [[ChatDealClass dealDataClass] changeManTime:info.time chatUserID:info.chatUserID];
                }
                [userArray addObject:info];
//            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ChatDealClass dealDataClass]saveLinkMan:userArray];
            onlineUsers = [[ChatDealClass dealDataClass]getListMan];
//            groudArray = [[ChatDealClass dealDataClass]getGroud];
//            if (groudListTable !=nil)
//            {
//                [groudListTable reloadData];
//            }
            //            onlineUsers =userArray;
            [chatTable reloadData];
        });
    });
}
-(void)back
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"show" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天列表界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//-(void)login
//{
//    ChatLoginView*loginView = [[ChatLoginView alloc]init];
//    [self.navigationController pushViewController:loginView animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:chatTable])
    {
        return [onlineUsers count];
    }else if ([tableView isEqual:groudListTable])
    {
        return [groudArray count];
//        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:chatTable])
    {
        static NSString *identifier = @"userCell";
        UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UserListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        UserObject*info = [onlineUsers objectAtIndex:indexPath.row];
        //文本
        cell.chatTitle.text = info.chatUserName;
        
        cell.timeCreateLabel.text = info.time;
        NSString *message = info.chatPicUrl;
        if ([message hasSuffix:@"png"]||[message hasSuffix:@"jpg"]||[message hasSuffix:@"gif"]||[message hasSuffix:@"jpeg"]) {
            NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",chatUrlPrefix,message]]];
            cell.imageview.image = [UIImage imageWithData:data];
            [[ChatDealClass dealDataClass]changePic:data chatID:info.chatID];
        }else
        {
            cell.imageview.image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:message]];
        }
        cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//        cell.backgroundColor = [UIColor clearColor];
        if (onlineUsers.count>0)
        {
            if (stateArray.count>0)
            {
                //            UserObject*info1 = [stateArray objectAtIndex:(stateArray.count - indexPath.row-1)];
                for (UserObject*info1 in stateArray)
                {
                    //                NSLog(@"%@==%@",info1.chatUserID ,info.chatUserID );
                    if ([info1.chatUserID isEqualToString:info.chatUserID])
                    {
                        if ([info1.zt isEqualToString:@"0"])
                        {
                            [cell.stateView setHidden:NO];
                            cell.description.textColor = [UIColor redColor];
                            cell.description.text = info1.content;
                            break;
                        }
                    }else
                    {
                        [cell.stateView setHidden:YES];
                        cell.description.textColor = [UIColor grayColor];
                        cell.description.text = info.content;
                    }
                }
                
            }else
            {
                [cell.stateView setHidden:YES];
                cell.description.textColor = [UIColor grayColor];
                cell.description.text = info.content;
            }
        }
        return cell;
    }else if ([tableView isEqual:groudListTable])
    {
        static NSString *identifier = @"groudCell";
        UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UserListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        GroudObject*groudObject = groudArray[indexPath.row];
        
        cell.chatTitle.text = groudObject.groudName;
        cell.imageview.image = [UIImage imageNamed:@"group.jpg"];
        cell.description.text = groudObject.content;
        cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//        GroudObject*info = [groudArray objectAtIndex:indexPath.row];
//        //文本
//        cell.chatTitle.text = info.groudName;
//        
//        cell.timeCreateLabel.text = info.time;
//        NSString *message = info.picUrl;
//        if ([message hasSuffix:@"png"]||[message hasSuffix:@"jpg"]||[message hasSuffix:@"gif"]||[message hasSuffix:@"jpeg"]) {
//            NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",chatUrlPrefix,message]]];
//            cell.imageview.image = [UIImage imageWithData:data];
//            [[ChatDealClass dealDataClass]changePic:data chatID:info.chatID];
//        }else
//        {
//            cell.imageview.image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:message]];
//        }
//        cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//        if (onlineUsers.count>0)
//        {
//            if (stateArray.count>0)
//            {
//                //            UserObject*info1 = [stateArray objectAtIndex:(stateArray.count - indexPath.row-1)];
//                for (GroudObject*info1 in stateArray)
//                {
//                    //                NSLog(@"%@==%@",info1.chatUserID ,info.chatUserID );
//                    if ([info1.chatUserID isEqualToString:info.chatUserID])
//                    {
//                        if ([info1.zt isEqualToString:@"0"])
//                        {
//                            [cell.stateView setHidden:NO];
//                            cell.description.textColor = [UIColor redColor];
//                            cell.description.text = info1.content;
//                            break;
//                        }
//                    }else
//                    {
//                        [cell.stateView setHidden:YES];
//                        cell.description.textColor = [UIColor grayColor];
//                        cell.description.text = info.content;
//                    }
//                }
//                
//            }else
//            {
//                [cell.stateView setHidden:YES];
//                cell.description.textColor = [UIColor grayColor];
//                cell.description.text = info.content;
//            }
//        }
        return cell;
    }
    return nil;
}
//cell响应的编辑按钮样式
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView isEqual:groudListTable])
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    if ([tableView isEqual:chatTable]) {
        if (editingStyle==UITableViewCellEditingStyleDelete)
        {
            //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = 10000+indexPath.row;
            [alert show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"删除");
        UserObject*info = [onlineUsers objectAtIndex:alertView.tag-10000];
        [[ChatDealClass dealDataClass]deleteMan:info.chatUserID];
        [[ChatDealClass dealDataClass]deleteManMSG:info.chatID];
        onlineUsers = [[ChatDealClass dealDataClass]getListMan];
        [chatTable reloadData];
    }else
    {
        NSLog(@"取消");
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults]setObject:@"否" forKey:@"聊天列表界面"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if ([tableView isEqual:chatTable])
    {
        UserObject*info = (UserObject*)[onlineUsers objectAtIndex:indexPath.row];
        
        //start a Chat
        //    chatUserName = (NSString *)[onlineUsers objectAtIndex:indexPath.row];
        ChatController*chatController = [[ChatController alloc]init];
        
        NSString *message = info.chatPicUrl;
        if ([message hasSuffix:@"png"]||[message hasSuffix:@"jpg"]||[message hasSuffix:@"gif"]||[message hasSuffix:@"jpeg"]) {
            NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/%@",message]]];
            
            chatController.chatUserImage = [UIImage imageWithData:data];
            [[ChatDealClass dealDataClass]changePic:data chatID:info.chatID];
        }else
        {
            chatController.chatUserImage = [UIImage imageWithData:[NSData dataWithBase64EncodedString:message]];
        }
        
        chatController.chatWithUser = info.chatUserName;
        chatController.msgArray = [[ChatDealClass dealDataClass]getMsgData:info.chatID withPage:1];
        chatController.sendUserID = info.myID;
        chatController.receiverUserID = info.chatUserID;
        chatController.maxID = info.maxID;
        //    NSLog(@"%@",info.msgID);
        chatController.chatID = info.chatID;
        chatController.ID = info.msgID;
        [[ChatDealClass dealDataClass]changeState:@"1" chatID:info.chatID];
        [self.navigationController pushViewController:chatController animated:YES];
        [[ChatDealClass dealDataClass]sendMSGID:info.msgID];
    }else if ([tableView isEqual:groudListTable])
    {
        UserObject*info = (UserObject*)[onlineUsers objectAtIndex:indexPath.row];
        
        //start a Chat
        //    chatUserName = (NSString *)[onlineUsers objectAtIndex:indexPath.row];
        GroudChatController*groudChat = [[GroudChatController alloc]init];
        
        NSString *message = info.chatPicUrl;
        if ([message hasSuffix:@"png"]||[message hasSuffix:@"jpg"]||[message hasSuffix:@"gif"]||[message hasSuffix:@"jpeg"]) {
            NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.136:82/apply/%@",message]]];
            groudChat.chatUserImage = [UIImage imageWithData:data];
        }else
        {
            groudChat.chatUserImage = [UIImage imageWithData:[NSData dataWithBase64EncodedString:message]];
        }
        
        groudChat.chatWithUser = info.chatUserName;
        groudChat.msgArray = [[ChatDealClass dealDataClass]getMsgData:info.chatID withPage:1];
        groudChat.sendUserID = info.myID;
        groudChat.receiverUserID = info.chatUserID;
        groudChat.maxID = info.maxID;
        //    NSLog(@"%@",info.msgID);
        groudChat.chatID = info.chatID;
        groudChat.ID = info.msgID;
        groudChat.chatListController = self;
        [self.navigationController pushViewController:groudChat animated:YES];
    }
    
    
}


//取得当前程序的委托
-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    
    if (![onlineUsers containsObject:buddyName]) {
        [onlineUsers addObject:buddyName];
        [self.chatTable reloadData];
    }
    
}
//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    
    [onlineUsers removeObject:buddyName];
    [self.chatTable reloadData];
}

@end
