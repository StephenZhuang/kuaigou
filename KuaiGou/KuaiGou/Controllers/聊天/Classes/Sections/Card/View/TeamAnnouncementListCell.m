//
//  TeamAnnouncementListCell.m
//  NIM
//
//  Created by Xuhui on 15/3/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TeamAnnouncementListCell.h"
#import "UsrInfoData.h"

@interface TeamAnnouncementListCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TeamAnnouncementListCell

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    _titleLabel.text = title;
    NSString *content = [data objectForKey:@"content"];
    _contentLabel.text = content;
    NSString *creatorId = [data objectForKey:@"creator"];
    NSNumber *time = [data objectForKey:@"time"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    UsrInfo *creator = [[UsrInfoData sharedInstance] queryUsrInfoById:creatorId needRemoteFetch:YES fetchCompleteHandler:nil];
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@", creator.nick, [dateFormatter stringFromDate:date]];
}

@end
