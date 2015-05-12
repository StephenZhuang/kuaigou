//
//  AppDelegate.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/11.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    return YES;
}

#pragma mark - Methods

- (void)setupViewControllers {
    UIViewController *nav1 = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController];
    nav1.title = @"首页";
    UIViewController *nav2 = [[UIStoryboard storyboardWithName:@"Nearby" bundle:nil] instantiateInitialViewController];
    nav2.title = @"附近";
    UIViewController *nav3 = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil] instantiateInitialViewController];
    nav3.title = @"快聊";
    UIViewController *nav4 = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateInitialViewController];
    nav4.title = @"我的";
    UIViewController *vc = [[UIViewController alloc] init];
    
    KGTabBarController *tabBarController = [[KGTabBarController alloc] init];
    [tabBarController setViewControllers:@[nav1,nav2,vc,nav3,nav4]];
    
    [self customizeTabBarForController:tabBarController];
    self.window.rootViewController = tabBarController;
}

- (void)customizeTabBarForController:(KGTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@""];
    UIImage *unfinishedImage = [UIImage imageNamed:@""];
    NSArray *tabBarItemImages = @[@"bt_menu_home",@"bt_menu_nearby", @"bt_menu_release", @"bt_menu_talk",@"bt_menu_me"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_n",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    [navigationBarAppearance setBarTintColor: [UIColor colorWithRed:99/255.0 green:186/255.0 blue:106/255.0 alpha:1.0]];
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [navigationBarAppearance setTitleTextAttributes:attrs];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
