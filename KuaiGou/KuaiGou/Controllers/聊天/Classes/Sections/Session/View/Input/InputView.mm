//
//  InputView.m
//  NIMDemo
//
//  Created by ght on 15-1-21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "InputView.h"
#import <AVFoundation/AVFoundation.h>
#import "InputMoreContainerView.h"
#import "InputEmoticonContainerView.h"
#import "SessionCellLayoutConstant.h"
#import "UIView+NIMDemo.h"
#import "EmoticonManager.h"
#import "AudioRecordIndicatorView.h"
#import "NSString+NIMDemo.h"

NSInteger NIMInputOffset = 4;
NSInteger NIMActionIconWidth = 35;
NSInteger TopInputViewHeight = 46;
NSInteger ButtomInputViewHeight = 216;
NSInteger LevelmeterViewHeight = 100;

@interface InputView()<UITextViewDelegate,InputMoreContainerDataSource,InputEmoticonProtocol>
{
    UIView  *_emotionView; //
    InputType  _inputType;
    CGFloat   _inputTextViewOlderHeight;
}

@property (nonatomic, strong) AudioRecordIndicatorView *audioRecordIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *inputTextBkgImage;
@property (nonatomic, assign) AudioRecordPhase recordPhase;

@end


@implementation InputView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"InputView" owner:nil options:nil] lastObject];
    if (self) {
        [self setFrame:frame];
        _recording = NO;
        _recordPhase = AudioRecordPhaseEnd;
        [self initUIComponents];
    }
    return self;
}

- (AudioRecordIndicatorView *)audioRecordIndicator {
    if(!_audioRecordIndicator) {
        _audioRecordIndicator = [[AudioRecordIndicatorView alloc] init];
    }
    return _audioRecordIndicator;
}

- (void)setRecordPhase:(AudioRecordPhase)recordPhase {
    AudioRecordPhase prevPhase = _recordPhase;
    _recordPhase = recordPhase;
    self.audioRecordIndicator.phase = _recordPhase;
    if(prevPhase == AudioRecordPhaseEnd) {
        if(AudioRecordPhaseStart == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(startRecording)]) {
                [_actionDelegate startRecording];
            }
        }
    } else if (prevPhase == AudioRecordPhaseStart || prevPhase == AudioRecordPhaseRecording) {
        if (AudioRecordPhaseEnd == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(stopRecording)]) {
                [_actionDelegate stopRecording];
            }
        }
    } else if (prevPhase == AudioRecordPhaseCancelling) {
        if(AudioRecordPhaseEnd == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(cancelRecording)]) {
                [_actionDelegate cancelRecording];
            }
        }
    }
}

- (void)initUIComponents
{
    [_inputTopBgView setImage:[[UIImage imageNamed:@"input_top_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(23,1,23,1) resizingMode:UIImageResizingModeStretch]];
    _inputTextView.delegate = self;
   [_inputTextBkgImage setImage:[[UIImage imageNamed:@"input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch]];

    [_inputTextView setCustomUI];
    [_inputTextView setPlaceHolder:@"请输入消息"];
    _inputType = InputTypeText;
    _inputBottomViewHeight = 0;
    _inputTextViewOlderHeight = TopInputViewHeight;
    [_recordButton setHidden:YES];
    [self addListenEvents];
    
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_recordButton setBackgroundImage:[[UIImage imageNamed:@"input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    
    _moreContainer = [[InputMoreContainerView alloc] initWithFrame:CGRectMake(0, TopInputViewHeight, UIScreenWidth, ButtomInputViewHeight)];
    _moreContainer.dataSource = self;
    _moreContainer.hidden = YES;
    [self addSubview:_moreContainer];
    
    _emotionContainer = [[InputEmoticonContainerView alloc] initWithFrame:CGRectMake(0, TopInputViewHeight, UIScreenWidth, ButtomInputViewHeight)];
    _emotionContainer.delegate = self;
    _emotionContainer.hidden = YES;
    [self addSubview:_emotionContainer];
}


- (void)setActionDelegate:(id<InputActionDelegate>)actionDelegate{
    _actionDelegate = actionDelegate;
    _moreContainer.delegate = actionDelegate;
}

- (void)layoutSubviews
{
    _inputTextBkgImage.frame = _inputTextView.frame;
    [super layoutSubviews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _moreContainer.dataSource = nil;
    _moreContainer.delegate = nil;
    _emotionContainer.delegate = nil;
    _inputTextView.delegate = nil;
}

- (void)setRecording:(BOOL)recording {
    if(recording) {
        self.audioRecordIndicator.center = self.superview.center;
        [self.superview addSubview:self.audioRecordIndicator];
        self.recordPhase = AudioRecordPhaseRecording;
    } else {
        [self.audioRecordIndicator removeFromSuperview];
    }
    _recording = recording;
}

#pragma mark - 外部接口
- (void)setInputTextPlaceHolder:(NSString*)placeHolder
{
    [_inputTextView setPlaceHolder:placeHolder];
}

- (void)updateAudioRecordTime:(NSTimeInterval)time {
    self.audioRecordIndicator.recordTime = time;
}

- (void)updateVoicePower:(float)power {
    
}

#pragma mark - private methods
- (void)addListenEvents
{
    // 显示键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)updateAllButtonImages
{
    if (_inputType == InputTypeText || _inputType == InputTypeMedia)
    {
        [self updateVoiceBtnImages:YES];
        [self updateEmotAndTextBtnImages:YES];
        [_recordButton setHidden:YES];
        [_inputTextView setHidden:NO];
        [_inputTextBkgImage setHidden:NO];
    }
    else if(_inputType == InputTypeAudio)
    {
       [self updateVoiceBtnImages:NO];
        [self updateEmotAndTextBtnImages:YES];
        [_recordButton setHidden:NO];
        [_inputTextView setHidden:YES];
        [_inputTextBkgImage setHidden:YES];
    }
    else
    {
       [self updateVoiceBtnImages:YES];
        [self updateEmotAndTextBtnImages:YES];
        [_recordButton setHidden:YES];
        [_inputTextView setHidden:NO];
        [_inputTextBkgImage setHidden:NO];
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return IOS7 ? ceilf([textView sizeThatFits:textView.frame.size].height):textView.contentSize.height;
}

- (void)updateVoiceBtnImages:(BOOL)selected
{
    [_VoiceBtn setImage:selected?[UIImage imageNamed:@"ToolViewInputVoice"]:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
    [_VoiceBtn setImage:selected?[UIImage imageNamed:@"ToolViewInputVoiceHL"]:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
}

- (void)updateEmotAndTextBtnImages:(BOOL)selected
{
    [_emotionBtn setImage:selected?[UIImage imageNamed:@"ToolViewEmotion"]:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
    [_emotionBtn setImage:selected?[UIImage imageNamed:@"ToolViewEmotion_Pressed"]:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    toFrame.origin.y -= _inputBottomViewHeight;
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height];
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.inputTopView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.inputTopView.frame.size.height)
    {
        return;
    }
    self.frame = toFrame;
    
    if (bottomHeight == 0) {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(hideInputView)]) {
            [self.inputDelegate hideInputView];
        }
    } else
    {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(showInputView)]) {
            [self.inputDelegate showInputView];
        }
    }
    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
        [self.inputDelegate inputViewSizeToHeight:toHeight showInputView:!(bottomHeight==0)];
    }
}

- (void)inputTextViewToHeight:(CGFloat)toHeight
{
    toHeight = MAX(TopInputViewHeight, toHeight);
    toHeight = MIN(ButtomInputViewHeight, toHeight);
    
    if (toHeight != _inputTextViewOlderHeight)
    {
        CGFloat changeHeight = toHeight - _inputTextViewOlderHeight;
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.inputTopView.frame;
        rect.size.height += changeHeight;
        [self updateInputTopViewFrame:rect];
        
        if (IOS7 && self.inputTextView.text.length) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _inputTextViewOlderHeight = toHeight;
        
        if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
            [_inputDelegate inputViewSizeToHeight:self.frame.size.height showInputView:YES];
        }
    }
}

- (void)updateInputTopViewFrame:(CGRect)rect
{
    self.inputTopView.frame = rect;
    _inputTextView.frame = CGRectMake(_inputTextView.left, _inputTextView.top, _inputTextView.width, CGRectGetHeight(rect)-_inputTextView.top*2);
    _inputTopBgView.frame = self.inputTopView.bounds;
    _VoiceBtn.centerY = CGRectGetHeight(rect)/2;
    _emotionBtn.centerY = _VoiceBtn.centerY;
    _moreMediaBtn.centerY = _VoiceBtn.centerY;
    _recordButton.centerY = _VoiceBtn.centerY;
    _moreContainer.top = _inputTopBgView.bottom;
    _emotionContainer.top = _inputTopBgView.bottom;
}


#pragma mark - button actions
- (IBAction)onTouchVoiceBtn:(id)sender {
    // image change
    if (_inputType!= InputTypeAudio) {
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _inputType = InputTypeAudio;
                        if ([self.inputTextView isFirstResponder]) {
                            _inputBottomViewHeight = 0;
                            [self.inputTextView resignFirstResponder];
                        } else if (_inputBottomViewHeight > 0)
                        {
                            _inputBottomViewHeight = 0;
                            [self willShowBottomHeight:_inputBottomViewHeight];
                        }
                        [self inputTextViewToHeight:TopInputViewHeight];;
                        [self updateAllButtonImages];
                    });
                }
                else {
                    DDLogError(@"Microphone is disabled..");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                     message:@"没有麦克风权限"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    } else
    {
        _inputType = InputTypeText;
        [self inputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        [self.inputTextView becomeFirstResponder];
        [self updateAllButtonImages];
    }
}

- (IBAction)onTouchRecordBtnDown:(id)sender {
    // start Recording
    DDLogDebug(@"%@", @"record");
    self.recordPhase = AudioRecordPhaseStart;
}
- (IBAction)onTouchRecordBtnUpInside:(id)sender {
    // finish Recording
    DDLogDebug(@"%@", @"record finish");
    self.recordPhase = AudioRecordPhaseEnd;
}
- (IBAction)onTouchRecordBtnUpOutside:(id)sender {
    //TODO cancel Recording
    DDLogDebug(@"%@", @"record cancel");
    self.recordPhase = AudioRecordPhaseEnd;
}

- (IBAction)onTouchRecordBtnDragInside:(id)sender {
    //TODO @"手指上滑，取消发送"
    DDLogDebug(@"%@", @"drag in");
    self.recordPhase = AudioRecordPhaseRecording;
}
- (IBAction)onTouchRecordBtnDragOutside:(id)sender {
    //TODO @"松开手指，取消发送"
    DDLogDebug(@"%@", @"drag out");
    self.recordPhase = AudioRecordPhaseCancelling;
}


- (IBAction)onTouchEmotionBtn:(id)sender
{
    if (_inputType != InputTypeEmot) {
        _inputType = InputTypeEmot;
        _inputBottomViewHeight = ButtomInputViewHeight;
        [self bringSubviewToFront:_emotionContainer];
        [_moreContainer setHidden:YES];
        [_emotionContainer setHidden:NO];
        if ([self.inputTextView isFirstResponder]) {
            [self.inputTextView resignFirstResponder];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self willShowBottomHeight:_inputBottomViewHeight];
        }];
    }else
    {
        _inputBottomViewHeight = 0;
        _inputType = InputTypeText;
        [self.inputTextView becomeFirstResponder];
    }
    [self updateAllButtonImages];
}

- (IBAction)onTouchMoreBtn:(id)sender {
    if (_inputType != InputTypeMedia) {
        _inputType = InputTypeMedia;
        [self bringSubviewToFront:_moreContainer];
        [_moreContainer setHidden:NO];
        [_emotionContainer setHidden:YES];
        _inputBottomViewHeight = ButtomInputViewHeight;
        if ([self.inputTextView isFirstResponder]) {
            [self.inputTextView resignFirstResponder];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self willShowBottomHeight:_inputBottomViewHeight];
        }];
    } else
    {
        _inputBottomViewHeight = 0;
        _inputType = InputTypeText;
        [self.inputTextView becomeFirstResponder];
    }
    [self updateAllButtonImages];
}

- (BOOL)endEditing:(BOOL)force
{
    BOOL endEditing = [super endEditing:force];
    if (![_inputTextView isFirstResponder]) {
        _inputBottomViewHeight = 0.0;
        [self willShowBottomHeight:0.0];
    }
    return endEditing;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
//        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
//    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _inputType = InputTypeText;
    [textView becomeFirstResponder];
    
//    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
//        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.actionDelegate respondsToSelector:@selector(sendTextMessage:)] && [textView.text length] > 0) {
            [self.actionDelegate sendTextMessage:textView.text];
            self.inputTextView.text = @"";
            [self inputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
        return NO;
    }
    NSString *str = [textView.text stringByAppendingString:text];
    if (str.length > self.maxTextLength) {
        return NO;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTextChanged:)])
    {
        [self.actionDelegate onTextChanged:self];
    }
    [self inputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - InputMoreContainerDataSource
- (NSArray*)moreBtnArrayForInputView
{
    NSMutableArray *moreBtnsData = [NSMutableArray array];
    
    CustomMediaButtonData *picBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"bk_media_picture_normal" pressedFileName:@"bk_media_picture_nomal_pressed" title:NSLocalizedString(@"相册",nil) type:MediaButtonPicture];
    [moreBtnsData addObject:picBtnData];
    
    CustomMediaButtonData *shootBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"bk_media_shoot_normal" pressedFileName:@"bk_media_shoot_pressed" title:NSLocalizedString( @"拍摄",nil) type:MediaButtonShoot];
    [moreBtnsData addObject:shootBtnData];
    
    CustomMediaButtonData *locationBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"bk_media_position_normal" pressedFileName:@"bk_media_position_pressed" title:NSLocalizedString(@"位置",nil) type:MediaButtonPosition];
    [moreBtnsData addObject:locationBtnData];
    
    CustomMediaButtonData *cardBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"bk_media_card_normal" pressedFileName:@"bk_media_card_pressed" title:NSLocalizedString(@"名片", nil) type:MediaButtonCard];
    [moreBtnsData addObject:cardBtnData];
    
    CustomMediaButtonData *customBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"bk_media_picture_normal" pressedFileName:@"bk_media_picture_nomal_pressed" title:NSLocalizedString(@"自定义消息", nil) type:MediaButtonCustom];
    [moreBtnsData addObject:customBtnData];


    if (_sessionType == NIMSessionTypeP2P) {
        CustomMediaButtonData *telphoneBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"btn_media_telphone_message_normal" pressedFileName:@"btn_media_telphone_message_pressed" title:@"实时语音" type:MediaButtonAudioChat];
        [moreBtnsData addObject:telphoneBtnData];
        
        CustomMediaButtonData *videoChatBtnData = [[CustomMediaButtonData alloc] initCustomMediaButtonData:@"btn_bk_media_video_chat_normal" pressedFileName:@"btn_bk_media_video_chat_pressed" title:@"视频通话" type:MediaButtonVideoChat];
        [moreBtnsData addObject:videoChatBtnData];
    }
    
    return moreBtnsData;
}

#pragma mark - InputEmoticonProtocol
- (void)selectedEmoticon:(NSString*)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description{
    if (!emotCatalogID) { //删除键
        NSRange range = [self rangeForEmoticon];
        [self deleteTextRange:range];
    }else{
        [_inputTextView insertText:description];
    }
}

- (void)didPressSend:(id)sender{
    if ([self.actionDelegate respondsToSelector:@selector(sendTextMessage:)] && [self.inputTextView.text length] > 0) {
        [self.actionDelegate sendTextMessage:self.inputTextView.text];
        self.inputTextView.text = @"";
        [self inputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
    }
}

- (void)deleteTextRange: (NSRange)range
{
    NSString *text = [self.inputTextView text];
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        [self.inputTextView setText:newText];
        [self.inputTextView setSelectedRange:newSelectRange];
    }
}

- (NSRange)rangeForEmoticon
{
    NSString *text = [self.inputTextView text];
    NSRange range = [self.inputTextView selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation =range.location;
    if (endLocation <= 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    if ([selectedText hasSuffix:@"]"]) {
        for (NSInteger i = endLocation; i >= endLocation - 4 && i-1 >= 0 ; i--)
        {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:@"["] == NSOrderedSame)
            {
                index = i - 1;
                break;
            }
        }
    }
    if (index == -1)
    {
        return NSMakeRange(endLocation - 1, 1);
    }
    else
    {
        NSRange emoticonRange = NSMakeRange(index, endLocation - index);
        NSString *name = [text substringWithRange:emoticonRange];
        Emoticon *icon = [[EmoticonManager sharedManager] emoticonByTag:name];
        return icon ? emoticonRange : NSMakeRange(endLocation - 1, 1);
    }
}

@end
