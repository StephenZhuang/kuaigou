//
//  KGReleaseSecondViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGReleaseSecondViewController.h"
#import "KGSWitchCell.h"
#import "KGProgressCell.h"
#import "KGTextViewCell.h"
#import "KGCategoryViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "KGUploadManager.h"

@implementation KGReleaseSecondViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布";
}

- (IBAction)releaseAction:(id)sender
{
    if (self.goods.address.length == 0) {
        [MBProgressHUD showText:@"请填写地址" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"上传中" toView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray *dataArray = [KGUploadManager dataArrayFromImageArray:self.imageArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [[KGUploadManager sharedInstance] uploadWithData:dataArray completion:^(BOOL success, NSString *uploadAddress, NSString *errorInfo) {
                if (success) {
                    self.goods.image = uploadAddress;
                    [KGGoods addGoodsWithGoods:self.goods completion:^(BOOL success, NSString *errorInfo) {
                        if (success) {
                            [hud turnToSuccess:@"发布成功"];
                            [self dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        } else {
                            [hud turnToError:errorInfo];
                        }
                    }];
                } else {
                    [hud turnToError:@"上传失败，请重试"];
                }
            }];
        });
    });
    
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 1;
    switch (section) {
        case 0:
            rowNum = 1;
            break;
        case 1:
            rowNum = 2;
            break;
        case 2:
            rowNum = 2;
            break;
        default:
            rowNum = 1;
            break;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return 90;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    if (indexPath.section == 0) {
        KGProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGProgressCell"];
        [cell.titileLabel setText:@"类目"];
        [cell.contentLabel setText:self.goods.catNames.length>0?self.goods.catNames:@"选择类目"];
        [cell.slider setHidden:YES];
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            KGSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGSwitchCell"];
            [cell.titleLabel setText:@"打折优惠"];
            cell.contentSwitch.on = (self.goods.isdiscount.integerValue == 1);
            cell.valueChangedBlock = ^(BOOL value) {
                weakSelf.goods.isdiscount = value?@"1":@"0";
                [weakSelf.tableView reloadData];
            };
            return cell;
        } else {
            
            KGProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGProgressCell"];
            [cell.slider setHidden:NO];
            cell.slider.value = self.goods.discount;
            [cell.titileLabel setText:@""];
            [cell.contentLabel setText:[NSString stringWithFormat:@"%.1f折",self.goods.discount*10]];
            cell.valueChangedBlock = ^(float value) {
                weakSelf.goods.discount = value;
                [weakSelf.tableView reloadData];
            };
            return cell;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            KGSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGSwitchCell"];
            [cell.titleLabel setText:@"参与推广"];
            cell.contentSwitch.on = (self.goods.ispromote.integerValue == 1);
            cell.valueChangedBlock = ^(BOOL value) {
                weakSelf.goods.ispromote = value?@"1":@"0";
                [weakSelf.tableView reloadData];
            };
            return cell;
        } else {
            KGProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGProgressCell"];
            [cell.slider setHidden:NO];
            [cell.titileLabel setText:@"佣金比例"];
            cell.slider.value = self.goods.promote;
            [cell.contentLabel setText:[[NSString stringWithFormat:@"%.0f",self.goods.promote*100] stringByAppendingString:@"%"]];
            cell.valueChangedBlock = ^(float value) {
                weakSelf.goods.promote = value;
                [weakSelf.tableView reloadData];
            };
            return cell;
        }
    } else if (indexPath.section == 3) {
        KGProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGProgressCell"];
        [cell.slider setHidden:YES];
        [cell.titileLabel setText:@"交易方式"];
        [cell.contentLabel setText:self.tradeModeArray[self.goods.trademodeid-1]];
        return cell;
    } else {
        KGTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGTextViewCell"];
        [cell.textView setText:self.goods.address];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        __weak __typeof(&*self)weakSelf = self;
        KGCategoryViewController *vc = [KGCategoryViewController viewControllerFromStoryboard:@"Release"];
        vc.categoryBlock = ^(NSInteger catpid,NSInteger catid,NSString *name) {
            weakSelf.goods.catid = catid;
            weakSelf.goods.catpid = catpid;
            weakSelf.goods.catNames = name;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 3) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"交易方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.tradeModeArray[0],self.tradeModeArray[1],self.tradeModeArray[2], nil];
        [actionSheet showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 3) {
        self.goods.trademodeid = buttonIndex + 1;
        [self.tableView reloadData];
    }
}

#pragma mark - location
- (IBAction)location:(id)sender
{
    //初始化BMKLocationService
    self.locationService.delegate = self;
    //启动LocationService
    [self.locationService startUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.locationService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.goods.lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.goods.lng = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    //发起反向地理编码检索
    self.searcher.delegate = self;
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}

//接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      self.goods.address = result.address;
      [self.tableView reloadData];
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.goods.address = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - setters and getters
- (NSArray *)tradeModeArray
{
    if (!_tradeModeArray) {
        _tradeModeArray = @[@"送货上门",@"上门自提",@"快递方式"];
    }
    return _tradeModeArray;
}

- (BMKLocationService *)locationService
{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService;
}

- (BMKGeoCodeSearch *)searcher
{
    if (!_searcher) {
        _searcher = [[BMKGeoCodeSearch alloc] init];
    }
    return _searcher;
}
@end
