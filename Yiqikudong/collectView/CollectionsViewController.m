//
//  CollectionsViewController.m
//  YiQiWeb
//
//  Created by Wendy on 14/11/20.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import "CollectionsViewController.h"
#import "SqlServer.h"
#import "Collection.h"
#import "CustomCell.h"
#import "GoViewController.h"
#import "VerticallyAlignedLabel.h"
#import "Common.h"


#define IMAGEWIDTH 64

@interface CollectionsViewController ()

@end

@implementation CollectionsViewController{
    NSMutableArray *collectionList;
    NSIndexPath *dIndexPath;
    UIWebView *webview;
    ReminderView *indicator;
    BOOL isFlag;
    Collection *item;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    indicator = [ReminderView reminderView];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
    _tableViewList.layer.backgroundColor = colorref;
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
    
    self.navigationItem.title = @"收藏列表";
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    backbutton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backbutton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCollection)];
    addButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButton;
    
    collectionList = [[NSMutableArray alloc] init];
    
    self.tableViewList.tableFooterView = [UIView new];
    
    //    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self setSearchBarTextfiled:self.searchBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

//在searchbar的搜索栏显示搜索两个字
- (void)setSearchBarTextfiled:(UISearchBar *)searchBar{
    for (UIView *view in searchBar.subviews){
        for (id subview in view.subviews){
            if ( [subview isKindOfClass:[UITextField class]] ){
                [(UITextField *)subview setPlaceholder:@"搜索"];
                return;
            }
        }
    }
}

//加载数据
-(void) loadData{
    [collectionList removeAllObjects];
    collectionList = [Collection getAllCollections];
    [self.tableViewList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [collectionList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Collection iPad] ? 180 : 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = (CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Collection *info = [collectionList objectAtIndex:indexPath.row];
    //    cell.lblTitle.text = info.title;
    //    cell.lblTitle.font = [UIFont boldSystemFontOfSize:[Collection iPad] ? 24.0f : 14.0f];
    
    cell.lblUrl.text = info.title;
    cell.lblUrl.numberOfLines = 0;
    cell.lblUrl.lineBreakMode = NSLineBreakByCharWrapping;
    [cell.lblUrl setVerticalAlignment:VerticalAlignmentTop];
    cell.lblUrl.font = [UIFont systemFontOfSize:[Collection iPad] ? 22.0f : 13.0f];
    
    if (info.imgData == nil || info.imgData.length == 0) {
        cell.imgView.image = [UIImage imageNamed:@"Default"];
    }
    else{
        UIImage *image = [[UIImage alloc] initWithData:info.imgData];

        float width = image.size.width;
        float height = image.size.height;
        if (!(width>64||height>64))
        {
            cell.imgView.contentMode = UIViewContentModeCenter;
        }
        
        cell.imgView.image = image;
//        [cell.imgView addSubview:imgView];
    }
    
    int days = [self getPublishedDays:info.publishDate];
    NSString *message;
    if (days == -1) {
        message = @"今天";
    }
    else if (days == 1){
        message = @"昨天";
    }
    else if (days > 1 && days <= 31 ){
        message = [NSString stringWithFormat:@"%d天前",days];
    }
    else{
        NSRange range = [info.publishDate rangeOfString:@" "];
        message = [info.publishDate substringToIndex:range.location];
    }
    cell.lblPublishDate.text = message;
    cell.lblPublishDate.font = [UIFont systemFontOfSize:[Collection iPad] ? 22.0f : 12.0f];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    editButton.frame = CGRectMake(0, 0, 30, 25);
    //    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    //    [editButton addTarget:self action:@selector(gotoEditView:) forControlEvents:UIControlEventTouchUpInside];
    //    editButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    editButton.tag = indexPath.row;
    //    cell.accessoryView = editButton;
    
    return cell;
    
}

//获取两个日期相差的天数
-(int) getPublishedDays : (NSString *) inDay{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:inDay];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
        dIndexPath = indexPath;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 10000) {
            NSString *url = [[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (url.length > 0) {
                NSRange rang = [url rangeOfString:@"http://"];
                if (rang.length == 0) {
                    url = [NSString stringWithFormat:@"http://%@",url];
                }
                
                if ([self isReguex:url]) {
                    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [[UIScreen mainScreen] bounds].size.height)];
                    webView.delegate = self;
                    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
                    [webView loadRequest:request];
                    
                    
                    [self.view addSubview:webView];
                    webView.hidden = YES;
                    isFlag = NO;
                    
                    [self.view addSubview:indicator];
                }else{
                    [Common showMessage:@"输入的网址格式有误" withView:self.view];
                }
            }
            else{
                [Common showMessage:@"请输入网址,收藏失败" withView:self.view];
            }
        }
        else{
            Collection *info = [collectionList objectAtIndex:dIndexPath.row];
            if ([Collection deleteCollectionById:info.cId]) {
                [collectionList removeObjectAtIndex:dIndexPath.row];
                [self.tableViewList deleteRowsAtIndexPaths:@[dIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Collection *info = [collectionList objectAtIndex:indexPath.row];
    GoViewController *viewController = [[GoViewController alloc] initWithNibName:@"GoViewController" bundle:nil];
    viewController.cUrl = info.url;
    
    [self.navigationController pushViewController:viewController animated:YES];
}



#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    [collectionList removeAllObjects];
    collectionList = [Collection getAllCollectionsForSearch:searchText];
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchText:searchText scope:
     [[searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    [self.tableViewList reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self loadData];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

//返回按钮事件
-(void) goback{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) addCollection{
//    EditViewController *viewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
    [self.searchBar resignFirstResponder];
    item = [[Collection alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入收藏的网址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 10000;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) isReguex:(NSString *)url{
    //用正则表达式匹配url
    NSError *error;
    NSString *regulaStr = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:url options:0 range:NSMakeRange(0, [url length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        item.url = [url substringWithRange:match.range];
        return true;
    }
    return false;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view addSubview:indicator];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [Common showMessage:@"请输入有效的网址" withView:self.view];
    [indicator removeFromSuperview];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator removeFromSuperview];
    if (!isFlag) {
        if (item.title.length == 0) {
            item.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        //        NSLog(@"%@",item.title);
        NSString *imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[0].src;"];
        if (imgUrl.length > 0) {
            //获取网页中第一张image
            item.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        }
        else{
            //            //如果网页没有图片，就截图
            //            CGRect r = [UIScreen mainScreen].applicationFrame;
            //            r.origin.y = r.origin.y + 44 ;
            //            UIGraphicsBeginImageContext(self.view.frame.size);
            //            CGContextRef context = UIGraphicsGetCurrentContext();
            //            CGContextSaveGState(context);
            //            UIRectClip(r);
            //            [self.view.layer renderInContext:context];
            //            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            //            item.imgData = UIImageJPEGRepresentation(theImage,1.0);
            //            UIGraphicsEndImageContext();
        }
        //     NSLog(@"imageData=%@",item.imgData);
        NSString *message;
        if (item.title.length > 0) {
            item.url = webView.request.URL.absoluteString;
            if (![Collection isExistsUrl:item.url]) {
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                item.publishDate = [dateFormat stringFromDate:[NSDate date]];
                NSData *iData = item.imgData;
                iData = [Common dealImage:iData];
                if ([Collection addCollection:item WithImgData:iData]) {
                    message = @"收藏成功！";
                    
                }
                else{
                    message = @"收藏失败！";
                }
            }
            else
            {
                message = @"已收藏！";
            }
            [Common showMessage:message withView:self.view];
            [self loadData];
            isFlag = YES;
        }
    }
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
