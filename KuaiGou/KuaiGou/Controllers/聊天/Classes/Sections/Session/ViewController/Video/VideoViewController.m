//
//  VideoViewController.m
//  NIM
//
//  Created by chrisRay on 15/4/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "VideoViewController.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "UIAlertView+Block.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (instancetype)initWithContentURL:(NSURL *)contentURL{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:contentURL];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayer.fullscreen = YES;
        self.wantsFullScreenLayout = YES;
        if (IOS7) {
            self.edgesForExtendedLayout = UIRectEdgeAll;
        }
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频短片";
    if (![Reachability reachabilityForInternetConnection].isReachable && !_moviePlayer.contentURL.isFileURL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络异常请检查网咯" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertWithCompletionHandler:^(NSInteger idx) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    self.moviePlayer.view.frame = self.view.bounds;
    self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.moviePlayer play];
    [self.view addSubview:_moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.moviePlayer];
    

    CGRect bounds = self.moviePlayer.view.bounds;
    CGRect tapViewFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    UIView *tapView = [[UIView alloc]initWithFrame:tapViewFrame];
    [tapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    tapView.backgroundColor = [UIColor clearColor];
    [self.moviePlayer.view addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [tapView  addGestureRecognizer:tap];

}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    if (![[self.navigationController viewControllers] containsObject: self])
    {
        [self topStatusUIHidden:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [self topStatusUIHidden:YES];
    }else{
        [self topStatusUIHidden:NO];
    }
}

- (void)moviePlaybackComplete: (NSNotification *)aNotification
{
    if (self.moviePlayer == aNotification.object)
    {
        [self topStatusUIHidden:NO];
        NSDictionary *notificationUserInfo = [aNotification userInfo];
        NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        MPMovieFinishReason reason = [resultValue intValue];
        if (reason == MPMovieFinishReasonPlaybackError)
        {
            NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
            NSString *errorTip = [NSString stringWithFormat:@"播放失败: %@", [mediaPlayerError localizedDescription]];
            [self.view makeToast:errorTip];
        }
    }
    
}

- (void)moviePlayStateChanged: (NSNotification *)aNotification
{
    if (self.moviePlayer == aNotification.object)
    {
        switch (self.moviePlayer.playbackState)
        {
            case MPMoviePlaybackStatePlaying:
                [self topStatusUIHidden:YES];
                break;
            case MPMoviePlaybackStatePaused:
            case MPMoviePlaybackStateStopped:
            case MPMoviePlaybackStateInterrupted:
                [self topStatusUIHidden:NO];
            case MPMoviePlaybackStateSeekingBackward:
            case MPMoviePlaybackStateSeekingForward:
                break;
        }
        
    }
}

- (void)topStatusUIHidden:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden];
    self.navigationController.navigationBar.hidden = isHidden;
    
    if(!IOS7 && !isHidden)//旋转后会导致wantsFullSceenLayout的statusbar和navbar重叠
    {
        CGRect frame = [self.navigationController.navigationBar frame];
        if (frame.origin.y != 20)
        {
            frame.origin.y = 20;
            [self.navigationController.navigationBar setFrame:frame];
        }
    }
}

- (void)onTap: (UIGestureRecognizer *)recognizer
{
    switch (self.moviePlayer.playbackState)
    {
        case MPMoviePlaybackStatePlaying:
            [self.moviePlayer pause];
            break;
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
        case MPMoviePlaybackStateInterrupted:
            [self.moviePlayer play];
            break;
        default:
            break;
    }
}


@end
