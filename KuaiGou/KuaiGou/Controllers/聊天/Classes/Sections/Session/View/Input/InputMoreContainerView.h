//
//  InputMoreContainerView.h
//  NIMDemo
//
//  Created by ght on 15-1-30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSDK.h"
#import "NIMInputViewDelegate.h"

typedef NS_ENUM(NSInteger, InputMoreButtonType)
{
    MediaButtonPicture = 0,    //相册
    MediaButtonShoot,          //拍摄
    MediaButtonPosition,       //位置
    MediaButtonCard,           //名片
    MediaButtonCustom,         //自定义
    MediaButtonVideoChat,      //视频语音通话
    MediaButtonAudioChat,      //免费通话
    MediaButtonFileTrans,      //文本传输
};


@interface CustomMediaButtonData : NSObject
@property (nonatomic, strong) NSString *imageNormalFileName;
@property (nonatomic, strong) NSString *imagePressedFileName;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, assign) NSInteger buttonType;

- (id)initCustomMediaButtonData:(NSString*)normalFileName
                pressedFileName:(NSString*)pressedFileName
                          title:(NSString*)title
                           type:(NSInteger)type;
@end


@protocol InputMoreContainerDataSource <NSObject>

@optional
-(NSArray*)moreBtnArrayForInputView; //支持的+

@end

@interface InputMoreContainerView : UIView

@property (nonatomic, weak) id<InputActionDelegate> delegate;
@property (nonatomic, weak) id<InputMoreContainerDataSource> dataSource;


@end
