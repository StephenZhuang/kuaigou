//
//  CardDataSourceProtocol.h
//  NIM
//
//  Created by chrisRay on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CardHeaderOpeator){
    CardHeaderOpeatorNone,
    CardHeaderOpeatorAdd,
    CardHeaderOpeatorRemove,
};

typedef NS_ENUM(NSInteger, TeamCardRowItemType) {
    TeamCardRowItemTypeCommon,
    TeamCardRowItemTypeTeamMember,
    TeamCardRowItemTypeRedButton,
    TeamCardRowItemTypeBlueButton,
};


@protocol CardHeaderData <NSObject>

- (UIImage*)imageNormal;

- (UIImage*)imageHighLight;

- (NSString*)title;

@optional
- (NSString*)memberId;

- (CardHeaderOpeator)opera;

@end



@protocol CardBodyData <NSObject>

- (NSString*)title;

- (TeamCardRowItemType)type;

- (CGFloat)rowHeight;

@optional
- (NSString*)subTitle;

- (SEL)action;

- (BOOL)actionDisabled;

@end