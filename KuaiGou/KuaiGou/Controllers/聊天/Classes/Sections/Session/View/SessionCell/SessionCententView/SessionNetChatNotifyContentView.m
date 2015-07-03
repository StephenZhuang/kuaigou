//
//  SessionNetChatNotifyContentView.m
//  NIM
//
//  Created by chrisRay on 15/5/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionNetChatNotifyContentView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "M80AttributedLabel+NIM.h"
#import "NIMNotificationObject.h"
#import "SessionUtil.h"

@implementation SessionNetChatNotifyContentView

-(instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        //
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.font = [UIFont systemFontOfSize:14.f];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NIMNotificationObject *object = data.msgData.messageObject;
    NSString *text = [SessionUtil netcallMessageText:object];
    [_textLabel nim_setText:text];
    if (!data.isFromMe) {
        _textLabel.textColor = [UIColor blackColor];
    }else{
        _textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = [self.chatMessage contentViewInsets];
    CGRect labelFrame = CGRectMake(contentInsets.left, contentInsets.top, [self.chatMessage contentSize].width, [self.chatMessage contentSize].height);
    self.textLabel.frame = labelFrame;
}


@end
