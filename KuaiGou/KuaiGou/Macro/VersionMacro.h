//
//  VersionMacro.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#ifndef Aier360_VersionMacro_h
#define Aier360_VersionMacro_h

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS8_OR_LATER (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
#endif
