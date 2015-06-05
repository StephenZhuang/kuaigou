//
//  SessionLogicImpl.m
//  NIM
//
//  Created by chrisRay on 15/4/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionLogicImpl.h"
#import "LocationPoint.h"
#import "LocationViewController.h"
#import "GalleryViewController.h"
#import "VideoViewController.h"

#import "FilePreViewController.h"
#import "SessionViewLayoutManager.h"
#import "SessionMsgDatasource.h"

@implementation SessionLogicImpl{
    id<SessionLogicLayout>     _layoutManager;
    id<SessionLogicDataSource> _dataSource;
}

- (instancetype)initWithLayoutManager:(id<SessionLogicLayout>)layoutManager
                           dataSource:(id<SessionLogicDataSource>)dataSource{
    self = [super init];
    if (self) {
        _layoutManager = layoutManager;
        _dataSource    = dataSource;
    }
    return self;
}

#pragma mark - SessionLogicDelegate
- (void)onDeleteMessage:(SessionMsgModel *)message
{
    if ([_dataSource respondsToSelector:@selector(deleteMessage:)]) {
        [_layoutManager deleteCellAtRows:[_dataSource deleteMessage:message]];
    }
}

- (void)toGalleryVC:(NIMImageObject *)object
{
    GalleryItem *item   = [[GalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    GalleryViewController *vc = [[GalleryViewController alloc] initWithItem:item];
    [self.currentNav pushViewController:vc
                                         animated:YES];
}

- (void)toLocationVC:(NIMLocationObject *)object{
    LocationPoint * locationPoint = [[LocationPoint alloc] initWithLocationObject:object];
    LocationViewController * vc = [[LocationViewController alloc] initWithLocationPoint:locationPoint];
    [self.currentNav pushViewController:vc animated:YES];
}

- (void)toVideoVC:(NIMVideoObject *)object{
    VideoViewController *playerViewController = [[VideoViewController alloc] initWithVideoObject:object];
    [self.currentNav pushViewController:playerViewController animated:YES];
}

- (void)toFileVC:(NIMFileObject *)object{
    FilePreViewController *vc = [[FilePreViewController alloc] initWithFileObject:object];
    [self.currentNav pushViewController:vc animated:YES];
}


- (UINavigationController *)currentNav{
    return [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
}


@end
