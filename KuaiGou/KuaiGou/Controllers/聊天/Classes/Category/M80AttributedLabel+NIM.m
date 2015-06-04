//
//  M80AttributedLabel+NIM.m
//  NIM
//
//  Created by amao on 2/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "M80AttributedLabel+NIM.h"
#import "EmoticonParser.h"
#import "EmoticonManager.h"

@implementation M80AttributedLabel (NIM)
- (void)nim_setText:(NSString *)text
{
    [self setText:@""];
    NSArray *tokens = [[EmoticonParser currentParser] tokens:text];
    for (TextToken *token in tokens)
    {
        if (token.type == TokenTypeEmoticon)
        {
            Emoticon *emoticon = [[EmoticonManager sharedManager] emoticonByTag:token.text];
            UIImage *image = [UIImage imageNamed:emoticon.filename];
            if (image)
            {
                [self appendImage:image
                          maxSize:CGSizeMake(18, 18)];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}
@end
