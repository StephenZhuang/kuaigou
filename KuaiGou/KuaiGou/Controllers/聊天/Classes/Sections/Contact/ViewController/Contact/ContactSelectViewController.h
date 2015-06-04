//
//  ContactSelectViewController.h
//  NIM
//
//  Created by Xuhui on 15/3/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ContactSelectFinishBlock)(NSArray *);
typedef void(^ContactSelectCancelBlock)(void);

@class GroupedDataCollection;

@protocol ContactSelectDelegate <NSObject>

- (void)didFinishedSelect:(NSArray *)selectedContacts; // 返回userID
- (void)didCancelledSelect;

@end

@interface ContactSelectViewController : UIViewController

@property (nonatomic, weak) id<ContactSelectDelegate> delegate;
@property (nonatomic, strong) GroupedDataCollection *dataCollection;
@property (nonatomic, assign) NSInteger maxSelectCount;
@property (nonatomic, copy) ContactSelectFinishBlock finshBlock;
@property (nonatomic, copy) ContactSelectCancelBlock cancelBlock;
@end
