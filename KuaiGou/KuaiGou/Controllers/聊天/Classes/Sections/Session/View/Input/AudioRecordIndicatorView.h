//
//  AudioRecordIndicatorView.h
//  NIM
//
//  Created by Xuhui on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"

@interface AudioRecordIndicatorView : UIView

@property (nonatomic, assign) AudioRecordPhase phase;
@property (nonatomic, assign) NSTimeInterval recordTime;

@end
