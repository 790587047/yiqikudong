//
//  CommentListViewController.m
//  Yiqikudong
//http://blog.csdn.net/rhljiayou/article/details/9340657
//  Created by wendy on 15/5/6.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentViewCell.h"
#import "NSString+Message.h"
#import "Common.h"
#import "AFNetworking.h"
#import "CommentModel.h"
#import "MJRefresh.h"

@interface CommentListViewController ()

@end

@implementation CommentListViewController{
    //表情界面
    UIView *faceView;
    UIScrollView *faceScroll;
    UIPageControl *pageControl;
    NSArray *faceArray;
    CGFloat previousTextViewContentHeight;
    CommentModel *model;
    NSIndexPath *sIndexPath;
    UITapGestureRecognizer *cancelRecognizer;
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[CommentModel alloc] init];
    
    [self initNavBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    _commentList = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    [self loadSendView];
    
    //添加手势事件收起键盘
    cancelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:cancelRecognizer];
    
    page = 1;
    [_tableView addHeaderWithTarget:self action:@selector(getHeadData)];
    [_tableView addFooterWithTarget:self action:@selector(getFootData)];
    [_tableView headerBeginRefreshing];

}

-(void)hideKeyBoard:(UITapGestureRecognizer*)tapGr{
    [self.view removeGestureRecognizer:tapGr];
    if (faceView != nil) {
        faceView.hidden = YES;
    }
    if (![_txtMessage isExclusiveTouch]) {
        [_txtMessage resignFirstResponder];
    }
    [_sendView setFrame:CGRectMake(0, SCREENHEIGHT - CGRectGetHeight(_sendView.frame), SCREENWIDTH, CGRectGetHeight(_sendView.frame))];
    [_btnChange setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
    _btnChange.selected = NO;
    [_tableView setFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetMidY(_sendView.frame))];
}

-(void) getHeadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page = 1;
        [_commentList removeAllObjects];
        [self loadData];
        [_tableView headerEndRefreshing];
    });
}

-(void) getFootData{
    page ++;
    [self loadData];
    [_tableView footerEndRefreshing];
}

/**
 *  初始化状态栏
 */
-(void) initNavBar{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.title = @"评论";
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18.f],NSFontAttributeName,
                                                                     nil]];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(22, 10, 30, 20);
    [btnBack setImage:[UIImage imageNamed:@"playBack"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backButton;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    });
}

/**
 *  加载数据
 */
-(void) loadData{
    for (int i = 0; i < 10; i++) {
        CommentModel *item = [[CommentModel alloc] init];
        item.voiceId = [NSString stringWithFormat:@"%d",i];
        if (i == 0) {
            item.commentConntent = @"[擦汗]RichTextBox控件允许用户输入和编辑文本的同时提供了[龇牙]比普通的TextBox控件更高级的格式特征。 RichTextBox控件提供了数个有用的特征[擦汗]，你可以在控件中安排文本的格式。[擦汗]要改变文本的格式，[菜刀]必须先选中该文本。只有选中的文本才可以编排字符和段落的格式。https://github.com额/有了这些属性，就可以设置[菜刀]文本使用粗体，改变[大哭]字体的颜色，创建超底稿和子底稿。[大哭]也可以设置左右缩排或不缩排，从而调整段落的格式。 RichTextBox控件可以打开和保存RTF文件或普通的ASCII文本文件。你可以使用控件的方法（LoadFile[大哭]SaveFile）直接读和写文件 RichTextBox控件使用集合支https://github.com持嵌入的对象。每个嵌入控件中的对象都表示为一个[1]对象。这允许文档中创建的控件可以包含其他控件或文档。https://github.com/ 例如，可以创建一个包含报表、Microsoft Word文档或任何在系统中注册的其他OLE对象的文档。要在RichTextBox控件中插入对象，可以简单地拖住一个文件（如使用Windows 95的Explorerwww.chiphell.com/或其他应用程序（如Microsoft Word）中所用文件的加亮部分（选择部分），将其直接放到该RichTextBox控件上。http://www.cnblogs.com/CCSSPP/";
            item.createTime = @"2015-05-18 11:39:00";
        }
        else{
            item.commentConntent = @"[擦汗]RichTextBox控件允许用户输入和编辑文本的同时提供了[龇牙]比普通的TextBox控件更高级的格式特征。 RichTextBox控件提供了数个有用的特征";
            item.createTime = @"2014-01-22 12:12:00";
        }
        item.commentUserName = @"开始懂了";
        [_commentList addObject:item];
    }
}

/**
 *  显示下面输入栏
 */
-(void) loadSendView{
    if (_sendView == nil) {
        _sendView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50)];
        [_sendView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:242.0/255.0 alpha:1.0]];
        [self.view addSubview:_sendView];
    }
//    NSLog(@"%@",NSStringFromCGRect(_sendView.frame));
//    NSLog(@"%f",CGRectGetMidY(_sendView.frame));
    
    if (_txtMessage == nil) {
        _txtMessage = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/3*2, 35)];
        _txtMessage.layer.masksToBounds = YES;
        _txtMessage.layer.cornerRadius = 18.f;
        _txtMessage.layer.borderColor = [UIColor colorWithRed:194.0/255.0 green:195.0/255.0 blue:196.0/255.0 alpha:1.0].CGColor;
        _txtMessage.layer.borderWidth = 1;
        _txtMessage.center = CGPointMake(self.view.center.x, CGRectGetMidY(_sendView.frame)-_sendView.frame.origin.y);
        _txtMessage.backgroundColor = WHITECOLOR;
//        _txtMessage.enablesReturnKeyAutomatically = YES;
        _txtMessage.delegate = self;
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: _txtMessage.text];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.headIndent = 20;//左缩进
//        paragraphStyle.firstLineHeadIndent = 20;//首行缩进
//        paragraphStyle.tailIndent = -5; //右缩进
//        [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange (0 , [_txtMessage.text length])];
//        _txtMessage.attributedText = attributedString;
//        [_txtMessage sizeToFit];
        _txtMessage.textContainerInset = UIEdgeInsetsMake(2, 10, 2, 10);
        [_txtMessage setFont:[UIFont systemFontOfSize:20.f]];
        _txtMessage.scrollEnabled = NO;
    }
    [_sendView addSubview:_txtMessage];
    
    if (_btnChange == nil) {
        _btnChange = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnChange setFrame:CGRectMake(CGRectGetMinX(_txtMessage.frame) - 40, 5, 30, 30)];
        [_btnChange setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
        _btnChange.center = CGPointMake(_btnChange.center.x, _txtMessage.center.y);
    }
    [_btnChange addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnChange.selected = NO;
    [_sendView addSubview:_btnChange];
    
    if (_btnSend == nil) {
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSend setFrame:CGRectMake(CGRectGetMaxX(_txtMessage.frame)+5, 0, 45, 30)];
        _btnSend.center = CGPointMake(_btnSend.center.x, _txtMessage.center.y);
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend setBackgroundColor:[UIColor lightGrayColor]];
        _btnSend.layer.masksToBounds = YES;
        _btnSend.layer.cornerRadius = 15.f;
        [_btnSend.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_btnSend addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    }
    [_sendView addSubview:_btnSend];
}


#pragma mark-- tableView datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentList.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *commentCell = @"CommentCell";

    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
    
    if (!cell) {
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:commentCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentModel *obj = [_commentList objectAtIndex:indexPath.row];

    [cell initData:obj];
    if (indexPath.row % 2 != 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *commentCell = @"CommentCell";
//    CommentViewCell *cell = (CommentViewCell *)[[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCell];
    CommentModel *item = [_commentList objectAtIndex:indexPath.row];
    if (item.commentConntent.length > 0) {
        CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake(SCREENWIDTH-20, 500) font:[UIFont systemFontOfSize:14.f] string:item.commentConntent lineSpace:1.0f];
        NSLog(@"%@",NSStringFromCGRect(rect));
        return rect.size.height + 60;
    }
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *obj = [_commentList objectAtIndex:indexPath.row];
    _txtMessage.text = [NSString stringWithFormat:@"@%@:",obj.commentUserName];
    model.replyUserId = @"2";
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        sIndexPath = indexPath;
        [alert show];
    }
}

#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //自己发表的是否可以回复
        
    }
}

#pragma mark -- 按钮事件

/**
 *  点击表情按钮事件
 *
 *  @param sender 表情按钮
 */
-(void) faceAction:(UIButton *) sender{
    [self.view addGestureRecognizer:cancelRecognizer];
    if (!sender.selected) {
        [sender setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        sender.selected = YES;
        
//        [UIView beginAnimations:@"srcollView" context:nil];
//        [UIView setAnimationCurve:UIViewAnimationTransitionCurlUp];
//        [UIView setAnimationDuration:0.275f];
        
//        [_sendView setBackgroundColor:[UIColor yellowColor]];
//        NSLog(@"%@",NSStringFromCGRect(_sendView.frame));
        
        [self showFaceView];
        
//        [UIView commitAnimations];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
        sender.selected = NO;
        [_txtMessage becomeFirstResponder];
        _txtMessage.selectedRange = NSMakeRange(_txtMessage.text.length, _txtMessage.text.length);
    }
}

/**
 *  显示表情列表
 */
-(void) showFaceView{
    [_txtMessage resignFirstResponder];
    if (faceView == nil) {
        faceView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 150, SCREENWIDTH, 150)];
        faceView.hidden = NO;
        
        faceScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
        [faceScroll setContentSize:CGSizeMake(SCREENWIDTH * 4, 150)];
        faceScroll.delegate = self;
        faceScroll.pagingEnabled = YES;
        faceScroll.scrollsToTop = NO;
        faceScroll.panGestureRecognizer.delaysTouchesBegan = YES;
        faceScroll.backgroundColor = _sendView.backgroundColor;
        faceScroll.showsHorizontalScrollIndicator = NO;
        [faceView addSubview:faceScroll];
        
        for (int i = 0 ; i < 4; i ++) {
            ZBFaceView *fView = [[ZBFaceView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.view.bounds),0.0f,CGRectGetWidth(self.view.bounds),CGRectGetHeight(faceScroll.bounds)) forIndexPath:i];
            [faceScroll addSubview:fView];
            fView.delegate = self;
        }
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 20, 132, 40, 18)];
        pageControl.numberOfPages = 4;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [faceView addSubview:pageControl];
        
        [self.view addSubview:faceView];
    }
    else{
        faceView.hidden = NO;
    }
//    CGRect rect = _sendView.frame;
    [_sendView setFrame:CGRectMake(0, faceView.frame.origin.y - CGRectGetHeight(_sendView.frame), SCREENWIDTH, CGRectGetHeight(_sendView.frame))];
    [_tableView setFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetMidY(_sendView.frame))];
}

#pragma mark--
#pragma mark -- UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = scrollView.contentOffset.x / SCREENWIDTH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- uitextviewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length == 0) {
        NSString *msg = _txtMessage.text;
        if (msg.length > 0) {
            NSString *lastMsg = [msg substringWithRange:NSMakeRange(msg.length-1,1)];
            if ([lastMsg isEqualToString:@"]"]) {
                NSRange r = [msg rangeOfString:@"[" options:NSBackwardsSearch];
                _txtMessage.text = [msg substringToIndex:r.location+1];
            }
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    CGFloat maxHeight = 24 * 3;
    CGSize size = [_txtMessage sizeThatFits:CGSizeMake(CGRectGetWidth(_txtMessage.frame), maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    BOOL isSriking = textViewContentHeight < previousTextViewContentHeight;
    
    CGFloat changeInHeight = textViewContentHeight - previousTextViewContentHeight;
    if (!isSriking && previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else{
        changeInHeight = MIN(changeInHeight, maxHeight - previousTextViewContentHeight);
    }
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.01f animations:^{
            [self adjustTextViewHeightBy:changeInHeight];
            CGRect inputViewFrame = self.sendView.frame;
            self.sendView.frame = CGRectMake(0.0f,
                                             inputViewFrame.origin.y - changeInHeight,
                                             inputViewFrame.size.width,
                                             inputViewFrame.size.height + changeInHeight);
        }];
        previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    else{
        _txtMessage.scrollEnabled = YES;
        [_txtMessage scrollRangeToVisible:NSMakeRange(_txtMessage.text.length, 1)];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (!previousTextViewContentHeight) {
        previousTextViewContentHeight = textView.contentSize.height;
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = _txtMessage.frame;
    
    self.txtMessage.frame = CGRectMake(prevFrame.origin.x,
                                       prevFrame.origin.y,
                                       prevFrame.size.width,
                                       (prevFrame.size.height + changeInHeight) <  35
                                       ? 35 : prevFrame.size.height + changeInHeight);

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    return YES;
}

-(void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyBoardHeight = keyboardRect.size.height;
//    NSLog(@"height=%d",keyBoardHeight);
    [_btnChange setImage:[UIImage imageNamed:@"ql_talk_pic9"] forState:UIControlStateNormal];
    _btnChange.selected = NO;
    [_sendView setFrame:CGRectMake(0, SCREENHEIGHT - keyBoardHeight - CGRectGetHeight(_sendView.frame), SCREENWIDTH, CGRectGetHeight(_sendView.frame))];
    if (self.view.frame.size.height - keyBoardHeight <= self.sendView.frame.origin.y + self.sendView.frame.size.height) {
        CGFloat y = self.sendView.frame.origin.y - (self.view.frame.size.height - keyBoardHeight - self.sendView.frame.size.height - 5);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    [_tableView setFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetMidY(_sendView.frame))];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_sendView setFrame:CGRectMake(0, faceView.frame.origin.y - CGRectGetHeight(_sendView.frame), SCREENWIDTH, CGRectGetHeight(_sendView.frame))];
    [_tableView setFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetMidY(_sendView.frame))];
    [UIView commitAnimations];
}

#pragma mark--
#pragma mark--ZBFaceViewDelegate
-(void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del{
    //点击了表情按钮
    if (!del) {
        _txtMessage.text = [_txtMessage.text stringByAppendingString:faceName];
        if (!previousTextViewContentHeight) {
            previousTextViewContentHeight = _txtMessage.contentSize.height;
        }
    }
    //点击了删除按钮
    else{
        NSString *msg = [_txtMessage.text stringByTrimingWhitespace];
        if (msg.length > 0) {
            NSString *lastMsg = [msg substringWithRange:NSMakeRange(msg.length-1,1)];
            if ([lastMsg isEqualToString:@"]"]) {
                 NSRange range = [msg rangeOfString:@"[" options:NSBackwardsSearch];
                _txtMessage.text = [msg substringToIndex:range.location];
            }
            else{
                _txtMessage.text = [msg substringToIndex:_txtMessage.text.length-1];
            }
        }
    }
    [self textViewDidChange:_txtMessage];
}

/**
 *  返回按钮事件
 */
-(void) goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送评论
 */
-(void) sendComment{
    
    NSString *message = [_txtMessage.text stringByTrimingWhitespace];
    if (message.length > 0) {
//        CommentModel *model = [[CommentModel alloc] init];
//        model.voiceId = _voiceId;
        model.commentConntent = message;
        model.commentUserId = @"1";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%@",model.commentUserId],@"content":model.commentConntent};
        
        NSString *postPath = [NSString stringWithFormat:@"%@yiqiVideo_up_save.asp",VOICEHEADPATH];
        
        [manager POST:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"message = %@",operation.responseString);
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSString *result = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"suc"]];
            if ([result isEqual: @"1"]) {
                NSArray *arrs = [dictionary objectForKey:@"info"];
                for (NSDictionary *eachDict in arrs) {
                    CommentModel *obj = [[CommentModel alloc] init];
                    obj.commentID = [eachDict objectForKey:@"commentId"];
                    obj.voiceId = [eachDict objectForKey:@"voiceId"];
                    obj.commentConntent = [eachDict objectForKey:@"content"];
                    obj.createTime = [eachDict objectForKey:@"createTime"];
                    obj.commentUserName = [eachDict objectForKey:@"commentUserName"];
                    obj.userImage = [eachDict objectForKey:@"UserImage"];
                    obj.replyUserName = [eachDict objectForKey:@"replyUserName"];
                    obj.isDirect = [[eachDict objectForKey:@"isDirect"] integerValue];
                    [_commentList addObject:obj];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation error = %@",operation.responseString);
            NSLog(@"error = %@",error);
            [Common showMessage:@"发表评论失败，请稍候再试" withView:self.view];
        }];
    }
    else{
        [Common showMessage:@"评论内容不能为空" withView:self.view];
    }
}

/**
 *  计算出有多少行
 *
 *  @return 多少行
 */
- (NSInteger)numberOfLinesOfText{
    int line = _txtMessage.contentSize.height/_txtMessage.font.lineHeight;
    return line;
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
