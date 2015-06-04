//
//  BadgeView.m
//  NIMDemo
//
//  Created by chrisRay on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#define kMaxBadgeWith 100.0
#define kBadgeTextOffset 2.0
#define kBadgePading 2.0
#define kBadgeTextFont  [UIFont systemFontOfSize:12]

#import "BadgeView.h"
#import "NSString+NIMDemo.h"
#import "SessionCellLayoutConstant.h"
@interface BadgeView ()

@property (strong) UIColor *badgeBackgroundColor;

@property (strong) UIColor *badgeTextColor;

@property (nonatomic) UIFont *badgeTextFont;

@end

@implementation BadgeView

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue{
    if (!badgeValue) {
        badgeValue = @"";
    }
    BadgeView *instance = [[BadgeView alloc] init];
    instance.frame = [instance frameWithStr:badgeValue];
    instance.badgeValue = badgeValue;
    
    return instance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
        _badgeBackgroundColor = [UIColor redColor];
        _badgeTextColor       = [UIColor whiteColor];
        _badgeTextFont        = [UIFont systemFontOfSize:12];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if ([[self badgeValue] length]) {
        CGSize badgeSize = [self badgeSizeWithStr:_badgeValue];

        CGRect bkgFrame = CGRectMake(kBadgeTextOffset,
                                                 kBadgeTextOffset,
                                                 badgeSize.width + 2 * kBadgePading,
                                                 badgeSize.height + 2 * kBadgePading);
        CGRect bodyFrame = CGRectMake(0, 0, bkgFrame.size.width +2*kBadgePading, bkgFrame.size.height + 2*kBadgePading);
        
        if ([self badgeBackgroundColor]) {//外白色描边
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                
                if (badgeSize.width > badgeSize.height) {
                    CGFloat circleWith = bodyFrame.size.height;
                    CGFloat totalWidth = bodyFrame.size.width;
                    CGFloat diffWidth = totalWidth - circleWith;
                    CGPoint originPoint = bodyFrame.origin;
                    
                    
                    CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
                    CGRect centerFrame = CGRectMake(originPoint.x +circleWith/2, originPoint.y, diffWidth, circleWith);
                    CGRect rightCicleFrame = CGRectMake(originPoint.x +(totalWidth - circleWith), originPoint.y, circleWith, circleWith);
                    CGContextFillEllipseInRect(context, leftCicleFrame);
                    CGContextFillRect(context, centerFrame);
                    CGContextFillEllipseInRect(context, rightCicleFrame);
                    
                }else{
                    CGContextFillEllipseInRect(context, bodyFrame);
                }
            //            badge背景色
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            if (badgeSize.width > badgeSize.height) {
                CGFloat circleWith = bkgFrame.size.height;
                CGFloat totalWidth = bkgFrame.size.width;
                CGFloat diffWidth = totalWidth - circleWith;
                CGPoint originPoint = bkgFrame.origin;
                
                
                CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
                CGRect centerFrame = CGRectMake(originPoint.x +circleWith/2, originPoint.y, diffWidth, circleWith);
                CGRect rightCicleFrame = CGRectMake(originPoint.x +(totalWidth - circleWith), originPoint.y, circleWith, circleWith);
                CGContextFillEllipseInRect(context, leftCicleFrame);
                CGContextFillRect(context, centerFrame);
                CGContextFillEllipseInRect(context, rightCicleFrame);
            }else{
                CGContextFillEllipseInRect(context, bkgFrame);
            }
        }
        
        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
        
        if (IOS7) {
            NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
            [badgeTextStyle setAlignment:NSTextAlignmentCenter];
            
            NSDictionary *badgeTextAttributes = @{
                                                  NSFontAttributeName: [self badgeTextFont],
                                                  NSForegroundColorAttributeName: [self badgeTextColor],
                                                  NSParagraphStyleAttributeName: badgeTextStyle,
                                                  };
            
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(bkgFrame) + kBadgeTextOffset,
                                                     CGRectGetMinY(bodyFrame) + kBadgeTextOffset,
                                                     badgeSize.width, badgeSize.height)
                           withAttributes:badgeTextAttributes];
        } else {
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(bkgFrame) + kBadgeTextOffset,
                                                     CGRectGetMinY(bodyFrame) + kBadgeTextOffset,
                                                     badgeSize.width, badgeSize.height)
                                 withFont:[self badgeTextFont]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
        }
    }
    
    CGContextRestoreGState(context);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    self.frame = [self frameWithStr:badgeValue];
    
    [self setNeedsDisplay];
}

- (CGSize)badgeSizeWithStr:(NSString *)badgeValue{
    if (!badgeValue || badgeValue.length == 0) {
        return CGSizeZero;
    }
    CGSize size = [badgeValue stringSizeWithFont:self.badgeTextFont constrainedToSize:CGSizeMake(kMaxBadgeWith, 20)];
    if (size.width < size.height) {
        size = CGSizeMake(size.height, size.height);
    }
    return size;
}

- (CGRect)frameWithStr:(NSString *)badgeValue{
    CGSize badgeSize = [self badgeSizeWithStr:badgeValue];
    CGRect badgeFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, badgeSize.width +8, badgeSize.height +8);//8=2*2（红圈-文字）+2*2（白圈-红圈）
    return badgeFrame;
}



@end
