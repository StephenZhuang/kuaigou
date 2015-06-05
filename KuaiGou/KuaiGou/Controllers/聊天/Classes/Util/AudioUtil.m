//
//  AudioUtil.m
//  NIM
//
//  Created by chrisRay on 15/5/15.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "AudioUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioFile.h>

@implementation AudioUtil

+ (BOOL)setDefaultSpeakerMode:(BOOL)defaultToSpeaker
{
    if (AVAudioSession.sharedInstance.category != AVAudioSessionCategoryPlayAndRecord) {
        NSLog(@"the category does not support speaker mode setting");
        return NO;
    }
    AVAudioSessionCategoryOptions currentOptions = AVAudioSession.sharedInstance.categoryOptions;
    AVAudioSessionCategoryOptions newOption;
    if (defaultToSpeaker) {
        newOption = currentOptions | AVAudioSessionCategoryOptionDefaultToSpeaker;
    }
    else {
        newOption = currentOptions & ~AVAudioSessionCategoryOptionDefaultToSpeaker;
    }
    
    if (newOption == currentOptions) {
        return YES;
    }
    
    NSString *oldMode = AVAudioSession.sharedInstance.mode;
    
    NSError *err;
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                                    withOptions:newOption
                                                          error:&err];
    if (!success) {
        NSLog(@"error setting speaker option:%@", [err localizedDescription]);
    }
    
    NSString *newMode = AVAudioSession.sharedInstance.mode;
    
    if (newMode != oldMode) {
        [AudioUtil setAudioMode:oldMode];
    }
    return success;
}

+ (BOOL)setAudioMode:(NSString *)mode
{
    NSString *currentMode = AVAudioSession.sharedInstance.mode;
    if (currentMode == mode) {
        NSLog(@"is the specified mode already");
        return YES;
    }
    
    NSError *err;
    BOOL success = [[AVAudioSession sharedInstance] setMode:mode error:&err];
    
    if (!success) {
        NSLog(@"couldn't set audio mode: %@", [err localizedDescription]);
    }
    
    return success;
}

@end
