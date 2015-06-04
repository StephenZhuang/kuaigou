//
//  TeamCardOperationItem.h
//  NIM
//
//  Created by chrisRay on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardDataSourceProtocol.h"

@interface TeamCardOperationItem : NSObject<CardHeaderData>

- (instancetype)initWithOperation:(CardHeaderOpeator)opera;

@end
