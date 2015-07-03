//
//  FileTransSelectViewController.h
//  NIM
//
//  Created by chrisRay on 15/4/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FileTransCompletionBlock)(id sender,NSString* ext);

@interface FileTransSelectViewController : UIViewController

@property(nonatomic,strong) IBOutlet UITableView *tableView;

@property(nonatomic,copy)FileTransCompletionBlock completionBlock;

@end
