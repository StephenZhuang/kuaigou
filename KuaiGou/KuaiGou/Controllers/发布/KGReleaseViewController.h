//
//  KGReleaseViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGoods.h"

@interface KGReleaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate ,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , strong) KGGoods *goods;
@end
