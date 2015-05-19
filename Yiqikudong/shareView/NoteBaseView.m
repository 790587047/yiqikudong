//
//  NoteBaseView.m
//  Yiqikudong
//
//  Created by BK on 15/2/16.
//  Copyright (c) 2015年 YiQiKuDong. All rights reserved.
//

#import "NoteBaseView.h"
#import "NoteView.h"
@interface NoteBaseView ()

@end

@implementation NoteBaseView
@synthesize receiveText,contentText,sendBtn,addPersonBtn,contentStr;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信";
    self.automaticallyAdjustsScrollViewInsets = NO;
    noteArray = [[NSMutableArray alloc]init];
    phoneArray = [[NSMutableArray alloc]init];
    nameArray = [[NSMutableArray alloc]init];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    btnCancel.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    // Do any additional setup after loading the view.
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, TbarHeight, SCREENWIDTH, 40)];
    view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
    view.tag = 900;
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    if (receiveText==nil)
    {
        receiveText = [[UITextView alloc]initWithFrame:CGRectMake(75, 5, SCREENWIDTH-80-40, 30)];
        receiveText.delegate = self;
        receiveText.font = [UIFont systemFontOfSize:14];
        [view addSubview:receiveText];
        UILabel*receiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 65, 30)];
        receiveLabel.backgroundColor = [UIColor clearColor];
        receiveLabel.text = @"收件人:";
        receiveLabel.textColor = [UIColor whiteColor];
        receiveLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:receiveLabel];
    }
    if (addPersonBtn==nil)
    {
        addPersonBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addPersonBtn.frame = CGRectMake(SCREENWIDTH-40, 5,30 , 30);
        addPersonBtn.tintColor = [UIColor whiteColor];
        addPersonBtn.backgroundColor = [UIColor clearColor];
        [addPersonBtn addTarget:self action:@selector(addPersonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addPersonBtn];
    }
    UIView*contentBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40)];
    contentBaseView.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
    contentBaseView.tag = 1000;
    contentBaseView.userInteractionEnabled = YES;
    [self.view addSubview:contentBaseView];
    
    if (contentText==nil)
    {
        contentText = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, SCREENWIDTH-60, SCREENHEIGHT)];
        contentText.delegate = self;
        contentText.font = [UIFont systemFontOfSize:17];
        contentText.textColor = [UIColor blackColor];
        contentText.backgroundColor = [UIColor whiteColor];
        contentText.text = contentStr;
        [contentText becomeFirstResponder];
        [contentBaseView addSubview:contentText];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:contentText.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGRect rect = [contentText.text boundingRectWithSize:CGSizeMake(contentText.frame.size.width-10, contentText.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f",rect.size.height);
                contentText.frame = CGRectMake(5, 5, SCREENWIDTH-60, rect.size.height+20);
                contentBaseView.frame = CGRectMake(0, SCREENHEIGHT-(rect.size.height+30), SCREENWIDTH, rect.size.height+30);
                if (sendBtn==nil)
                {
                    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    sendBtn.frame = CGRectMake(SCREENWIDTH-60, 30, 50, 30);
                    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
                    [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                    sendBtn.center = CGPointMake(SCREENWIDTH-30, contentBaseView.frame.size.height/2);
                    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
                    [contentBaseView addSubview:sendBtn];
                }
            });
        });
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notePersons" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notePersons:) name:@"notePersons" object:nil];
}
-(void)notePersons:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    NSString*str = [self dealData:[dict objectForKey:@"notePersons"]];
    receiveText.text = str;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:receiveText.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rect = [receiveText.text boundingRectWithSize:CGSizeMake(receiveText.frame.size.width-10, receiveText.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%f",rect.size.height);
            receiveText.frame = CGRectMake(75, 5, SCREENWIDTH-120, rect.size.height+25);
            UIView*view = [self.view viewWithTag:900];
            view.frame = CGRectMake(0, TbarHeight, SCREENWIDTH, rect.size.height+35);
        });
    });
}
-(NSString*)dealData:(NSMutableArray*)array
{
    NSLog(@"%@",array);
    NSString*string ;
    for (NSString*str in array)
    {
        NSArray*darray = [str componentsSeparatedByString:@"/"];
        [phoneArray addObject:[darray lastObject]];
        [nameArray addObject:darray[0]];
    }
    for (NSString*str in nameArray)
    {
        if (string ==nil)
        {
            string = [NSString stringWithFormat:@"%@",str];
        }else
        {
            NSString*str1 = [NSString stringWithFormat:@"%@、",string];
            string = [str1 stringByAppendingString:str];
        }
    }
    NSLog(@"%@===%@",phoneArray,string);
    return string;
}
-(void)sendAction:(UIButton*)btn
{
    
}

-(void)addPersonAction:(UIButton*)btn
{
    [noteArray removeAllObjects];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(id tmpPerson in tmpPeoples)
    {
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        NSInteger valuesCount = 0;
        if (tmpPhones != nil) valuesCount = ABMultiValueGetCount(tmpPhones);
        if (valuesCount == 0) {
            CFRelease(tmpPhones);
            continue;
        }
        //获取电话号码和email
        NSString*str;
        for (NSInteger k = 0; k < valuesCount; k++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(tmpPhones, k);
            str = (__bridge NSString*)value;
            CFRelease(value);
        }
        CFRelease(tmpPhones);
        if (tmpFirstName ==nil&&tmpLastName!=nil)
        {
            [noteArray addObject:[NSString stringWithFormat:@"%@/%@",tmpLastName,str]];
        }else if (tmpFirstName!=nil&&tmpLastName==nil) {
            [noteArray addObject:[NSString stringWithFormat:@"%@/%@",tmpFirstName,str]];
        }else if (tmpFirstName!=nil&&tmpLastName!=nil){
            [noteArray addObject:[NSString stringWithFormat:@"%@%@/%@",tmpFirstName,tmpLastName,str]];
        }
//        NSLog(@"%@%@==%@",tmpFirstName,tmpLastName,str);
    }
    CFRelease(addressBook);
    NoteView*noteview = [[NoteView alloc]init];
    noteview.noteArray = noteArray;
    [self.navigationController pushViewController:noteview animated:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //增加监听，当键盘出现或改变时收出消息
    if ([textView isEqual:contentText])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
    }
}
-(void)keyboardWillHiden
{
    UIView*view = [self.view viewWithTag:1000];
    view.frame = CGRectMake(0, SCREENHEIGHT-view.frame.size.height, SCREENWIDTH, view.frame.size.height);
}
-(void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyBoardHeight = keyboardRect.size.height;
    //    NSLog(@"height=%d",keyBoardHeight);
//    if (self.view.frame.size.height - keyBoardHeight <= self.txtUrl.frame.origin.y + self.txtUrl.frame.size.height) {
//        CGFloat y = self.txtUrl.frame.origin.y - (self.view.frame.size.height - keyBoardHeight - self.txtUrl.frame.size.height - 5);
//        [UIView beginAnimations:@"srcollView" context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.275f];
//        self.view.frame = CGRectMake(self.view.frame.origin.x, -y, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
    UIView*view = [self.view viewWithTag:1000];
    view.frame = CGRectMake(0, SCREENHEIGHT-keyBoardHeight-view.frame.size.height, SCREENWIDTH, view.frame.size.height);
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
