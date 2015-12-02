//
//  KGTextViewCell.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface KGTextViewCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *textView;
@end
