//
//  EmoticonManager
//  NIM
//
//  Created by amao on 7/2/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


#define EmojiEmoticonCatalog @"default"

@interface Emoticon : NSObject
@property (nonatomic,strong)    NSString    *emoticonID;
@property (nonatomic,strong)    NSString    *tag;
@property (nonatomic,strong)    NSString    *filename;
@end

@interface EmoticonCatalog : NSString
@property (nonatomic,strong)    NSString        *catalogID;
@property (nonatomic,strong)    NSString        *title;
@property (nonatomic,strong)    NSDictionary    *id2Emoticons;
@property (nonatomic,strong)    NSDictionary    *tag2Emoticons;
@property (nonatomic,strong)    NSArray         *emoticons;
@property (nonatomic,strong)    NSString        *icon;             //图标
@property (nonatomic,strong)    NSString        *iconPressed;      //小图标按下效果
@property (nonatomic,assign)    NSInteger       pagesCount;        //分页数
@end

@interface EmoticonManager : NSObject
+ (instancetype)sharedManager;

- (EmoticonCatalog *)emoticonCatalog:(NSString *)catalogID;
- (Emoticon *)emoticonByTag:(NSString *)tag;
- (Emoticon *)emoticonByID:(NSString *)emoticonID;
- (Emoticon *)emoticonByCatalogID:(NSString *)catalogID
                       emoticonID:(NSString *)emoticonID;
@end
