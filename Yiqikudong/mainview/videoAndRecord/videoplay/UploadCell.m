//
//  UploadCell.m
//  YiQiWeb
//
//  Created by wendy on 15/1/19.
//  Copyright (c) 2015年 wendy. All rights reserved.
//

#import "UploadCell.h"

@implementation UploadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initData:(VideoModel *)model{
    [self setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
    
    if (self.bgView == nil) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, SCREENWIDTH - 16, 104)];
        [self addSubview:self.bgView];
        [self.bgView setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (self.imgView == nil) {
        self.imgView = [[UIImageView alloc] initWithFrame: CGRectMake(15, 17, SCREENWIDTH*0.34, self.bgView.frame.size.height*0.8)];
        [self addSubview:self.imgView];
    }
    [self.imgView setUserInteractionEnabled:YES];
    self.imgView.image =[UIImage imageWithData:model.v_imageData];
    
    float x = self.imgView.frame.origin.x+self.imgView.frame.size.width+10;
    
    if (self.lblName == nil) {
        self.lblName = [[UILabel alloc] initWithFrame: CGRectMake(x, 14, 159, 25)];
        [self.lblName setFont:[UIFont systemFontOfSize: 17.0f]];
        [self.lblName setTextColor:[UIColor darkGrayColor]];
        [self.lblName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.lblName];
    }
    [self.lblName setText:model.v_Name];
    
    if (self.lblSpeed == nil) {
        self.lblSpeed = [[UILabel alloc] initWithFrame: CGRectMake(x, 79, 129, 18)];
        [self.lblSpeed setTextColor:[UIColor lightGrayColor]];
        [self.lblSpeed setFont:[UIFont systemFontOfSize:14.0f]];
        [self addSubview:self.lblSpeed];
    }
    
    if (model.v_State == Uploading || model.v_State == Downloading) {
        if (self.lblLayer == nil) {
            self.lblLayer = [[UILabel alloc] initWithFrame:self.imgView.bounds];
            [self.lblLayer setBackgroundColor:[UIColor blackColor]];
            [self.lblLayer setAlpha:.5f];
            [self.imgView addSubview:self.lblLayer];
        }
        
        if (model.v_State == Downloading) {
            if (self.btnUpload == nil) {
                self.btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:self.btnUpload];
                [self.btnUpload setFrame:CGRectMake(34, 45, 70, 30)];
                [self.btnUpload.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [self.btnUpload setImage:nil forState:UIControlStateNormal];
                [self.btnUpload setTitle:@"下载中" forState:UIControlStateNormal];
//                self.btnUpload.center = CGPointMake(self.imgView.frame.size.width/2, self.imgView.frame.size.height/2);
                [self.btnUpload setImage:[UIImage redraw:[UIImage imageNamed:@"pause"] Frame:CGRectMake(0, 0, 10, 13)] forState:UIControlStateNormal];
                [self.btnUpload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        if (model.errorIndex == 1) {
            if (self.btnUpload == nil) {
                self.btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:self.btnUpload];
                [self.btnUpload setFrame:CGRectMake(34, 45, 70, 30)];
                [self.btnUpload.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [self.btnUpload setImage:nil forState:UIControlStateNormal];
                [self.btnUpload setTitle:@"重新上传" forState:UIControlStateNormal];
            }
            else{
                [self.btnUpload setImage:nil forState:UIControlStateNormal];
                [self.btnUpload setTitle:@"重新下载" forState:UIControlStateNormal];
            }
        }
        self.btnUpload.center = self.imgView.center;
        
        if (self.progressView == nil) {
            self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(x, self.imgView.frame.origin.y+self.imgView.frame.size.height - self.progressView.frame.size.height, SCREENWIDTH*0.52, 2)];
            [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
            [self.progressView setTintColor:[UIColor redColor]];
            [self addSubview:self.progressView];
        }
        [self.progressView setProgress:model.downloadMemory/model.sumMemory];
        
        self.lblSpeed.text = [NSString stringWithFormat:@"%.02fMB/%.02fMB",model.downloadMemory,model.sumMemory];
        
        if (self.lblProgress == nil) {
            float lblprogressLeft = SCREENWIDTH - self.progressView.frame.size.width - self.imgView.frame.size.width;
            self.lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width - lblprogressLeft , self.lblSpeed.frame.origin.y, 40, 21)];
            [self.lblProgress setTextColor:[UIColor redColor]];
            model.progress = model.downloadMemory / model.sumMemory * 100;
            self.lblProgress.text = [NSString stringWithFormat:@"%d%%",(int)model.progress];
            [self.lblProgress setFont:[UIFont systemFontOfSize:14.0f]];
            [self.lblProgress setTextAlignment:NSTextAlignmentRight];
            [self addSubview:self.lblProgress];
        }
        else
            self.lblProgress.text = [NSString stringWithFormat:@"%d%%",(int)model.progress];
    }
    else{
        if (self.progressView != nil)
            [self.progressView removeFromSuperview];
        if (self.lblProgress != nil)
            [self.lblProgress removeFromSuperview];
        if (self.lblLayer != nil)
            [self.lblLayer removeFromSuperview];
        
        self.lblSpeed.text = [NSString stringWithFormat:@"%.2fMB",model.sumMemory];
        [self.lblSpeed setFont:[UIFont systemFontOfSize:16.0f]];
        
        if (self.btnUpload != nil) {
            [self.btnUpload removeFromSuperview];
        }
        self.btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btnUpload];
        [self.btnUpload setFrame: CGRectMake(44, 35, 50, 50)];
        self.btnUpload.center = self.imgView.center;
        [self.btnUpload setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.btnUpload setTitle:@"" forState:UIControlStateNormal];
        
        if (model.v_State == UploadFinish) {
            if (model.downLoadId == 0) {
                if (self.btnDown == nil) {
                    self.btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
                }
                [self addSubview:self.btnDown];
                [self.btnDown setTitle:@"下载" forState:UIControlStateNormal];
                [self.btnDown.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
                [self.btnDown setFrame:CGRectMake(self.bgView.frame.size.width - 30, self.lblSpeed.frame.origin.y, 30, 20)];
//                [self.btnDown setFrame:CGRectMake(self.lblSpeed.frame.origin.x + self.lblSpeed.frame.size.width, self.lblSpeed.frame.origin.y, 30, 20)];
                [self.btnDown setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

@end
