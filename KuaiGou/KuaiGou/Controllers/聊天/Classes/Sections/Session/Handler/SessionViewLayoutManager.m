//
//  SessionViewLayoutManager.m
//  NIMDemo
//
//  Created by ght on 15-2-5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionViewLayoutManager.h"
#import "NIMInputViewDelegate.h"
#import "InputView.h"
#import "UITableView+ScrollToBottom.h"
#import "SessionViewCell.h"
#import "SessionMessageContentView.h"
#import "UIView+NIMDemo.h"

@interface SessionViewLayoutManager()<NIMInputViewDelegate>
{
    InputView *_inputView;
    UITableView *_tableview;
}
@end

@implementation SessionViewLayoutManager

-(instancetype)initWithInputView:(InputView*)inputView tableView:(UITableView*)tableview
{
    if (self = [self init]) {
        _inputView = inputView;
        _inputView.inputDelegate = self;
        _tableview = tableview;
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _tableview.height -= _inputView.height;
    }
    return self;
}

- (void)dealloc
{
    _inputView.inputDelegate = nil;
}

-(void)insertTableViewCellAtRows:(NSArray*)addIndexs
{
    if (!addIndexs.count) {
        return;
    }
    NSMutableArray *addIndexPathes = [NSMutableArray array];
    [addIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [addIndexPathes addObject:[NSIndexPath indexPathForRow:[obj integerValue] inSection:0]];
    }];
    [_tableview beginUpdates];
    [_tableview insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableview endUpdates];
    
    NSTimeInterval scrollDelay = .01f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(scrollDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableview scrollToRowAtIndexPath:[addIndexPathes lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

-(void)updateCellProgressAtIndex:(NSInteger)index  progress:(float)progress;
{
    if (index > -1) {
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if ([cell isKindOfClass:[SessionViewCell class]]) {
            [[(SessionViewCell*)cell bubbleView] updateProgress:progress];
        }
    }
}

-(void)updateCellUIAtIndex:(NSInteger)index message:(NIMMessage*)msg
{
    if (index > -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[SessionViewCell class]]) {
            [(SessionViewCell*)cell refreshSubStatusUI:msg];
        }
    }
}

-(void)deleteCellAtRows:(NSArray*)delIndexs
{
    NSMutableArray *delIndexPathes = [NSMutableArray array];
    [delIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [delIndexPathes addObject:[NSIndexPath indexPathForRow:[obj integerValue] inSection:0]];
    }];
    [_tableview beginUpdates];
    [_tableview deleteRowsAtIndexPaths:delIndexPathes withRowAnimation:UITableViewRowAnimationFade];
    [_tableview endUpdates];
}

-(void)reloadDataToIndex:(NSInteger)index withAnimation:(BOOL)animated
{
    if (index > -1) {
        [_tableview reloadData];
        [_tableview beginUpdates];
        [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
        [_tableview endUpdates];
    }
}

#pragma mark - NIMInputViewDelegate
//更改tableview布局
- (void)showInputView
{
    [_tableview setUserInteractionEnabled:NO];
}

- (void)hideInputView
{
    [_tableview setUserInteractionEnabled:YES];
}

- (void)inputViewSizeToHeight:(CGFloat)toHeight showInputView:(BOOL)show
{
    [_tableview setUserInteractionEnabled:!show];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = [_tableview frame];
        rect.origin.y = 0;
        rect.size.height = _viewRect.size.height - toHeight;
        [_tableview setFrame:rect];
        [_tableview scrollToBottom:NO];
    }];
}

@end
