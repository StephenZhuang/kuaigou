//
//  AdScrollView.m
//  Appk_ProductShow
//
//  Created by wuxian on 13-6-6.
//  Copyright (c) 2013年 wuxian. All rights reserved.
//

#import "AdScrollView.h"
#import "UIButton+WebCache.h"
#import "KGImageUrlHelper.h"

@implementation AdScrollView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configUIWithArray:(NSArray *)array {
    Tend = NO;
    [sv removeFromSuperview];
    sv = nil;
    
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    sv.showsHorizontalScrollIndicator = NO;
    sv.pagingEnabled = YES;
    sv.clipsToBounds = YES;
    sv.delegate = self;
    [self addSubview:sv];
    
//    [page removeFromSuperview];
//    page = nil;
//    page = [[UIPageControl alloc] init];
//    page.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height-page.frame.size.height-10);
//    [self addSubview:page];
    
    [page removeFromSuperview];
    page = nil;
    int kNumberOfPages = array.count;
    page =  [[StyledPageControl alloc] initWithFrame:CGRectZero];
    [page setPageControlStyle:PageControlStyleThumb];
    [page setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [page setFrame:CGRectMake(0, self.bounds.size.height - 11, self.bounds.size.width, 11)];
    [page setCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height - 5)];
    
    page.numberOfPages = kNumberOfPages;
    page.currentPage = 0;
    [page setPageControlStyle:PageControlStyleDefault];
    [self addSubview:page];
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    Arr = array;
//    Arr=[[NSArray alloc]initWithObjects:
//         @"http://img0.bdstatic.com/img/image/shouye/mnzqbb90h.jpg",
//         @"http://img0.bdstatic.com/img/image/shouye/mnwmxytt.jpg",
//         @"http://www.baidu.com/img/baidu_sylogo1.gif",nil];
    [self AdImg:Arr];
    [self setCurrentPage:page.currentPage];
    
}

#pragma mark - 5秒换图片
- (void) handleTimer: (NSTimer *) timer
{
    if (Arr.count > 1) {        
        if (TimeNum % 5 == 0 ) {
            
            if (!Tend) {
                page.currentPage++;
                if (page.currentPage==page.numberOfPages-1) {
                    Tend=YES;
                }
            }else{
                page.currentPage--;
                if (page.currentPage==0) {
                    Tend=NO;
                }
            }
            
            if (page.currentPage*self.bounds.size.width <= sv.contentSize.width) {
                [UIView animateWithDuration:0.7 //速度0.7秒
                                 animations:^{//修改坐标
                                     sv.contentOffset = CGPointMake(page.currentPage*self.bounds.size.width,0);
                                 }];
            }
            
        }
        TimeNum ++;
    }
}

-(void)AdImg:(NSArray*)arr{
    [sv setContentSize:CGSizeMake(self.frame.size.width*[arr count], self.frame.size.height)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[arr count]; i++) {
        NSString *urlStr=[arr objectAtIndex:i];
//        NSString *url = [UserDefaultsUtil getImageUrlWtihString:urlStr].absoluteString;
//        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height - 11)];
        [img setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Action)];
        [img addGestureRecognizer:tap];
//        [img addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
//        [img setImage:[UIImage imageNamed:@"bg_banner"] forState:UIControlStateNormal];
        [sv addSubview:img];
//        [img setBackgroundColor:[UIColor redColor]];
        [img sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
        img.layer.masksToBounds = YES;
        img.layer.contentsGravity = kCAGravityResizeAspectFill;
    }
    
}

- (void)Action
{
    if (_clickAtIndex) {
        _clickAtIndex(page.currentPage);
    }
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (fmodf(scrollView.contentOffset.x, self.frame.size.width) == 0) {
        page.currentPage=scrollView.contentOffset.x/self.frame.size.width;
        if (page.currentPage <= 0) {
            Tend = NO;
        }
        else if (page.currentPage >= page.numberOfPages-1) {
            Tend=YES;
        }
        [self setCurrentPage:page.currentPage];
    }
    
    
}
- (void)setCurrentPage:(NSInteger)secondPage {
    
//    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
//        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
//        CGSize size;
//        size.height = 24/2;
//        size.width = 24/2;
//        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
//                                     size.width,size.height)];
//        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"page_on.png"]];
//        else [subview setImage:[UIImage imageNamed:@"page_off.png"]];
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
