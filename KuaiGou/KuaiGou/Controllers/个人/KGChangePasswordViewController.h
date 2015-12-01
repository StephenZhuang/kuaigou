//
//  KGChangePasswordViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/12/1.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGBaseViewController.h"

@interface KGChangePasswordViewController : KGBaseViewController<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *pwdTextField;
@property (nonatomic , weak) IBOutlet UITextField *pwdAgiainTextField;
@end
