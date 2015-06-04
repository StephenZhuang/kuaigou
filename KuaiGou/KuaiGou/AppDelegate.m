//
//  AppDelegate.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/11.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "AppDelegate.h"
#import "KGLoginManager.h"
#import "NIMSDK.h"
#import "LogManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([KGLoginManager sharedInstance].isLogin) {
        [KGLoginManager sharedInstance].user = [KGUser objectWithKeyValues:[GVUserDefaults standardUserDefaults].user];
        [[KGLoginManager sharedInstance] doYunxinLoginWithUsername:[GVUserDefaults standardUserDefaults].username password:[GVUserDefaults standardUserDefaults].password];
    }
    
    [self setUpBaiduMap];
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
    UIImage *finishedImage = [UIImage new];
    UIImage *unfinishedImage = [UIImage new];
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

- (void)setUpBaiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"DxFTRtVq8LnWRoZpXrag2RqG"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)setupYunxin
{
#ifdef DEBUG
    [[NIMSDK sharedSDK] registerWithAppID:@"8eab09ecf072d611ca65fac1ba6a5098"
                                  cerName:@"DEVELOPER"];
#else
    [[NIMSDK sharedSDK] registerWithAppID:@"8eab09ecf072d611ca65fac1ba6a5098"
                                  cerName:@"ENTERPRISE"];
#endif
    
    [[LogManager sharedManager] start];
    
    [self registerAPNs];
}

#pragma mark - misc
- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
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

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}



- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogDebug(@"fail to get apns token :%@",error);
}
@end
