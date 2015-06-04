//
//  SessionViewLayoutManager.h
//  NIMDemo
//
//  Created by ght on 15-2-5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SessionLogicDelegate.h"

@class InputView;
@class NIMMessage;
@interface SessionViewLayoutManager : NSObject
@property (nonatomic, assign) CGRect viewRect;
-(instancetype)initWithInputView:(InputView*)inputView tableView:(UITableView*)tableview;

-(void)insertTableViewCellAtRows:(NSArray*)addIndexs;
-(void)updateCellProgressAtIndex:(NSInteger)index progress:(float)progress;
-(void)updateCellUIAtIndex:(NSInteger)index message:(NIMMessage*)msg;
-(void)deleteCellAtRows:(NSArray*)delIndexs;
-(void)reloadDataToIndex:(NSInteger)index withAnimation:(BOOL)animated;
@end
