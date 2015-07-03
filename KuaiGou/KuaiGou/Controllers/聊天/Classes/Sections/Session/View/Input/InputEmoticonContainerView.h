//
//  InputEmoticonContainerView.h
//  NIM
//
//  Created by chrisRay on 15/2/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"
@class CustomPageControl;
@class EmoticonCatalog;
@class InputEmoticonTabView;

@protocol InputEmoticonProtocol <NSObject>

- (void)didPressSend:(id)sender;

- (void)selectedEmoticon:(NSString*)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description;

@end

@interface EmoticonConfigData : NSObject
@property (nonatomic, assign) NSInteger rows;               //行数
@property (nonatomic, assign) NSInteger columes;            //列数
@property (nonatomic, assign) NSInteger itemCountInPage;    //每页显示几项
@property (nonatomic, assign) CGFloat   cellWidth;          //单个单元格宽
@property (nonatomic, assign) CGFloat   cellHeight;         //单个单元格高
@property (nonatomic, assign) CGFloat   imageWidth;         //显示图片的宽
@property (nonatomic, assign) CGFloat   imageHeight;        //显示图片的高
@property (nonatomic, assign) BOOL      emoji;
@end

@interface InputEmoticonContainerView : UIView<PageViewDataSource,PageViewDelegate>

@property (nonatomic, strong)  PageView *emoticonPageView;
@property (nonatomic, strong)  UIPageControl  *emotPageController;
@property (nonatomic, strong)  EmoticonCatalog    *currentCatalogData;
@property (nonatomic, strong)  InputEmoticonTabView   *tabView;
@property (nonatomic, strong)  EmoticonConfigData *configData;
@property (nonatomic, weak)    id<InputEmoticonProtocol>  delegate;
@property (nonatomic, strong)  NSMutableArray               *emoticonDataArray;

@end
