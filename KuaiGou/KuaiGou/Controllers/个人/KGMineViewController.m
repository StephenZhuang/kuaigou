//
//  KGMineViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGMineViewController.h"
#import "KGLoginManager.h"
#import "KGGoodsCell.h"
#import "KGGoodsDetailViewController.h"
#import "KGImageUrlHelper.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "KGUploadManager.h"

@implementation KGMineViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myGoodsButton.selected = YES;
    self.selectedIndex = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"KGGoodsCell" bundle:nil] forCellReuseIdentifier:@"KGGoodsCell"];
    [self configureHead];
}

- (void)configureHead
{
    KGUser *user = [KGLoginManager sharedInstance].user;
    [self.headButton sd_setImageWithURL:[NSURL URLWithString:[KGImageUrlHelper imageUrlWithKey:user.avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg_usercenter_head_def"]];
    [self.nameButton setTitle:user.nickname?user.nickname:@"手机用户" forState:UIControlStateNormal];
    [self.ratingView setValue:5];
    self.headButton.layer.cornerRadius = 35;
    self.headButton.layer.masksToBounds = YES;
}

- (IBAction)logoutAction:(id)sender
{
    [[KGLoginManager sharedInstance] logoutWithCompletion:^(BOOL success, NSString *errorInfo) {
        [self.rdv_tabBarController setSelectedIndex:0];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (IBAction)myGoodsAction:(id)sender
{
    if (!self.myGoodsButton.selected) {
        self.myGoodsButton.selected = YES;
        self.myPromoteButton.selected = NO;
        self.selectedIndex = 1;
        page = 1;
        [self.tableView.header beginRefreshing];
    }
}

- (IBAction)myPromoteAction:(id)sender
{
    if (!self.myPromoteButton.selected) {
        self.myPromoteButton.selected = YES;
        self.myGoodsButton.selected = NO;
        self.selectedIndex = 2;
        page = 1;
        [self.tableView.header beginRefreshing];
    }
}

- (void)loadData
{
    if (self.lat && self.lng) {
        if (self.selectedIndex == 1) {
            [KGGoods getMyGoodsWithUserid:[KGLoginManager sharedInstance].user.userid token:[KGLoginManager sharedInstance].user.token pagenumber:page pagesize:pageCount completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
                [self configureArray:array];
            }];
        } else {
            [KGGoods getMyPromoteGoodsWithUserid:[KGLoginManager sharedInstance].user.userid token:[KGLoginManager sharedInstance].user.token pagenumber:page pagesize:pageCount completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
                [self configureArray:array];
            }];
        }
        
    } else {
        [KGLocationManager sharedInstance].locationService.delegate = self;
        [[KGLocationManager sharedInstance].locationService startUserLocationService];
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [[KGLocationManager sharedInstance].locationService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.lat = userLocation.location.coordinate.latitude;
    self.lng = userLocation.location.coordinate.longitude;
    [self loadData];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGGoodsCell"];
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureUIWithGoods:goods];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        double distance = [[KGLocationManager sharedInstance] distanceBetweenPoint1:CLLocationCoordinate2DMake(self.lat, self.lng) point2:CLLocationCoordinate2DMake(goods.lat.doubleValue, goods.lng.doubleValue)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [cell.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",distance]];
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    KGGoodsDetailViewController *vc = [KGGoodsDetailViewController viewControllerFromStoryboard];
    vc.itemid = goods.itemid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - headimage
- (IBAction)headAction:(id)sender
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_headButton setImage:image forState:UIControlStateNormal];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    
    [[KGUploadManager sharedInstance] uploadWithData:@[UIImageJPEGRepresentation(image, 0.8)] completion:^(BOOL success, NSString *uploadAddress, NSString *errorInfo) {
        if (success) {
            [KGLoginManager sharedInstance].user.avatar = uploadAddress;
            [GVUserDefaults standardUserDefaults].user = [[KGLoginManager sharedInstance].user keyValues];
            [[KGLoginManager sharedInstance].user updateAvatarWithCompletion:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@"上传成功"];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

#pragma mark - nickname
- (IBAction)nicknameAction:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        //添加好友
        if (buttonIndex == 1) {
            NSString *content = [[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (content.length > 0 && content.length <= 12) {
                [self.nameButton setTitle:content forState:UIControlStateNormal];
                [KGLoginManager sharedInstance].user.nickname = content;
                [GVUserDefaults standardUserDefaults].user = [[KGLoginManager sharedInstance].user keyValues];
                [[KGLoginManager sharedInstance].user updateNicknameWithCompletion:^(BOOL success, NSString *errorInfo) {
                    
                }];
            } else {
                [MBProgressHUD showText:@"昵称不能为空且长度小于12字" toView:self.view];
            }
        }
    }
}
@end
