//
//  KGRegisterPasswordViewControlelr.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/19.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGRegisterPasswordViewControlelr : KGBaseViewController<UITextFieldDelegate>
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordAgainTextField;
@property (nonatomic , assign) BOOL isRegister;
@end
