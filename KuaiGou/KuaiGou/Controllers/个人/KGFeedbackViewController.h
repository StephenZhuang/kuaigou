//
//  KGFeedbackViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGBaseViewController.h"

@interface KGFeedbackViewController : KGBaseViewController<UITextViewDelegate>
@property (nonatomic , weak) IBOutlet UITextView *textView;
@end
