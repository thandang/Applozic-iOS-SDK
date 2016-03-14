//
//  ALApplozicSettings.m
//  Applozic
//
//  Created by devashish on 20/11/2015.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import "ALApplozicSettings.h"

@interface ALApplozicSettings ()

@end

@implementation ALApplozicSettings

+(void)setFontFace:(NSString *)fontFace
{
    [[NSUserDefaults standardUserDefaults] setValue:fontFace forKey:FONT_FACE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getFontFace
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:FONT_FACE];
}

+(void)setTitleForConversationScreen:(NSString *)titleText
{
    [[NSUserDefaults standardUserDefaults] setValue:titleText forKey:CONVERSATION_TITLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getTitleForConversationScreen
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:CONVERSATION_TITLE];
}

+(void)setUserProfileHidden: (BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:USER_PROFILE_PROPERTY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isUserProfileHidden
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USER_PROFILE_PROPERTY];
}

+(void) clearAllSettings
{
    NSLog(@"cleared");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+(void)setColourForSendMessages:(UIColor *)sendMsgColour
{
    NSData *sendColorData = [NSKeyedArchiver archivedDataWithRootObject:sendMsgColour];
    [[NSUserDefaults standardUserDefaults] setObject:sendColorData forKey:SEND_MSG_COLOUR];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setColourForReceiveMessages:(UIColor *)receiveMsgColour
{
    NSData *receiveColorData = [NSKeyedArchiver archivedDataWithRootObject:receiveMsgColour];
    [[NSUserDefaults standardUserDefaults] setObject:receiveColorData forKey:RECEIVE_MSG_COLOUR];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(UIColor *)getSendMsgColour
{
    NSData *sendColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SEND_MSG_COLOUR"];
    UIColor *sendColour = [NSKeyedUnarchiver unarchiveObjectWithData:sendColorData];
    return sendColour;
}

+(UIColor *)getReceiveMsgColour
{
    NSData *receiveColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"RECEIVE_MSG_COLOUR"];
    UIColor *receiveColour = [NSKeyedUnarchiver unarchiveObjectWithData:receiveColorData];
    return receiveColour;
}

+(void)setColourForNavigation:(UIColor *)barColour
{
    NSData *barColourData = [NSKeyedArchiver archivedDataWithRootObject:barColour];
    [[NSUserDefaults standardUserDefaults] setObject:barColourData forKey:NAVIGATION_BAR_COLOUR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(UIColor *)getColourForNavigation
{
    NSData *barColourData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NAVIGATION_BAR_COLOUR"];
    UIColor *barColour = [NSKeyedUnarchiver unarchiveObjectWithData:barColourData];
    return barColour;
}

+(void)setColourForNavigationItem:(UIColor *)barItemColour
{
    NSData *barItemColourData = [NSKeyedArchiver archivedDataWithRootObject:barItemColour];
    [[NSUserDefaults standardUserDefaults] setObject:barItemColourData forKey:NAVIGATION_BAR_ITEM_COLOUR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(UIColor *)getColourForNavigationItem
{
    NSData *barItemColourData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NAVIGATION_BAR_ITEM_COLOUR"];
    UIColor *barItemColour = [NSKeyedUnarchiver unarchiveObjectWithData:barItemColourData];
    return barItemColour;
}

+(void)hideRefreshButton:(BOOL)state
{
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:REFRESH_BUTTON_VISIBILITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isRefreshButtonHidden
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:REFRESH_BUTTON_VISIBILITY];
}

+(void)setTitleForBackButton:(NSString *)backButtonTitle
{
    [[NSUserDefaults standardUserDefaults] setValue:backButtonTitle forKey:BACK_BUTTON_TITLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getBackButtonTitle
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:BACK_BUTTON_TITLE];
}

+(void)setNotificationTitle:(NSString *)notificationTitle
{
    [[NSUserDefaults standardUserDefaults] setValue:notificationTitle forKey:NOTIFICATION_TITLE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getNotificationTitle{
    return [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATION_TITLE];
}

+(void)setTitleFontFace:(NSString *)fontFace
{
    [[NSUserDefaults standardUserDefaults] setValue:fontFace forKey:TITLE_FONT_FACE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getTitleFontFace
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:TITLE_FONT_FACE];
}

@end
