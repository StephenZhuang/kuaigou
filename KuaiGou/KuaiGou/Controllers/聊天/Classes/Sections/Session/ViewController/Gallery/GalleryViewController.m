//
//  GalleryViewController.m
//  NIMDemo
//
//  Created by ght on 15-2-3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "GalleryViewController.h"
#import "SessionCellActionHandler.h"
#import "UIImageView+WebCache.h"

@implementation GalleryItem
@end


@interface GalleryViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *galleryImageView;
@property (nonatomic,strong)    GalleryItem *currentItem;
@end

@implementation GalleryViewController

- (instancetype)initWithItem:(GalleryItem *)item
{
    if (self = [super initWithNibName:@"GalleryViewController"
                               bundle:nil])
    {
        _currentItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _galleryImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *url = [NSURL URLWithString:_currentItem.imageURL];
    [_galleryImageView sd_setImageWithURL:url
                         placeholderImage:[UIImage imageWithContentsOfFile:_currentItem.thumbPath]];
    
    if ([_currentItem.name length])
    {
        self.navigationItem.title = _currentItem.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
