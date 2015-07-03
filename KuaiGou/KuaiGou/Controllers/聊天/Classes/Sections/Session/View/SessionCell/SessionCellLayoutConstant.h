//
//  SessionCellLayoutConstant.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef NIMDemo_SessionCellLayoutConstant_h
#define NIMDemo_SessionCellLayoutConstant_h

//气泡默认大小
#define DefaultBubbleSize                         CGSizeMake(60, 35)
#define MsgBubbleMaxWidth                         (UIScreenWidth - 130)
#define BubbleMaxWidthForText                     (UIScreenWidth - 102)  //气泡的最大宽度

#define AttachmemtImageMaxWidth                    (UIScreenWidth - 184)
#define AttachmentImageMaxHeight                   (UIScreenWidth - 184)
#define AttachmentImageMinWidth                    (UIScreenWidth / 4.0)
#define AttachmentImageMinHeight                   (UIScreenWidth / 4.0)

#define AudioContentMinWidth                       (UIScreenWidth - 280)
#define AudioContentMaxWidth                       (UIScreenWidth - 170)

#define SelfProtraitOriginX                        (UIScreenWidth - CellPaddingToProtrait - ProtraitImageWidth)

#define MsgContentMaxWidth                       (MsgBubbleMaxWidth - OtherContentRightToBubble - OtherBubbleLeftToContent)
#define MsgContentMaxWidthForText                (OtherBubbleMaxWidthForText - OtherContentRightToBubbleForText - OtherBubbleLeftToContentForText)
#define MsgContentMinWidthForText                (OtherBubbleMinWidthForText - OtherContentRightToBubbleForText - OtherBubbleLeftToContentForText)
#define LABEL_FONT_SIZE 14      // 文字大小



/*************************************************
 
 最 近 会 话 列 表
 
 **************************************************/

extern NSInteger SessionListAvatarLeft;            //头像到左边的
extern NSInteger SessionListNameTop;               //名字上边距
extern NSInteger SessionListNameLeftToAvatar;      //名字到头像的左边距
extern NSInteger SessionListMessageLeftToAvatar;   //消息到头像的左边距
extern NSInteger SessionListMessageBottom;         //消息的底边距
extern NSInteger SessionListTimeRight;             //时间框到右边距
extern NSInteger SessionListTimeTop;               //时间框的上边距
extern NSInteger SessionBadgeTimeBottom;           //未读的下边距
extern NSInteger SessionBadgeTimeRight;            //未读的右边距



/*************************************************
 
 会 话 页
 
 **************************************************/



//单元格本身定义
extern NSInteger OtherCellMinHeight;
extern NSInteger SelfCellMinHeight;
//单元格和气泡之间的距离定义
extern NSInteger CellTopToBubbleTop;    //单元格顶部到气泡顶部的距离
extern NSInteger CellBudbbleButtomToCellButtom;    //气泡底部到单元格底部的间距
//气泡定义
extern NSInteger BubbleTopToContetTop;    //气泡顶部到内容顶部的高度
extern NSInteger ContentButtomToBubble;    //内容底部到气泡底部的高度
extern NSInteger BubblePaddingForImage;
extern NSInteger BubbleArrowWidthForImage;
//其它人
extern NSInteger ProtraitRightToBubble;    //头像到气泡左边的距离
extern NSInteger CellPaddingToProtrait;
extern NSInteger ProtraitImageWidth;   //头像宽
extern NSInteger OtherBubbleOriginX;    //气泡的起始位置
//extern NSInteger kOtherBubbleMaxWidth;  //气泡的最大宽度
extern NSInteger OtherBubbleMinWidth;  //气泡的最小宽度
extern NSInteger OtherNickNameHeight;
extern NSInteger OtherBubbleLeftToContent;   //气泡左边到内容左边的宽度
extern NSInteger OtherContentRightToBubble;    //内容到气泡右边的宽度

extern NSInteger OtherContentOriginY;
extern NSInteger OtherContentOriginX;  //内容的起始位置
extern NSInteger OtberContentMaxWidth;
extern NSInteger OtherContentMinWidth;
extern NSInteger OtherBubbleArrowWidth;

//自己
extern NSInteger SelfBubbleRightToContent;   //气泡右边到内容的间距
extern NSInteger SelfBubbleLeftToContent;    //气泡左边到内容的间距
extern NSInteger SelfBubbleMinWidth;
extern NSInteger SelfBubbleArrowWidth;
extern NSInteger SelfContentMinWidth;
//audio
extern NSInteger SelfBubbleRightToContentForAudio;
extern NSInteger SelfBubbleLeftToContentForAudio;
extern NSInteger OtherBubbleLeftToContentForAudio;   //气泡左边到内容左边的宽度
extern NSInteger OtherContentRightToBubbleForAudio;    //内容到气泡右边的宽度
extern NSInteger BubbleTopToContetTopForAudio;
extern NSInteger ContentButtomToBubbleForAudio;

//text
extern NSInteger OtherBubbleLeftToContentForText;
extern NSInteger OtherContentRightToBubbleForText;
extern NSInteger OtherBubbleMinWidthForText;
extern NSInteger CellMinHeightForText;
extern NSInteger SelfBubbleRightToContentForText ;
extern NSInteger SelfBubbleLeftToContentForText;
extern NSInteger SelfBubbleMinWidthForText;

extern NSInteger OtherContentButtomToBubbleForText;    //内容底部到气泡底部的高度
extern NSInteger OtherBubbleTopToContentForText;

extern NSInteger SelfContentButtomToBubbleForText;    //内容底部到气泡底部的高度
extern NSInteger SelfBubbleTopToContentForText;

extern NSInteger AudioContentHeight;


extern NSInteger CellBubbleButtomToCellButtom;

extern NSInteger LocationMessageWidth;
extern NSInteger LocationMessageHeight;

extern NSInteger CustomMessageWidth;
extern NSInteger CustomMessageHeight;


extern NSInteger TeamNotificationMessageWidth;
extern NSInteger TeamNotificationMessageHeight;

extern NSInteger FileTransMessageWidth;
extern NSInteger FileTransMessageHeight;
extern NSInteger FileTransMessageIconLeft;
extern NSInteger FileTransMessageProgressLeft;
extern NSInteger FileTransMessageProgressRight;
extern NSInteger FileTransMessageProgressTop;
extern NSInteger FileTransMessageTitleLeft;
extern NSInteger FileTransMessageTitleTop;
extern NSInteger FileTransMessageSizeTitleRight;
extern NSInteger FileTransMessageSizeTitleBottom;

extern NSInteger UnknowMessageWidth;
extern NSInteger UnknowMessageHeight;
extern NSInteger UnknowBubbleTopToContetTop;
extern NSInteger UnknowSelfBubbleLeftToContent;
extern NSInteger UnknowContentButtomToBubble;
extern NSInteger UnknowSelfBubbleRightToContent;
extern NSInteger UnknowOtherBubbleLeftToContent;
extern NSInteger UnknowOtherContentRightToBubble;
extern NSInteger OtherCellMinHeightForAudio;

#endif
