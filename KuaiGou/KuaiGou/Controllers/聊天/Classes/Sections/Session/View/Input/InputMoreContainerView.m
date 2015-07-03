//
//  InputMoreContainerView.m
//  NIMDemo
//
//  Created by ght on 15-1-30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "InputMoreContainerView.h"
#import "PageView.h"
#import "SessionCellLayoutConstant.h"

extern NSInteger ButtomInputViewHeight;
NSInteger MaxItemCountInPage = 8;
NSInteger ButtonItemWidth = 74;
NSInteger ButtonItemHeight = 85;
NSInteger PageRowCount     = 2;
NSInteger PageColumnCount  = 4;
NSInteger ButtonBegintLeftX = 11;


@implementation CustomMediaButtonData
- (id)initCustomMediaButtonData:(NSString*)normalFileName
                pressedFileName:(NSString*)pressedFileName
                          title:(NSString*)title
                           type:(NSInteger)type
{
    self = [super init];
    if (self)
    {
        self.imageNormalFileName = normalFileName;
        self.imagePressedFileName = pressedFileName;
        self.buttonTitle = title;
        self.buttonType = type;
    }
    return self;
}

@end


@interface InputMoreContainerView() <PageViewDataSource,PageViewDelegate>
{
    NSMutableArray  *_mediaButtons;
    PageView        *_pageView;
}

@end

@implementation InputMoreContainerView

- (instancetype)initWithSessionType:(NIMSessionType)sessionType
{
    if (self = [self initWithFrame:CGRectMake(0, 0, UIScreenWidth, ButtomInputViewHeight)]) {
        
        
    }
    return self;
}

- (NSDictionary*)actionsDict
{
    static NSDictionary *actionsDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionsDict =  @{@(MediaButtonPicture):@"delegatePicturePressed",
                         @(MediaButtonShoot):@"delegateShootPressed",
                         @(MediaButtonPosition):@"delegatePositionPressed",
                         @(MediaButtonCard):@"delegateCardPressed",
                         @(MediaButtonVideoChat):@"delegateVideoChatPressed",
                         @(MediaButtonAudioChat):@"delegateAudioChatPressed",
                         @(MediaButtonCustom):@"delegateCustomChatPressed",
                         @(MediaButtonFileTrans):@"delegateCustomFileTrans"};

    });
    return actionsDict;
}

- (void)setDataSource:(id<InputMoreContainerDataSource>)dataSource
{
    _dataSource = dataSource;
    if (dataSource) {
        [self genMediaButtons];
    }
}

- (void)genMediaButtons
{
    _mediaButtons = [NSMutableArray array];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(moreBtnArrayForInputView)]) {
        NSArray * btnTypeArray = [self.dataSource moreBtnArrayForInputView];
        [btnTypeArray enumerateObjectsUsingBlock:^(CustomMediaButtonData *buttonData, NSUInteger idx, BOOL *stop) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setImage:[UIImage imageNamed:buttonData.imageNormalFileName] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:buttonData.imagePressedFileName] forState:UIControlStateHighlighted];
            [btn setTitle:buttonData.buttonTitle forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(76, -72, 0, 0)];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            btn.tag = buttonData.buttonType;
            [_mediaButtons addObject:btn];
        }];
    }
    
    _pageView= [[PageView alloc] initWithFrame:self.bounds];
    _pageView.dataSource = self;
    [self addSubview:_pageView];
    [_pageView scrollToPage:0];
}

- (void)dealloc
{
    _pageView.dataSource = nil;
}


#pragma mark PageViewDataSource
- (NSInteger)numberOfPages: (PageView *)pageView
{
    NSInteger count = [_mediaButtons count] / MaxItemCountInPage;
    count = ([_mediaButtons count] % MaxItemCountInPage == 0) ? count: count + 1;
    return MAX(count, 1);
}

- (UIView*)mediaPageView:(PageView*)pageView beginItem:(NSInteger)begin endItem:(NSInteger)end
{
    UIView *subView = [[UIView alloc] init];
    NSInteger span = (UIScreenWidth - PageColumnCount * ButtonItemWidth) / (PageColumnCount +1);
    CGFloat startY          = ButtonBegintLeftX;
    NSInteger coloumnIndex = 0;
    NSInteger rowIndex = 0;
    NSInteger indexInPage = 0;
    for (NSInteger index = begin; index < end; index ++)
    {
        UIButton *button = [_mediaButtons objectAtIndex:index];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        //计算位置
        rowIndex    = indexInPage / PageColumnCount;
        coloumnIndex= indexInPage % PageColumnCount;
        CGFloat x = span + (ButtonItemWidth + span) * coloumnIndex;
        CGFloat y = 0.0;
        if (rowIndex > 0)
        {
            y = rowIndex * ButtonItemHeight + startY + 15;
        }
        else
        {
            y = rowIndex * ButtonItemHeight + startY;
        }
        [button setFrame:CGRectMake(x, y, ButtonItemWidth, ButtonItemHeight)];
        [subView addSubview:button];
        indexInPage ++;
    }
    return subView;
}

- (UIView*)oneLineMediaInPageView:(PageView *)pageView
                       viewInPage: (NSInteger)index
                            count:(NSInteger)count
{
    UIView *subView = [[UIView alloc] init];
    NSInteger span = (UIScreenWidth - count * ButtonItemWidth) / (count +1);
    
    for (NSInteger btnIndex = 0; btnIndex < count; btnIndex ++)
    {
        UIButton *button = [_mediaButtons objectAtIndex:btnIndex];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        CGRect iconRect = CGRectMake(span + (ButtonItemWidth + span) * btnIndex, 58, ButtonItemWidth, ButtonItemHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
    }
    return subView;
}

- (UIView *)pageView: (PageView *)pageView viewInPage: (NSInteger)index
{
    if ([_mediaButtons count] == 2 || [_mediaButtons count] == 3) //一行显示2个或者3个
    {
        return [self oneLineMediaInPageView:pageView viewInPage:index count:[_mediaButtons count]];
    }
    
    if (index < 0)
    {
        assert(0);
        index = 0;
    }
    NSInteger begin = index * MaxItemCountInPage;
    NSInteger end = (index + 1) * MaxItemCountInPage;
    if (end > [_mediaButtons count])
    {
        end = [_mediaButtons count];
    }
    return [self mediaPageView:pageView beginItem:begin endItem:end];
}

#pragma mark - button actions
- (void)onTouchButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSString *selName = [[self actionsDict] objectForKey:@(button.tag)];
    if ([selName length] > 0) {
        SEL actionSel = NSSelectorFromString([[self actionsDict] objectForKey:@(button.tag)]) ;
        if (self.delegate && [self.delegate respondsToSelector:actionSel]) {
            SuppressPerformSelectorLeakWarning([self.delegate performSelector:actionSel]);
        }
    }
}

@end
