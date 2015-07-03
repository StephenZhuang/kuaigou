//
//  VideoChatNetStateView.h
//  NIM
//
//  Created by chrisRay on 15/5/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoChatNetStatusView : UIView

- (void)refreshWithNetState:(NIMNetCallNetStatus)status;

@end
