//
//  InputEmoticonButton.m
//  NIM
//
//  Created by chrisRay on 15/2/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "InputEmoticonButton.h"
#import "EmoticonManager.h"
@implementation InputEmoticonButton

+ (InputEmoticonButton*)iconButtonWithData:(Emoticon*)data catalogID:(NSString*)catalogID delegate:( id<EmoticonButtonTouchDelegate>)delegate{
    InputEmoticonButton* icon = [[InputEmoticonButton alloc] init];
    [icon addTarget:icon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [InputEmoticonButton imageWithData:data];
    
    icon.emoticonData    = data;
    icon.catalogID              = catalogID;
    icon.userInteractionEnabled = YES;
    icon.exclusiveTouch         = YES;
    icon.contentMode            = UIViewContentModeScaleToFill;
    icon.delegate               = delegate;
    [icon setImage:image forState:UIControlStateNormal];
    [icon setImage:image forState:UIControlStateHighlighted];
    return icon;
}

+ (UIImage*) imageWithData:(Emoticon*)data{
    //先取1x图
    NSString *thumbPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], data.filename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:thumbPath]) //不存在，则取2x图
    {
        NSString *fileExternName = [data.filename pathExtension];
        NSString *fileName = [data.filename stringByDeletingPathExtension];
        thumbPath = [NSString stringWithFormat:@"%@/%@%@%@", [[NSBundle mainBundle] bundlePath],fileName, @"@2x.", fileExternName];
    }
    return [UIImage imageWithContentsOfFile:thumbPath];
}

- (void)onIconSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedEmoticon:catalogID:)])
    {
        [self.delegate selectedEmoticon:self.emoticonData catalogID:self.catalogID];
    }
}

@end
