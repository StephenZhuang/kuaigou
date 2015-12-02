//
//  AdScrollView.h
//  Appk_ProductShow
//
//  Created by wuxian on 13-6-6.
//  Copyright (c) 2013年 wuxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@interface AdScrollView : UIView<UIScrollViewDelegate> {
    UIScrollView *sv;
    StyledPageControl *page;

    NSArray *Arr;
    int TimeNum;
    BOOL Tend;
    
    NSTimer *_timer;
    NSArray *textArr;
}
@property (nonatomic , copy) void (^clickAtIndex)(NSInteger index);
- (void)configUIWithArray:(NSArray *)array;
@end
