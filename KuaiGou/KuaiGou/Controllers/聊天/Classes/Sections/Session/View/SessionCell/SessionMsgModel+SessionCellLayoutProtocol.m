//
//  SessionMsgModel+SessionCellLayoutProtocol.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "NIMSDK.h"
#import "SessionCellLayoutConstant.h"
#import "SessionUtil.h"
#import "M80AttributedLabel+NIM.h"

@implementation SessionMsgModel (SessionCellLayoutProtocol)

- (BOOL)retryButtonHidden
{
    if (!self.msgData.isReceivedMsg) {
        return self.msgData.deliveryState != NIMMessageDeliveryStateFailed;
    } else
    {
        return self.msgData.attachmentDownloadState != NIMMessageAttachmentDownloadStateFailed;
    }
}

- (BOOL)activityIndicatorHidden
{
    if (!self.msgData.isReceivedMsg) {
        return self.msgData.deliveryState != NIMMessageDeliveryStateDelivering;
    } else
    {
        return self.msgData.attachmentDownloadState != NIMMessageAttachmentDownloadStateDownloading;
    }
}


- (BOOL)unreadHidden {
    if (self.msgData.messageType == NIMMessageTypeAudio) { //音频
        return (self.isFromMe || [self.msgData isPlayed]);
    }
    return YES;
}

- (UIImage *)bubbleImageForState:(UIControlState)state {
    
    if (self.isFromMe) {
        if (state == UIControlStateNormal)
        {
            UIImage *normalImageBG = [UIImage imageNamed:@"SenderTextNodeBkg.png"];
            
            return [normalImageBG resizableImageWithCapInsets:UIEdgeInsetsMake(18,25,17,25) resizingMode:UIImageResizingModeStretch];
            
        }else if (state == UIControlStateHighlighted)
        {
            UIImage *normalImageBG = [UIImage imageNamed:@"SenderTextNodeBkg_HL.png"] ;
            return [normalImageBG resizableImageWithCapInsets:UIEdgeInsetsMake(18,25,17,25) resizingMode:UIImageResizingModeStretch];
        }
        
    }else {
        if (state == UIControlStateNormal) {
            UIImage *normalImageBG = [UIImage imageNamed:@"ReceiverNodeBkg.png"];
            
            return [normalImageBG resizableImageWithCapInsets:UIEdgeInsetsMake(18,25,17,25) resizingMode:UIImageResizingModeStretch];
            
        }else if (state == UIControlStateHighlighted) {
            UIImage *normalImageBG = [UIImage imageNamed:@"ReceiverNodeBkg_HL.png"] ;
            return [normalImageBG resizableImageWithCapInsets:UIEdgeInsetsMake(18,25,17,25) resizingMode:UIImageResizingModeStretch];
        }
    }
    return nil;
}


#pragma mark control 排版
- (CGRect)avatarViewRect
{
    return self.isFromMe ? CGRectMake(SelfProtraitOriginX, 0,
                                      ProtraitImageWidth,
                                      ProtraitImageWidth) : CGRectMake(CellPaddingToProtrait, 0,
                                                                        ProtraitImageWidth, ProtraitImageWidth);
}

//气泡的size
- (CGSize)bubbleViewSize
{
    CGSize bubbleSize;
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        CGSize contentSize;
        switch ([self.msgData messageType]) {
            case NIMMessageTypeText:
            {
                M80AttributedLabel *label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
                label.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
                [label nim_setText:[self.msgData text]];
                contentSize = [label sizeThatFits:CGSizeMake(MsgContentMaxWidth, CGFLOAT_MAX)];
                break;
            }
            case NIMMessageTypeImage:
            {
                contentSize = CGSizeMake(AttachmentImageMinWidth, AttachmentImageMinHeight);
                NIMImageObject *imageObject = (NIMImageObject*)[self.msgData messageObject];
                if (!CGSizeEqualToSize(imageObject.size, CGSizeZero)) {
                    contentSize = [SessionUtil getImageSizeWithImageOriginSize:imageObject.size minSize:CGSizeMake(AttachmentImageMinWidth, AttachmentImageMinHeight) maxSize:CGSizeMake(AttachmemtImageMaxWidth, AttachmentImageMaxHeight )];
                }
               break;
            }
            case NIMMessageTypeAudio:
            {
                NIMAudioObject *audioContent = (NIMAudioObject*)[self.msgData messageObject];
                
                //使用公式 长度 = (最长－最小)*(2/pi)*artan(时间/10)+最小，在10秒时变化逐渐变缓，随着时间增加 无限趋向于最大值
                CGFloat value  = 2*atan((audioContent.duration/1000.0-1)/10.0)/M_PI;
                contentSize.width = (AudioContentMaxWidth - AudioContentMinWidth)* value +AudioContentMinWidth;
                contentSize.height = AudioContentHeight;
                break;
            }
            case NIMMessageTypeVideo:
            {
                contentSize = CGSizeMake(AttachmentImageMinWidth, AttachmentImageMinHeight);
                NIMVideoObject *videoObject = (NIMVideoObject*)[self.msgData messageObject];
                if (!CGSizeEqualToSize(videoObject.coverSize, CGSizeZero)) {
                    contentSize = [SessionUtil getImageSizeWithImageOriginSize:videoObject.coverSize minSize:CGSizeMake(AttachmentImageMinWidth, AttachmentImageMinHeight) maxSize:CGSizeMake(AttachmemtImageMaxWidth, AttachmentImageMaxHeight )];
                }
                break;
            }
            case NIMMessageTypeLocation:
            {
                contentSize = CGSizeMake(LocationMessageWidth, LocationMessageHeight);
                break;
            }
            case NIMMessageTypeNotification:
            {
                contentSize = CGSizeMake(NotificationMessageWidth, NotificationMessageHeight);
                break;
            }
            case NIMMessageTypeCustom:
            {
                contentSize = CGSizeMake(CustomMessageWidth, CustomMessageHeight);
                break;
            }
            default:
                contentSize = CGSizeMake(UnknowMessageWidth, UnknowMessageHeight);
                break;
        }
        
        self.contentSize = contentSize;
    }
    UIEdgeInsets contentInsets = [self contentViewInsets];
    bubbleSize.width = self.contentSize.width + contentInsets.left +contentInsets.right;
    bubbleSize.height = self.contentSize.height +contentInsets.top + contentInsets.bottom;
    return bubbleSize;
}


- (UIEdgeInsets)bubbleViewInsets {
    CGFloat teamNickNameHeight = 0.0;
    if (self.msgData.messageType == NIMMessageTypeNotification) {
        return UIEdgeInsetsZero;
    }
    if([self.msgData.session sessionType] == NIMSessionTypeTeam && ![self isFromMe]) {
        teamNickNameHeight = OtherNickNameHeight;
    }
    return UIEdgeInsetsMake(CellTopToBubbleTop + teamNickNameHeight,OtherBubbleOriginX,CellBubbleButtomToCellButtom, 0);
}

- (UIEdgeInsets)contentViewInsets
{
    UIEdgeInsets contentInsets;
    switch ([self.msgData messageType]) {
        case NIMMessageTypeText:
        {
            contentInsets = [self isFromMe]? UIEdgeInsetsMake(SelfBubbleTopToContentForText,
                                                              SelfBubbleLeftToContentForText,
                                                              SelfContentButtomToBubbleForText,
                                                              SelfBubbleRightToContentForText):
                                            UIEdgeInsetsMake(OtherBubbleTopToContentForText,
                                                             OtherBubbleLeftToContentForText,
                                                             OtherContentButtomToBubbleForText,
                                                             OtherContentRightToBubbleForText);
            break;
        }
        case NIMMessageTypeImage:
        case NIMMessageTypeLocation:
        case NIMMessageTypeVideo:
        case NIMMessageTypeCustom:
        {
            contentInsets = [self isFromMe]? UIEdgeInsetsMake(BubblePaddingForImage,BubblePaddingForImage,BubblePaddingForImage,BubblePaddingForImage + BubbleArrowWidthForImage):UIEdgeInsetsMake(BubblePaddingForImage,BubblePaddingForImage + BubbleArrowWidthForImage, BubblePaddingForImage,
                                                                                                                                          BubblePaddingForImage);
            break;
        }
        case NIMMessageTypeAudio:
        {
            contentInsets = [self isFromMe]? UIEdgeInsetsMake(BubbleTopToContetTopForAudio,
                                                              SelfBubbleLeftToContentForAudio,
                                                              ContentButtomToBubbleForAudio,
                                                              SelfBubbleRightToContentForAudio) : UIEdgeInsetsMake(BubbleTopToContetTopForAudio,
                                                                                                                    OtherBubbleLeftToContentForAudio,
                                                                                                                    ContentButtomToBubbleForAudio,
                                                                                                                    OtherContentRightToBubbleForAudio);
            break;
        }
        case NIMMessageTypeNotification:
            contentInsets = UIEdgeInsetsZero;
            break;
        default:
        {
            contentInsets = [self isFromMe]? UIEdgeInsetsMake(UnknowBubbleTopToContetTop,
                                                              UnknowSelfBubbleLeftToContent,
                                                              UnknowContentButtomToBubble,
                                                              UnknowSelfBubbleRightToContent):UIEdgeInsetsMake(UnknowBubbleTopToContetTop,             UnknowOtherBubbleLeftToContent,
                                                                  UnknowContentButtomToBubble,                                        UnknowOtherContentRightToBubble);
            break;
        }
    }
    
    return contentInsets;
}

- (CGFloat)retryButtonBubblePadding {
    if (self.msgData.messageType == NIMMessageTypeAudio) {
        return [self isFromMe]?15:13;
    }
    return [self isFromMe]?8:10;
}

- (CGFloat)cellHeight
{
    CGSize bubbleSize = [self bubbleViewSize];
    UIEdgeInsets bubbleInsets = [self bubbleViewInsets];
    CGFloat cellHeight = bubbleSize.height + bubbleInsets.top + bubbleInsets.bottom;
    return [self cellHeight:cellHeight];
}

#pragma mark - 显示内容
- (BOOL)nickNameShow
{
    return (!self.isFromMe && [[self.msgData session] sessionType] == NIMSessionTypeTeam);
}

#pragma mark - private methods
- (CGFloat)cellHeight:(CGFloat)adjustHeight
{
    CGFloat resultHeight = adjustHeight;
    switch ([self.msgData messageType]) {
        case NIMMessageTypeAudio:
        {
            resultHeight = MAX(OtherCellMinHeightForAudio, resultHeight);
            break;
        }
        case NIMMessageTypeText:
        {
            resultHeight = MAX(CellMinHeightForText, resultHeight);
            break;
        }
        case NIMMessageTypeNotification:{
            break;
        }
        default:
        {
            NSInteger minHeight = [self isFromMe]? SelfCellMinHeight: OtherCellMinHeight;
            if (resultHeight <= minHeight)
            {
                resultHeight = minHeight;
            }
            break;
        }
    }
    return resultHeight;
}

@end
