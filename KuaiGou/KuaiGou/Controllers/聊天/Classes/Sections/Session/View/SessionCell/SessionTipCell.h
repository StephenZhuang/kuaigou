//
//  SessionTipCell.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTipCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *timeBGView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setTimeStr:(NSString*)time;
@end
