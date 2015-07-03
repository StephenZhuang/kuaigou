//
//  FilePreViewController.h
//  NIM
//
//  Created by chrisRay on 15/4/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMFileObject.h"
@interface FilePreViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIButton *actionBtn;

@property(nonatomic,strong) IBOutlet UIProgressView *progressView;

@property(nonatomic,strong) IBOutlet UILabel *fileNameLabel;

- (instancetype)initWithFileObject:(NIMFileObject*)object;

@end
