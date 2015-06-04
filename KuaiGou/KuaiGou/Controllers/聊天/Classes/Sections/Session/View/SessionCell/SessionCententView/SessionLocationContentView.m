//
//  SessionLocationContentView.m
//  NIM
//
//  Created by chrisRay on 15/2/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionLocationContentView.h"
#import "NIMLocationObject.h"
#import "SessionMsgModel.h"
#import "UIView+NIMDemo.h"
#import "SessionCellActionHandler.h"
#import "UIResponder+Router.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"

@interface SessionLocationContentView()

@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation SessionLocationContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        UIImage *image = [UIImage imageNamed:@"bk_map"];
        _imageView  = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NIMLocationObject * locationObject = (NIMLocationObject*)data.msgData.messageObject;
    self.titleLabel.text = locationObject.address;
}

- (void)onTap:(id)sender
{
    NIMLocationObject *locationObject = (NIMLocationObject*)[self.chatMessage msgData].messageObject;
    SessionCellEventParam *param = [[SessionCellEventParam alloc] initSessionCellEventParam:SessionMessageEventIDPreviewLocation
                                                                                      param:locationObject];
    [self nim_routerEvent:param];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.width = self.width - 10;
    _titleLabel.height= 35.f;
    self.titleLabel.centerY = 90.f;
    
    UIEdgeInsets contentInsets = [self.chatMessage contentViewInsets];
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, [self.chatMessage contentSize].width, [self.chatMessage contentSize].height);
    self.imageView.frame  = imageViewFrame;
}


@end
