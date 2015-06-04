//
//  CustomLeftBarItem.h
//  nim
//
//  Created by user on 14-6-6.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BadgeView;

@protocol CustomLeftBarItemItemProtocol <NSObject>
@optional
- (void)onLeftButtonPressed;

@end


@interface CustomLeftBarView : UIView

@property (nonatomic, strong) BadgeView *badgeView;
@property (nonatomic, assign) id<CustomLeftBarItemItemProtocol> delegate;

- (void)initSubviews;
@end
