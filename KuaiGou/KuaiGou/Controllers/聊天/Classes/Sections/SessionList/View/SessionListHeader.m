//
//  SessionListHeader.m
//  NIM
//
//  Created by chrisRay on 15/3/23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionListHeader.h"
#import "UIView+NIMDemo.h"
#import "Reachability.h"
@interface SessionListHeader()

@property(nonatomic,strong) UILabel *contentLabel;

@end

@implementation SessionListHeader

+ (instancetype)instanceWithStauts:(NIMLoginStep)step{
    
    SessionListHeader *header = nil;
    NSString *text = nil;
    switch (step) {
        case NIMLoginStepLinkFailed:
        case NIMLoginStepLoginFailed:
            text = @"当前网络不可用，请检查网络设置";
            break;
        case NIMLoginStepNetChanged:
        {
            if ([[Reachability reachabilityForInternetConnection] isReachable])
            {
                text = @"网络正在切换,识别中....";
            }
            else
            {
                text = @"当前网络不可用";
            }
        }
            break;
        default:
            break;
    }
    if ([text length])
    {
        header = [[SessionListHeader alloc] initWithFrame:CGRectZero];
        header.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        header.contentLabel.font = [UIFont systemFontOfSize:12.f];
        [header addSubview:header.contentLabel];
        header.contentLabel.text = text;
    }
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


#define SessionListPadding 5
- (CGSize)sizeThatFits:(CGSize)size{
    [self.contentLabel sizeToFit];
    CGSize contentSize = self.contentLabel.frame.size;
    return CGSizeMake(UIScreenWidth, contentSize.height * 2);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentLabel.centerX = self.width  * .5f;
    self.contentLabel.centerY = self.height * .5f;
}

@end
