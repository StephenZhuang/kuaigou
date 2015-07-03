//
//  InputEmoticonContainerView.m
//  NIM
//
//  Created by chrisRay on 15/2/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "InputEmoticonContainerView.h"
#import "PageView.h"
#import "UIView+NIMDemo.h"
#import "InputEmoticonButton.h"
#import "EmoticonManager.h"
#import "InputEmoticonTabView.h"

extern NSInteger ButtomInputViewHeight;
NSInteger CustomPageControlHeight = 36;
NSInteger CustomPageViewHeight    = 159;

NSInteger EmojiLeftMargin      = 8;
NSInteger EmojiRightMargin     = 8;
NSInteger EmojiTopMargin       = 14;

CGFloat   EmojCellHeight    = 46.0;
NSInteger EmojImageHeight   = 43.0;
NSInteger EmojImageWidth    = 43.0;
NSInteger DeleteIconWidth   = 43.0;
NSInteger DeleteIconHeight  = 43.0;
NSInteger EmojRows          = 3;
#define EmojColumns ((UIScreenWidth - EmojiLeftMargin - EmojiRightMargin) / EmojImageWidth)

@implementation EmoticonConfigData

- (id)initConfigData
{
    self = [super init];
    if (self)
    {
        _rows            = EmojRows;
        _columes         = EmojColumns;
        _itemCountInPage = _rows * _columes -1;
        _cellWidth       = (UIScreenWidth - EmojiLeftMargin - EmojiRightMargin) / _columes;
        _cellHeight      = EmojCellHeight;
        _imageWidth      = EmojImageWidth;
        _imageHeight     = EmojImageHeight;
        _emoji           = YES;
    }
    return self;
}

@end


@interface InputEmoticonContainerView()<EmoticonButtonTouchDelegate>

@end


@implementation InputEmoticonContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadConfig];
        [self loadUIComponents];
    }
    return self;
}

- (void)loadConfig{
    self.backgroundColor = [UIColor clearColor];
    self.configData = [[EmoticonConfigData alloc] initConfigData];
}

- (void)loadUIComponents
{
    _emoticonPageView                  = [[PageView alloc] initWithFrame:self.bounds];
    _emoticonPageView.height           = CustomPageViewHeight;
    _emoticonPageView.backgroundColor  = [UIColor clearColor];
    _emoticonPageView.dataSource       = self;
    _emoticonPageView.pageViewDelegate = self;
    [self addSubview:_emoticonPageView];
    
    _emotPageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.width, CustomPageControlHeight)];
    _emotPageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    _emotPageController.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_emotPageController];
    [_emotPageController setUserInteractionEnabled:NO];
    
    EmoticonCatalog * defaultCatalog = [self loadDefaultCatalog];
    
    _tabView = [[InputEmoticonTabView alloc] initWithCatalogs:@[defaultCatalog]];
    [_tabView.sendButton addTarget:self action:@selector(didPressSend:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tabView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.emotPageController.top = self.emoticonPageView.bottom;
    self.tabView.bottom = self.height;
}



#pragma mark -  config data
- (NSInteger)currentPages
{
    NSInteger currentPageIndex = 0;
    for(int i = 0; i < [self.emoticonDataArray indexOfObject:_currentCatalogData];i++)
    {
        currentPageIndex += ((EmoticonCatalog*)[self.emoticonDataArray objectAtIndex:i]).pagesCount;
    }
    currentPageIndex = MIN(currentPageIndex, [self sumPages]-1);
    return currentPageIndex;
}

- (NSInteger)sumPages
{
    __block NSInteger pagesCount = 0;
    [self.emoticonDataArray enumerateObjectsUsingBlock:^(EmoticonCatalog* data, NSUInteger idx, BOOL *stop) {
        //
        pagesCount += data.pagesCount;
    }];
    return pagesCount;
}


- (UIView*)emojPageView:(PageView*)pageView beginItem:(NSInteger)begin endItem:(NSInteger)end
{
    UIView *subView = [[UIView alloc] init];
    NSInteger iconHeight    = self.configData.imageHeight;
    NSInteger iconWidth     = self.configData.imageWidth;
    CGFloat startX          = (self.configData.cellWidth - iconWidth) / 2  + EmojiLeftMargin;
    CGFloat startY          = (self.configData.cellHeight- iconHeight) / 2 + EmojiTopMargin;
    int32_t coloumnIndex = 0;
    int32_t rowIndex = 0;
    int32_t indexInPage = 0;
    for (NSInteger index = begin; index < end; index ++)
    {
        Emoticon *data = [self.currentCatalogData.emoticons objectAtIndex:index];

        InputEmoticonButton *button = [InputEmoticonButton iconButtonWithData:data catalogID:self.currentCatalogData.catalogID delegate:self];
        //计算表情位置
        rowIndex    = indexInPage / self.configData.columes;
        coloumnIndex= indexInPage % self.configData.columes;
        CGFloat x = coloumnIndex * self.configData.cellWidth + startX;
        CGFloat y = rowIndex * self.configData.cellHeight + startY;
        CGRect iconRect = CGRectMake(x, y, iconWidth, iconHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
        indexInPage ++;
        if (indexInPage == end)
        {
            [self addDeleteEmotButtonToView:subView ColumnIndex:coloumnIndex RowIndex:rowIndex StartX:startX StartY:startY IconWidth:iconWidth IconHeight:iconHeight];
        }
    }
    if (coloumnIndex == self.configData.columes -1)
    {
        rowIndex = rowIndex +1;
        coloumnIndex = -1; //设置成-1是因为显示在第0位，有加1
    }
    [self addDeleteEmotButtonToView:subView  ColumnIndex:coloumnIndex RowIndex:rowIndex StartX:startX StartY:startY IconWidth:iconWidth IconHeight:iconHeight];
    return subView;
}

- (void)addDeleteEmotButtonToView:(UIView *)view
                      ColumnIndex:(NSInteger)coloumnIndex
                         RowIndex:(NSInteger)rowIndex
                           StartX:(CGFloat)startX
                           StartY:(CGFloat)startY
                        IconWidth:(CGFloat)iconWidth
                       IconHeight:(CGFloat)iconHeight
{
    InputEmoticonButton* deleteIcon = [[InputEmoticonButton alloc] init];
    deleteIcon.delegate = self;
    deleteIcon.userInteractionEnabled = YES;
    deleteIcon.exclusiveTouch = YES;
    deleteIcon.contentMode = UIViewContentModeCenter;
    UIImage *imageNormal = [UIImage imageNamed:@"emoji_del_normal.png"];
    UIImage *imagePressed = [UIImage imageNamed:@"emoji_del_pressed.png"];
    [deleteIcon setImage:imageNormal forState:UIControlStateNormal];
    [deleteIcon setImage:imagePressed forState:UIControlStateHighlighted];
    [deleteIcon addTarget:deleteIcon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat newX = (coloumnIndex +1) * self.configData.cellWidth + startX;
    CGFloat newY = rowIndex * self.configData.cellHeight + startY;
    CGRect deleteIconRect = CGRectMake(newX, newY, DeleteIconWidth, DeleteIconHeight);
    
    [deleteIcon setFrame:deleteIconRect];
    [view addSubview:deleteIcon];
}


#pragma mark - pageviewDelegate
- (NSInteger)numberOfPages: (PageView *)pageView
{
    return [self sumPages];
}

- (UIView *)pageView:(PageView *)pageView viewInPage:(NSInteger)index
{
    index -= [self currentPages];
    NSInteger	begin	= index * self.configData.itemCountInPage;
    NSInteger	end		= (index + 1) * self.configData.itemCountInPage;
    if (end > [self.currentCatalogData.emoticons count]) {
        end = [self.currentCatalogData.emoticons count];
    }
    return [self emojPageView:pageView beginItem:begin endItem:end];
}


- (EmoticonCatalog*)loadDefaultCatalog
{
    EmoticonCatalog *emoticonCatalog = [[EmoticonManager sharedManager] emoticonCatalog:EmojiEmoticonCatalog];
    emoticonCatalog.pagesCount = [self numberOfPagesWithCurrentChartletCount:emoticonCatalog.emoticons.count];
    self.currentCatalogData = emoticonCatalog;
    self.emoticonDataArray = [@[emoticonCatalog] mutableCopy];
    self.currentCatalogData = emoticonCatalog;
    if (_currentCatalogData.pagesCount > 0) {
        _emotPageController.numberOfPages = [_currentCatalogData pagesCount];
        _emotPageController.currentPage = 0;
        [_emoticonPageView scrollToPage:[self currentPages]];
    }
    return emoticonCatalog;
}

- (NSInteger)numberOfPagesWithCurrentChartletCount:(NSInteger)count
{
    if(count % self.configData.itemCountInPage == 0)
    {
        return  count / self.configData.itemCountInPage;
    }
    else
    {
        return  count / self.configData.itemCountInPage + 1;
    }
}

- (void)pageViewScrollEnd: (PageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages{
    self.emotPageController.currentPage = index;
}


#pragma mark - EmoticonButtonTouchDelegate
- (void)selectedEmoticon:(Emoticon*)emoticon catalogID:(NSString*)catalogID{
    if ([self.delegate respondsToSelector:@selector(selectedEmoticon:catalog:description:)]) {
        [self.delegate selectedEmoticon:emoticon.emoticonID catalog:catalogID description:emoticon.tag];
    }
}

- (void)didPressSend:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didPressSend:)]) {
        [self.delegate didPressSend:sender];
    }
}

@end


