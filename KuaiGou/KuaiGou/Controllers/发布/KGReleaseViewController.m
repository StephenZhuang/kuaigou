//
//  KGReleaseViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGReleaseViewController.h"
#import "KGStockCell.h"
#import "KGTextFieldCell.h"
#import "KGTextViewCell.h"
#import "ZXImagePickCell.h"
#import "SZCalendarPicker.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "KGReleaseSecondViewController.h"

@interface KGReleaseViewController ()

@end

@implementation KGReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = item;
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextAction:(id)sender
{
    [self.view endEditing:YES];
//    if (self.goods.title.length <= 0 || self.goods.effdate.length <= 0 || self.imageArray.count == 0) {
//        [MBProgressHUD showError:@"请将内容填写完整" toView:self.view];
//        return;
//    }
    
    KGReleaseSecondViewController *vc = [KGReleaseSecondViewController viewControllerFromStoryboard:@"Release"];
    vc.goods = self.goods;
    vc.imageArray = self.imageArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    switch (section) {
        case 0:
            rowNum = 2;
            break;
        default:
            rowNum = 1;
            break;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 45;
        } else {
            return 130;
        }
    } else if (indexPath.section == 4) {
        return [ZXImagePickCell heightByImageArray:self.imageArray];
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            KGTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            cell.textField.text = self.goods.title;
            return cell;
        } else {
            KGTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
            cell.textView.placeholder = @"请输入详细描述";
            cell.textView.text = self.goods.info;
            return cell;
        }
    } else if (indexPath.section == 1) {
        KGTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"price"];
        cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.price];
        return cell;
    } else if (indexPath.section == 2) {
        KGStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stock"];
        cell.textField.text = [NSString stringWithFormat:@"%@",@(self.goods.stock)];
        return cell;
    } else if (indexPath.section == 3) {
        KGTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"date"];
        [cell.titleLabel setText:self.goods.effdate];
        return cell;
    } else {
        __weak __typeof(&*self)weakSelf = self;
        ZXImagePickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImagePickCell"];
        cell.imageArray = self.imageArray;
        cell.clickBlock = ^(NSIndexPath *indexPath) {
            [weakSelf.view endEditing:YES];
            if (indexPath.row == self.imageArray.count) {
                [weakSelf showActionSheet];
            } else {
                [weakSelf showDeleteActionSheet:indexPath.row];
            }
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
        calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            self.goods.effdate = [NSString stringWithFormat:@"%i-%.2d-%.2d", year,month,day];
            [self.tableView reloadData];
        };
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)showActionSheet
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

- (void)showDeleteActionSheet:(NSInteger)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    actionSheet.tag = index;
    [actionSheet showInView:self.view];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                {
                    // 相机
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    
                    imagePickerController.delegate = self;
                    
                    imagePickerController.allowsEditing = NO;
                    
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                case 1:
                {
                    // 相册
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    
                    imagePickerController.delegate = self;
                    
                    imagePickerController.allowsEditing = NO;
                    
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                
                imagePickerController.delegate = self;
                
                imagePickerController.allowsEditing = NO;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            } else {
                return;
            }
        }
        
    } else {
        if (buttonIndex == 0) {
            [self.imageArray removeObjectAtIndex:actionSheet.tag];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageArray addObject:image];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - text delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        self.goods.title = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if (textField.tag == 2){
        self.goods.price = textField.text.floatValue;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 2) {
        if ([textField.text rangeOfString:@"."].location != NSNotFound && range.location > [textField.text rangeOfString:@"."].location && ![string isEqualToString:@""]) {
            if ([string isEqualToString:@"."] || ([[[textField.text componentsSeparatedByString:@"."] lastObject] length] >= 2 )) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.goods.info = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - setters and getters
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (KGGoods *)goods
{
    if (!_goods) {
        _goods = [[KGGoods alloc] init];
    }
    return _goods;
}
@end
