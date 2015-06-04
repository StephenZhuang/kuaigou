//
//  NIMTextView.h
//  NIMDemo
//
//  Created by ght on 15-1-22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMTextView : UITextView

@property (nonatomic, strong) NSString *placeHolder;

- (void)setCustomUI;
@end
