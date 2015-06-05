//
//  SessionTextContentView.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionTextContentView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "M80AttributedLabel+NIM.h"


@implementation SessionTextContentView

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
    
    NSString *text = [data.msgData text];
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
