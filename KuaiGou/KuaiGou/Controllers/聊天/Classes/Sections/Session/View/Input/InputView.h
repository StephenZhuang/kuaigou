//
//  InputView.h
//  NIMDemo
//
//  Created by ght on 15-1-21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMTextView.h"
#import "NIMInputViewDelegate.h"
#import "NIMSDK.h"

extern NSInteger NIMInputOffset;
extern NSInteger NIMActionIconWidth;
extern NSInteger TopInputViewHeight;
extern NSInteger ButtomInputViewHeight;

typedef NS_ENUM(NSInteger, InputType){
    InputTypeText = 1,
    InputTypeEmot = 2,
    InputTypeAudio = 3,
    InputTypeMedia = 4,
};

typedef NS_ENUM(NSInteger, AudioRecordPhase) {
    AudioRecordPhaseStart,
    AudioRecordPhaseRecording,
    AudioRecordPhaseCancelling,
    AudioRecordPhaseEnd
};

@class InputMoreContainerView;
@class InputEmoticonContainerView;

@interface InputView : UIView

@property (nonatomic, weak) id<NIMInputViewDelegate> inputDelegate;
@property (nonatomic, weak) id<InputActionDelegate> actionDelegate;
@property (nonatomic, assign) NIMSessionType sessionType;
@property (nonatomic, assign) NSInteger             maxTextLength;
@property (nonatomic, assign) CGFloat              inputBottomViewHeight;

@property (strong, nonatomic) IBOutlet UIView *inputTopView;
@property (strong, nonatomic) IBOutlet UIImageView *inputTopBgView;
@property (strong, nonatomic) IBOutlet NIMTextView *inputTextView;
@property (strong, nonatomic) IBOutlet UIButton *VoiceBtn;
@property (strong, nonatomic) IBOutlet UIButton *emotionBtn;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (assign, nonatomic, getter=isRecording) BOOL recording;

//更多输入
@property (strong, nonatomic)  InputMoreContainerView *moreContainer;
@property (strong, nonatomic)  InputEmoticonContainerView *emotionContainer;

@property (strong, nonatomic) IBOutlet UIButton *moreMediaBtn;


- (id)initWithFrame:(CGRect)frame sessionType:(NIMSessionType)sessionType;

//外部设置
- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
- (void)updateAudioRecordTime:(NSTimeInterval)time;
- (void)updateVoicePower:(float)power;
@end
