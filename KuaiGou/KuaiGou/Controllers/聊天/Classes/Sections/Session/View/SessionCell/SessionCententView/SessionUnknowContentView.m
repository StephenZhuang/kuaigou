//
//  SessionUnknowContentView.h
//  NIM
//
//  Created by chrisRay on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionUnknowContentView.h"
#import "M80AttributedLabel+NIM.h"
#import "UIView+NIMDemo.h"
@implementation SessionUnknowContentView

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NSString *text = @"未知消息类型";
    [self.textLabel nim_setText:text];
}

@end
