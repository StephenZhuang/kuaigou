//
//  UIViewController+KGStoryboard.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "UIViewController+KGStoryboard.h"
#import <objc/runtime.h>
#import "KGHomeViewController.h"

@implementation UIViewController (KGStoryboard)
+ (instancetype)viewControllerFromStoryboard:(NSString *)storyboardName
{
    return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)addBackButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    
    [self.view setBackgroundColor: [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        swizzleMethod(class, @selector(viewDidLoad), @selector(kg_viewDidLoad));
        swizzleMethod(class, @selector(viewWillAppear:), @selector(kg_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(kg_viewWillDisappear:));
    });
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)kg_viewWillAppear:(BOOL)animated
{
    [self kg_viewWillAppear:animated];
}

- (void)kg_viewWillDisappear:(BOOL)animated
{
    [self kg_viewWillDisappear:animated];
}

- (void)kg_viewDidLoad
{
    [self kg_viewDidLoad];
    if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        [self addBackButton];
    }
}
@end
