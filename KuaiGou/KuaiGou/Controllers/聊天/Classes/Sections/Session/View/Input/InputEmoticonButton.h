//
//  InputEmoticonButton.h
//  NIM
//
//  Created by chrisRay on 15/2/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emoticon;

@protocol EmoticonButtonTouchDelegate <NSObject>

- (void)selectedEmoticon:(Emoticon*)emoticon catalogID:(NSString*)catalogID;

@end



@interface InputEmoticonButton : UIButton

@property (nonatomic, strong) Emoticon     *emoticonData;

@property (nonatomic, copy)   NSString     *catalogID;

@property (nonatomic, weak)   id<EmoticonButtonTouchDelegate> delegate;

+ (InputEmoticonButton*)iconButtonWithData:(Emoticon*)data catalogID:(NSString*)catalogID delegate:( id<EmoticonButtonTouchDelegate>)delegate;

- (void)onIconSelected:(id)sender;

@end
