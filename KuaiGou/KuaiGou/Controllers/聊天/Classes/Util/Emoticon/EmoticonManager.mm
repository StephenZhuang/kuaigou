//
//  EmoticonManager.h
//  NIM
//
//  Created by amao on 7/2/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "EmoticonManager.h"
#import "tinyxml2.h"

@implementation Emoticon
@end
@implementation EmoticonCatalog
@end

@interface EmoticonManager ()
@property (nonatomic,strong)    NSArray *catalogs;
@end

@implementation EmoticonManager
+ (instancetype)sharedManager
{
    static EmoticonManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EmoticonManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        [self parseXML];
    }
    return self;
}

- (EmoticonCatalog *)emoticonCatalog:(NSString *)catalogID
{
    for (EmoticonCatalog *catalog in _catalogs)
    {
        if ([catalog.catalogID isEqualToString:catalogID])
        {
            return catalog;
        }
    }
    return nil;
}


- (Emoticon *)emoticonByTag:(NSString *)tag
{
    Emoticon *emoticon = nil;
    if ([tag length])
    {
        for (EmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.tag2Emoticons objectForKey:tag];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}


- (Emoticon *)emoticonByID:(NSString *)emoticonID
{
    Emoticon *emoticon = nil;
    if ([emoticonID length])
    {
        for (EmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}

- (Emoticon *)emoticonByCatalogID:(NSString *)catalogID
                       emoticonID:(NSString *)emoticonID
{
    Emoticon *emoticon = nil;
    if ([emoticonID length] && [catalogID length])
    {
        for (EmoticonCatalog *catalog in _catalogs)
        {
            if ([catalog.catalogID isEqualToString:catalogID])
            {
                emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
                break;
            }
        }
    }
    return emoticon;
}

- (void)parseXML
{
    NSMutableArray *catalogs = [NSMutableArray array];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"xml"];
    tinyxml2::XMLDocument document;
    if (filepath)
    {
        tinyxml2::XMLDocument document;
        if (document.LoadFile([filepath UTF8String]) == tinyxml2::XML_SUCCESS)
        {
            tinyxml2::XMLElement *root = document.RootElement();
            if (root)
            {
                tinyxml2::XMLElement *child = root->FirstChildElement();
                while (child)
                {
                    EmoticonCatalog *catalog = [self parseCatalog:child];
                    [catalogs addObject:catalog];

                    child = child->NextSiblingElement();
                }
            }
        }
    }
    _catalogs = catalogs;
}

- (EmoticonCatalog *)parseCatalog:(tinyxml2::XMLElement *)element
{
    EmoticonCatalog *catalog = [[EmoticonCatalog alloc]init];
    const char *catalogID    = element->Attribute("ID");
    const char *title        = element->Attribute("Title");
    const char *icon         = element->Attribute("Icon");
    const char *iconPressed  = element->Attribute("IconPressed");
    catalog.catalogID        = catalogID ? [NSString stringWithUTF8String:catalogID] : @"";
    catalog.title            = title ? [NSString stringWithUTF8String:title] : @"";
    catalog.icon             = icon ? [NSString stringWithUTF8String:icon] : @"";
    catalog.iconPressed      = iconPressed ? [NSString stringWithUTF8String:iconPressed] : @"";
    NSMutableDictionary *tag2Emoticons = [NSMutableDictionary dictionary];
    NSMutableDictionary *id2Emoticons = [NSMutableDictionary dictionary];
    NSMutableArray *emoticons = [NSMutableArray array];
    
    tinyxml2::XMLElement *child = element->FirstChildElement();
    while (child)
    {
        Emoticon *emoticon = [self parseEmoticon:child];
        if (emoticon)
        {
            [tag2Emoticons setObject:emoticon
                              forKey:emoticon.tag];
            [id2Emoticons setObject:emoticon
                             forKey:emoticon.emoticonID];
            [emoticons addObject:emoticon];
        }

        child = child->NextSiblingElement();
    }
    catalog.emoticons = emoticons;
    catalog.id2Emoticons = id2Emoticons;
    catalog.tag2Emoticons= tag2Emoticons;
    
    return catalog;
}

- (Emoticon *)parseEmoticon:(tinyxml2::XMLElement *)element
{
    Emoticon *emoticon = nil;
    const char *emoticonID = element->Attribute("ID");
    const char *tag = element->Attribute("Tag");
    const char *filename = element->Attribute("File");
    if (emoticonID && tag && filename)
    {
        emoticon = [[Emoticon alloc] init];
        emoticon.emoticonID = [NSString stringWithUTF8String:emoticonID];
        emoticon.tag = [NSString stringWithUTF8String:tag];
        emoticon.filename = [NSString stringWithUTF8String:filename];
    }
    return emoticon;
}



@end
