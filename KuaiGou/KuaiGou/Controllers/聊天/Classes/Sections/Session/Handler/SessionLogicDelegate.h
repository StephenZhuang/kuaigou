//
//  SessionLogicDelegate.h
//  NIMDemo
//
//  Created by ght on 15-1-30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NIMMessage;
@class SessionMsgModel;
@class GalleryItem;
@protocol SessionLogicDelegate <NSObject>

@optional
//cell 相关
- (void)onDeleteMessage:(SessionMsgModel*)message;
- (void)toGalleryVC:(NIMImageObject *)object;
- (void)toLocationVC:(NIMLocationObject *)object;
- (void)toVideoVC:(NIMVideoObject *)object;
@end
