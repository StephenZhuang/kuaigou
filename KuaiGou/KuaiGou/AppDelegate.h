//
//  AppDelegate.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/11.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

