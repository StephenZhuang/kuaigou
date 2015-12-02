//
//  KGSearchViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface KGSearchViewController : ZXRefreshTableViewController<UISearchBarDelegate>
@property (nonatomic , strong) UISearchBar *searchBar;
@property (nonatomic , copy) NSString *searchString;
@end
