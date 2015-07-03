//
//  AudioRecordIndicatorView.m
//  NIM
//
//  Created by Xuhui on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#define kViewWidth 160
#define kViewHeight 110

#define kTimeFontSize 30
#define kTipFontSize 15

#import "AudioRecordIndicatorView.h"

@interface AudioRecordIndicatorView () {
    UIImageView *_backgrounView;
    UIImageView *_tipBackgroundView;
}

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation AudioRecordIndicatorView

- (instancetype)init {
    self = [super init];
    if(self) {
        
        self.frame = CGRectMake(0, 0, kViewWidth, kViewHeight);
        
        _backgrounView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_audio_record_indicator_background"]];
        [self addSubview:_backgrounView];
        
        _tipBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_audio_record_indicator_cancel_tip_background"]];
        _tipBackgroundView.hidden = YES;
        _tipBackgroundView.frame = CGRectMake(0, kViewHeight - CGRectGetHeight(_tipBackgroundView.bounds), kViewWidth, CGRectGetHeight(_tipBackgroundView.bounds));
        [self addSubview:_tipBackgroundView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:kTimeFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:kTipFontSize];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"手指上滑，取消发送";
        [self addSubview:_tipLabel];
        
        self.phase = AudioRecordPhaseEnd;
    }
    return self;
}

- (void)setRecordTime:(NSTimeInterval)recordTime {
    NSInteger minutes = (NSInteger)recordTime / 60;
    NSInteger seconds = (NSInteger)recordTime % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minutes, seconds];
}

- (void)setPhase:(AudioRecordPhase)phase {
    if(phase == AudioRecordPhaseStart) {
        [self setRecordTime:0];
    } else if(phase == AudioRecordPhaseCancelling) {
        _tipLabel.text = @"松开手指，取消发送";
        _tipBackgroundView.hidden = NO;
    } else {
        _tipLabel.text = @"手指上滑，取消发送";
        _tipBackgroundView.hidden = YES;
    }
}

- (void)layoutSubviews {
    CGSize size = [_timeLabel sizeThatFits:CGSizeMake(kViewWidth, MAXFLOAT)];
    _timeLabel.frame = CGRectMake(0, 36, kViewWidth, size.height);
    
    size = [_tipLabel sizeThatFits:CGSizeMake(kViewWidth, MAXFLOAT)];
    _tipLabel.frame = CGRectMake(0, kViewHeight - 10 - size.height, kViewWidth, size.height);
}

@end
