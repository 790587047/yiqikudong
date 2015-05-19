//
//  Photo.m
//  Components
//  照片处理对象
//  Created by Liu Yang on 10-9-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "AppDelegate.h"


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;
{
	if (string == nil)
//		[NSException raise:NSInvalidArgumentException format:@""];
        return nil;
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
//	return [NSData dataWithBytesNoCopy:bytes length:length];
    return [[NSData alloc] initWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoding;
{
	if ([self length] == 0)
		return @"";
	
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [self length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

@end


@implementation Photo

#pragma mark -
#pragma mark 内部方法

+(NSString *) image2String:(UIImage *)image{
	NSMutableDictionary *systeminfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"systeminfo"]];
    float o = 0.1;
	if (!image){//如果没有图则不操作
		return @"";
	}
	image = [self scaleImage:image toWidth:image.size.width/3 toHeight:image.size.height/3];
	if (systeminfo){//如果有系统设置信息
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"大"]){
			o=0.7;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"中"]){
			o=0.5;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"小"]){
			o=0.2;
		}
	}
	NSData* pictureData = UIImageJPEGRepresentation(image,o);
	NSString* pictureDataString = [pictureData base64Encoding];
	
	return pictureDataString;
}

+(NSString *) image2Data:(UIImage *)image{
/*	NSMutableDictionary *systeminfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"systeminfo"]];
    float o = 0.1;
	if (!image){//如果没有图则不操作
		return @"";
	}
	image = [self scaleImage:image toWidth:image.size.width/3 toHeight:image.size.height/3];
	if (systeminfo){//如果有系统设置信息
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"大"]){
			o=0.7;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"中"]){
			o=0.5;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"小"]){
			o=0.2;
		}
	}*/
//	image = [self scaleImage:image toWidth:SCREENWIDTH toHeight:SCREENHEIGHT];
	NSData* pictureData = UIImageJPEGRepresentation(image,0.8);
    NSString *msgStr = [pictureData base64Encoding];
	return msgStr;
}

+(UIImage *) string2Image:(NSString *)string{
	UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:string]];
	return image;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight){
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	UIImage *result= [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
	int width=0;
	int height=0;
	int x=0;
	int y=0;
	
	if (image.size.width<toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height<toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else if (image.size.width>toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height>toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else{
		height = toHeight;
		width = toWidth;
	}
	
	CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
	CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
	return subImage;
}


+(NSData *)scaleData:(NSData *)imageData toWidth:(int)toWidth toHeight:(int)toHeight{
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	int width=0;
	int height=0;
	int x=0;
	int y=0;
	
	if (image.size.width<toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height<toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else if (image.size.width>toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height>toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else{
		height = toHeight;
		width = toWidth;
	}
	
	CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	[image release];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
	CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
	
	NSData *data = UIImageJPEGRepresentation(subImage,1.0);
	return data;
}

+(NSData*)scaleVideoData:(NSString*)url
{
//    NSLog(@"%@",[self getFileSize:url]);
    
    //转换时文件不能已存在，否则出错
    NSString*resultPath;
    NSLog(@"%@",[[NSBundle mainBundle]URLForResource:@"dsa" withExtension:@"mp3" subdirectory:@"Documents/videos"]);
//    NSURL*urlurl = [NSURL URLByResolvingAliasFileAtURL:<#(NSURL *)#> options:<#(NSURLBookmarkResolutionOptions)#> error:<#(NSError **)#>;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        resultPath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]] retain];
        NSLog(@"%@",resultPath);
        [formater release];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusCompleted:
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 default:
                     break;
             }
             NSData*data = [NSData dataWithContentsOfFile:resultPath];
             NSLog(@"data=%@",data);
             [exportSession release];
         }];
    }
//    NSLog(@"%@",[self getFileSize:resultPath]);
    NSData*data = [NSData dataWithContentsOfFile:resultPath];
    NSLog(@"data=%@",data);
    return data;
}
- (void)lowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    session.outputURL = outputURL;
    //输出格式
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = TRUE;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}

@end
