//
//  InputEmoticonTabView.m
//  NIM
//
//  Created by chrisRay on 15/2/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "InputEmoticonTabView.h"
#import "EmoticonManager.h"
#import "UIView+NIMDemo.h"

const NSInteger InputEmoticonTabViewHeight = 35;
const NSInteger InputEmoticonSendButtonWidth = 50;

@interface InputEmoticonTabView()

@property (nonatomic,strong) NSMutableArray * tabs;

@end


@implementation InputEmoticonTabView

- (instancetype)initWithCatalogs:(NSArray *)emoticonCatalogs{
    self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, InputEmoticonTabViewHeight)];
    if (self) {
        _emoticonCatalogs = emoticonCatalogs;
        _tabs = [[NSMutableArray alloc] init];
        for (EmoticonCatalog * catelog in emoticonCatalogs) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:catelog.icon] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:catelog.iconPressed] forState:UIControlStateHighlighted];
            [button sizeToFit];
            [self addSubview:button];
            [_tabs addObject:button];
        }
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"input_send_btn_normal"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"input_send_btn_pressed"] forState:UIControlStateHighlighted];
        _sendButton.height = InputEmoticonTabViewHeight;
        _sendButton.width = InputEmoticonSendButtonWidth;
        [self addSubview:_sendButton];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat left = 20;
    for (UIButton *button in self.tabs) {
        button.left = left;
        button.centerY = self.height * .5f;
        left += button.width;
    }
    _sendButton.right = self.width;
}


@end
