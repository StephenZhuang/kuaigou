//
//  InputEmoticonTabView.h
//  NIM
//
//  Created by chrisRay on 15/2/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputEmoticonTabView : UIView

@property (nonatomic,readonly) NSArray *emoticonCatalogs;

@property (nonatomic,strong) UIButton * sendButton;

- (instancetype)initWithCatalogs:(NSArray*)emoticonCatalogs;

@end
