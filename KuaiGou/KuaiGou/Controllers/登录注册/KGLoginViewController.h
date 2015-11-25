//
//  KGLoginViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGLoginViewController : KGBaseViewController<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@end
