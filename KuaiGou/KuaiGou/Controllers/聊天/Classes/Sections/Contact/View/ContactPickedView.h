//
//  ContactPickedView.h
//  NIM
//
//  Created by ios on 10/23/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDefines.h"

@protocol ContactPickedViewDelegate <NSObject>

- (void)removeUser:(NSString *)userId;

@end

@interface ContactPickedView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<ContactPickedViewDelegate> delegate;

- (void)removeUser:(NSString *)userId;
- (void)addUser:(id<ContactItem>)usr;

@end
