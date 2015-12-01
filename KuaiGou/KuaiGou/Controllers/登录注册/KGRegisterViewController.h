//
//  KGRegisterViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/19.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGRegisterViewController : KGBaseViewController<UITextFieldDelegate>
{
    NSString *codeString;
}
@property (nonatomic , weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic , weak) IBOutlet UITextField *codeTextField;
@property (nonatomic , weak) IBOutlet UIButton *countDownButton;
@property (nonatomic , assign) BOOL isRegister;
@end
