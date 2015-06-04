//
//  ContactDefines.h
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef NIM_ContactDefines_h
#define NIM_ContactDefines_h

#import "UsrInfoData.h"

@protocol ContactItemCollection <NSObject>
@required
//显示的title名
- (NSString*)title;

//返回集合里的成员
- (NSArray*)members;

//重用id
- (NSString*)reuseId;

//需要构造的cell类名
- (NSString*)cellName;

@end

@protocol ContactItem <UsrInfoProtocol>
@required
//userId和Vcname必有一个有值，根据有值的状态push进不同的页面
- (NSString*)vcName;

//返回行高
- (CGFloat)uiHeight;

//重用id
- (NSString*)reuseId;

//需要构造的cell类名
- (NSString*)cellName;

@end

@protocol ContactCell <NSObject>

- (void)refreshWithContactItem:(id<ContactItem>)item;

@end

#endif


#ifndef NIM_ContactCellLayoutConstant_h
#define NIM_ContactCellLayoutConstant_h
static const CGFloat   ContactUtilRowHeight         = 50;  //util类Cell行高
static const CGFloat   ContactDataRowHeight         = 50;  //data类Cell行高
static const NSInteger ContactAvatarLeft            = 10;  //头像到左边的距离
static const NSInteger ContactAvatarAndTitleSpacing = 20;  //头像和文字之间的间距

#endif

