//
//  SessionMsgModel+SessionCellLayoutProtocol.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMsgModel.h"

//Cell 布局
@interface SessionMsgModel (SessionCellLayoutProtocol)

//控件隐藏
- (BOOL)retryButtonHidden;
- (BOOL)activityIndicatorHidden;
- (BOOL)unreadHidden;

//排版 padding
- (UIEdgeInsets)bubbleViewInsets;
- (CGFloat)cellHeight;
- (CGFloat)retryButtonBubblePadding;
- (CGSize)bubbleViewSize; //气泡大小
- (CGRect)avatarViewRect;

- (UIEdgeInsets)contentViewInsets;

//control 显示内容
- (BOOL)nickNameShow;
- (UIImage *)bubbleImageForState:(UIControlState)state;

@end
