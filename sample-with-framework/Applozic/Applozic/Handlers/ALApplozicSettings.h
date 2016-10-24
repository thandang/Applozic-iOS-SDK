//
//  ALApplozicSettings.h
//  Applozic
//
//  Created by devashish on 20/11/2015.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#define USER_PROFILE_PROPERTY @"com.applozic.userdefault.USER_PROFILE_PROPERTY"
#define SEND_MSG_COLOUR @"com.applozic.userdefault.SEND_MSG_COLOUR"
#define RECEIVE_MSG_COLOUR @"com.applozic.userdefault.RECEIVE_MSG_COLOUR"
#define NAVIGATION_BAR_COLOUR @"com.applozic.userdefault.NAVIGATION_BAR_COLOUR"
#define NAVIGATION_BAR_ITEM_COLOUR @"com.applozic.userdefault.NAVIGATION_BAR_ITEM_COLOUR"
#define REFRESH_BUTTON_VISIBILITY @"com.applozic.userdefault.REFRESH_BUTTON_VISIBILITY"
#define CONVERSATION_TITLE @"com.applozic.userdefault.CONVERSATION_TITLE"
#define BACK_BUTTON_TITLE @"com.applozic.userdefault.BACK_BUTTON_TITLE"
#define FONT_FACE @"com.applozic.userdefault.FONT_FACE"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALApplozicSettings : NSObject

+(void)setFontFace:(NSString *)fontFace;

+(NSString *)getFontFace;

+(void)setUserProfileHidden: (BOOL)flag;

+(BOOL)isUserProfileHidden;

+(void)setColourForSendMessages:(UIColor *)sendMsgColour ;

+(void)setColourForReceiveMessages:(UIColor *)receiveMsgColour;

+(UIColor *)getSendMsgColour;

+(UIColor *)getReceiveMsgColour;

+(void)setColourForNavigation:(UIColor *)barColour;

+(UIColor *)getColourForNavigation;

+(void)setColourForNavigationItem:(UIColor *)barItemColour;

+(UIColor *)getColourForNavigationItem;

+(void)hideRefreshButton:(BOOL)state;

+(BOOL)isRefreshButtonHidden;

+(void)setTitleForConversationScreen:(NSString *)titleText;

+(NSString *)getTitleForConversationScreen;

+(void)setTitleForBackButton:(NSString *)backButtonTitle;

+(NSString *)getBackButtonTitle;

@end
