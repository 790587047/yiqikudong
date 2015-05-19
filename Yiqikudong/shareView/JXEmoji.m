//
//  JXEmoji.m
//  sjvodios
//
//  Created by jixiong on 13-7-9.
//
//

#import "JXEmoji.h"

@implementation JXEmoji
@synthesize maxWidth,faceHeight,faceWidth,offset;



static NSArray        *faceArray;
static NSMutableArray *imageArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(faceArray==nil){
            faceArray = [[NSArray alloc]initWithObjects:@"[微笑]",@"[撇嘴]",@"[色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[睡]",@"[大哭]",
                         @"[尴尬]",@"[发怒]",@"[调皮]",@"[龇牙]",@"[惊讶]",@"[难过]",@"[酷]",@"[冷汗]",@"[抓狂]",@"[吐]",@"[偷笑]",@"[可爱]",@"[白眼]",@"[傲慢]",
                         @"[饥饿]",@"[困]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[大兵]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘...]",@"[晕]",@"[折磨]",@"[衰]",@"[骷髅]",
                         @"[敲打]",@"[再见]",@"[擦汗]",@"[抠鼻]",@"[鼓掌]",@"[糗大了]",@"[坏笑]",@"[左哼哼]",@"[右哼哼]",@"[哈欠]",@"[鄙视]",@"[委屈]",@"[快哭了]",
                         @"[阴险]",@"[亲亲]",@"[吓]",@"[可怜]",@"[菜刀]",@"[西瓜]",@"[啤酒]",@"[篮球]",@"[乒乓]",@"[咖啡]",@"[饭]",@"[猪头]",@"[玫瑰]",@"[凋谢]",
                         @"[示爱]",@"[爱心]",@"[心碎]",@"[蛋糕]",@"[闪电]",@"[炸弹]",@"[刀]",@"[足球]",@"[瓢虫]",@"[便便]",@"[月亮]",@"[太阳]",@"[礼物]",
                         @"[强]",@"[弱]",@"[握手]",@"[胜利]",@"[抱拳]",@"[勾引]",@"[拳头]",@"[差劲]",@"[爱你]",@"[NO]",@"[OK]",@"[爱情]",@"[飞吻]",@"[淘气]",@"[惊呆]",@"[咆哮]",@"[转圈]",nil];
            imageArray = [[NSMutableArray alloc] init];
            for (int i = 0;i<[faceArray count];i++){
                NSString* s = [NSString stringWithFormat:@"e%d",i+1];
                [imageArray addObject:s];
            }
        }
        self.numberOfLines = 0;
        data = [[NSMutableArray alloc] init];
        faceWidth  = 20;
        faceHeight = 20;
        _top       = 0;
        offset     = 0;
//        maxWidth   = frame.size.width;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.textAlignment = NSTextAlignmentLeft;
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    maxWidth   = frame.size.width;
}
-(void)dealloc{
    [data release];
    [super dealloc];
}

- (NSString *)imageFilePath {
    NSString *s=[[NSBundle mainBundle] bundlePath];
    s = [s stringByAppendingString:@"/"];
    //NSLog(@"%@",s);
    return s;
}

-(void) drawRect:(CGRect)rect
{
    [self.textColor set];
    if( [data count]==1){
        if (![self.text hasPrefix:BEGIN_FLAG] && ![self.text hasSuffix:END_FLAG])
            [super drawRect:rect];
        return;
    }
	CGFloat upX=0;
	CGFloat upY=0;
//    NSLog(@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    for (int i=0;i<[data count];i++) {
        NSString *str=[data objectAtIndex:i];
        long int n = NSNotFound;
        
        if ([str hasPrefix:BEGIN_FLAG]&&[str hasSuffix:END_FLAG]) {
            n = [faceArray indexOfObject:str];
            if(n != NSNotFound){
                NSString *imageName = [imageArray objectAtIndex:n];
//                 NSLog(@"bk%@",imageName);
                UIImage *img=[UIImage imageNamed:imageName];
                [img drawInRect:CGRectMake(upX+4, upY+_top+5, faceWidth, faceHeight)];
                upX=faceWidth+upX+3;
                if (i<[data count])
                {
                    if ([[data objectAtIndex:i+1]hasPrefix:BEGIN_FLAG]&&[[data objectAtIndex:i+1] hasSuffix:END_FLAG])
                    {
                        if (SCREENWIDTH>320)
                        {
                            if (upX >= maxWidth-20)
                            {
                                upY = upY +_size+7;
                                upX = 0;
                            }
                        }else
                        {
                            if (upX >= maxWidth-20)
                            {
                                upY = upY +_size+7;
                                upX = 0;
                            }
                        }
                        
                    }else
                    {
                        if (upX >= maxWidth)
                        {
                            upY = upY + _size;
                            upX = 0;
                        }
                    }
                }
                
            }
        }
        
        if(n == NSNotFound){
            for (int j = 0; j < [str length]; j++) {
                NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                if([temp isEqualToString:@"\n"]){
                    upY = upY + _size+10;
                    upX = 0;
                }else{
//                    CGSize size=[temp sizeWithFont:self.font constrainedToSize:CGSizeMake(_size, _size)];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                    CGSize size = [temp boundingRectWithSize:CGSizeMake(_size, _size) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
//                    [temp drawInRect:CGRectMake(upX, upY+_top, size.width, size.height) withFont:self.font];
                    
                    [temp drawInRect:CGRectMake(upX, upY+_top+5, size.width, size.height) withAttributes:attributes];
                    upX=upX+size.width;
                    if (upX >= maxWidth-12)
                    {
                        upY = upY + size.height;
                        upX = 0;
                    }
                }
//                NSLog(@"%@,%f,%f",temp,upX,upY);
            }
        }
    }
//    NSLog(@"%f",upY);
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, upY+faceHeight);
}

-(void)getImageRange:(NSString*)message  array: (NSMutableArray*)array {
//    NSLog(@"%@",message);
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str array:array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str array:array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
    
//    NSLog(@"%@",array);
}

-(void) setText:(NSString *)text{
    [super setText:text];
    [data removeAllObjects];
    [self getImageRange:text array:data];
    
    _size      = self.font.pointSize;
    maxWidth   = self.frame.size.width+offset;
    CGFloat upX=0;
    CGFloat upY=_size;
    BOOL isWidth=NO;
    if (data) {
        for (int i=0;i<[data count];i++) {
            NSString *str=[data objectAtIndex:i];
            BOOL isFace = NO;
            
            if ([str hasPrefix:BEGIN_FLAG]&&[str hasSuffix:END_FLAG]) {
                isFace = [faceArray indexOfObject:str] != NSNotFound;
                if(isFace){
                    upX=faceWidth+upX;
                    if (upX >= maxWidth-5)
                    {
                        upY = upY + _size+faceHeight;
                        upX = 0;
                    }
                }
            }
            
            if(!isFace) {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if([temp isEqualToString:@"\n"]){
                        upY = upY + _size;
                        upX = 0;
                    }else{
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                        CGSize size = [temp boundingRectWithSize:CGSizeMake(_size, _size) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                        upX=upX+size.width;
                        if (upX >= maxWidth-5)
                        {
                            upY = upY + size.height;
                            upX = 0;
                            isWidth = YES;
                        }
                    }
                }
            }
            
        }
    }
    if(upY<self.frame.size.height){
//        _top = (self.frame.size.height-upY)/2;
//        NSLog(@"_top=%d/%d",_top,self.frame.size.height);
    }
    if(upY<_size)
        upY = _size;
    if(upY<self.frame.size.height)
        upY = self.frame.size.height;
    if(isWidth)
        upX = self.frame.size.width;
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y+10, upX, upY); //@ 需要将该view的尺寸记下，方便以后使用
//    NSLog(@"%d,%.1f %.1f", [data count], upX, upY);
}

@end
