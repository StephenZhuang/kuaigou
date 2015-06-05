//
//  FileTransSelectViewController.m
//  NIM
//
//  Created by chrisRay on 15/4/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "FileTransSelectViewController.h"
#define FileName @"fileName"
#define FileExt  @"fileExt"

@interface FileTransSelectViewController ()

@property(nonatomic,strong) NSArray *data;

@end

@implementation FileTransSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文件列表";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.data = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"Files"];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    NSString *filePath = self.data[indexPath.row];
    if (self.completionBlock) {
        if (indexPath.row % 2 == 0) {
            self.completionBlock(filePath,filePath.pathExtension);
            self.completionBlock = nil;
        }else{
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            self.completionBlock(data,filePath.pathExtension);
            self.completionBlock = nil;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString *path = self.data[indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.textLabel.text = path.lastPathComponent;
    }else{
        cell.textLabel.text = [path.lastPathComponent stringByAppendingString:@"(DATA 传输)"];
    }

    return cell;
}




@end
