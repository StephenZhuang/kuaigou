//
//  EmoticonParser.h
//  NIM
//
//  Created by amao on 2/26/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    TokenTypeText,
    TokenTypeEmoticon,
    
} TokenType;

@interface TextToken : NSObject
@property (nonatomic,copy)      NSString    *text;
@property (nonatomic,assign)    TokenType   type;
@end


@interface EmoticonParser : NSObject
+ (instancetype)currentParser;
- (NSArray *)tokens:(NSString *)text;
@end
