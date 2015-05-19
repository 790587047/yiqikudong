//
//  VoiceDownloadTable.m
//  YiQiWeb
//
//  Created by BK on 15/1/7.
//  Copyright (c) 2015年 BK. All rights reserved.
//

#import "VoiceDownloadTable.h"
#import "VoiceDownloadCell.h"
@implementation VoiceDownloadTable
@synthesize infoArray;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.922, 0.922, 0.922, 1 });
        
        self.layer.backgroundColor = colorref;
        CGColorRelease(colorref);
        CGColorSpaceRelease(colorSpace);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markCell";
    VoiceDownloadCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
//    VoiceInfo*info = infoArray[indexPath.row];
    if (cell ==nil)
    {
        if (isPad)
        {
            cell = [[VoiceDownloadCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80) sumTime:infoArray[indexPath.row]];
        }else
        {
            cell = [[VoiceDownloadCell alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) sumTime:infoArray[indexPath.row]];
        }
        
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return infoArray.count;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 3000+indexPath.row;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        VoiceInfo*info = infoArray[alertView.tag-3000];
        NSString*url = [[[NSString stringWithFormat:@"%@",info.url] componentsSeparatedByString:@"/"] lastObject];
        [[DealData dealDataClass]deleteDownloadVoice:url];
        infoArray = (NSMutableArray*)[[DealData dealDataClass]getDownloadVoiceData];
        [self reloadData];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isPad)
    {
        return 80;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableVie0w:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceInfo*info = infoArray[indexPath.row];
    int height;
    if (isPad)
    {
        height = 100;
        playView = [[VoicePlayView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-height-125, SCREENWIDTH, height) info:info];
    }else
    {
        height = 50;
        playView = [[VoicePlayView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-height-105, SCREENWIDTH, height) info:info];
    }
    [playView.starBtn addTarget:self action:@selector(starPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:playView];
    NSError*error;
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:info.url error:&error];
    [player prepareToPlay];
    NSLog(@"player.error===%@",error);
    player.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop]run];//在子线程中开计时器必须使用该方法。
    });
}
-(void)timer
{
    if (player.isPlaying)
    {
//        int second = (int)player.currentTime%60;
//        int mimute = (int)player.currentTime/60>60?(int)player.currentTime/60%60:(int)player.currentTime/60;
//        int hour = (int)player.currentTime/60>60?(int)player.currentTime/60/60:00;
        dispatch_async(dispatch_get_main_queue(), ^{
            playView.timeLabel.attributedText = [playView getTimeStringWithCurrentTime:player.currentTime sumTime:player.duration];
            playView.progress.progress = player.currentTime/player.duration;
        });
    }
}

-(void)starPlay:(UIButton*)btn
{
    if (player.isPlaying)
    {
        [player stop];
        if (isPad)
        {
            [btn setImage:[UIImage imageNamed:@"voiceplay"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"voiceplay"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
        }
        
    }else
    {
        [player play];
        if (isPad)
        {
            [btn setImage:[UIImage imageNamed:@"voicestart"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"voicestart"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
        }
        
    }
}
@end
