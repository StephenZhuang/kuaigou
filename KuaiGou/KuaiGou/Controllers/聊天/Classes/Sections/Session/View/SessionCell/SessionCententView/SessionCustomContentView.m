//
//  SessionCustomContentView.m
//  NIM
//
//  Created by chrisRay on 15/4/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionCustomContentView.h"
#import "NIMMessage.h"
#import "NIMCustomObject.h"
#import "SessionMsgModel.h"
#import "SessionCellLayoutConstant.h"
#import "UIResponder+Router.h"
#import "LoadProgressView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "SessionCellActionHandler.h"
#import "CustomSessionViewHelper.h"
#import "UIView+NIMDemo.h"
#import "NIMSDK.h"

@interface SessionCustomContentView()

@property (nonatomic,strong,readwrite) UIImageView * imageView;

@end

@implementation SessionCustomContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NIMCustomObject *customObject = (NIMCustomObject*)data.msgData.messageObject;
    CustomMessageResult result = [CustomSessionViewHelper valueForCustom:customObject.content];
    switch (result.type) {
        case CustomMessageTypeJanKenPon:
            [self refreshWithJanKenPon:result.value];
            break;
        default:
            //其他类型...如果需要实现更多效果可以在这里进行判断和添加
            break;
    }
    
}

- (void)refreshWithJanKenPon:(CustomJanKenPonValue)value{
    switch (value) {
        case CustomJanKenPonValueJan:
            self.imageView.image         = [UIImage imageNamed:@"custom_msg_jan"];
            break;
        case CustomJanKenPonValueKen:
            self.imageView.image         = [UIImage imageNamed:@"custom_msg_ken"];
            break;
        case CustomJanKenPonValuePon:
            self.imageView.image         = [UIImage imageNamed:@"custom_msg_pon"];
            break;
        default:
            break;
    }
    [self.imageView sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = [self.chatMessage contentViewInsets];
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, [self.chatMessage contentSize].width, [self.chatMessage contentSize].height);
    self.imageView.frame  = imageViewFrame;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
}


- (void)onTap:(id)sender
{
    //onTap
}


@end