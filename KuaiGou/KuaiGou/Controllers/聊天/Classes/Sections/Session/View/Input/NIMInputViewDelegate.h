//
//  NIMInputViewDelegate.h
//  NIMDemo
//
//  Created by ght on 15-1-22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NIMInputViewDelegate <NSObject>

- (void)showInputView;
- (void)hideInputView;
- (void)inputViewSizeToHeight:(CGFloat)toHeight showInputView:(BOOL)show;

@end


@protocol InputActionDelegate <NSObject>

@optional
- (void)sendTextMessage:(NSString*)text;
- (void)onTextChanged:(id)sender;
- (void)delegatePicturePressed;
- (void)delegateShootPressed;
- (void)delegateVideoPressed;
- (void)delegatePositionPressed;
- (void)delegateCardPressed;
- (void)delegateVideoChatPressed;
- (void)delegateAudioChatPressed;
- (void)delegateCustomChatPressed;
- (void)delegateCustomFileTrans;

- (void)cancelRecording;
- (void)stopRecording;
- (void)startRecording;

@end