//
//  ALUserDefaultsHandler.h
//  ChatApp
//
//  Created by shaik riyaz on 12/08/15.
//  Copyright (c) 2015 AppLogic. All rights reserved.
//

#define APPLICATION_KEY @"com.applozic.userdefault.APPLICATION_KEY"
#define EMAIL_VERIFIED @"com.applozic.userdefault.EMAIL_VERIFIED"
#define DISPLAY_NAME @"com.applozic.userdefault.DISPLAY_NAME"
#define NOTIFICATION_TITLE @"com.applozic.userdefault.NOTIFICATION_TITLE"
#define DEVICE_KEY_STRING @"com.applozic.userdefault.DEVICE_KEY_STRING"
#define USER_KEY_STRING @"com.applozic.userdefault.USER_KEY_STRING"
#define EMAIL_ID @"com.applozic.userdefault.EMAIL_ID"
#define USER_ID @"com.applozic.userdefault.USER_ID"
#define APN_DEVICE_TOKEN @"com.applozic.userdefault.APN_DEVICE_TOKEN"
#define LAST_SYNC_TIME @"com.applozic.userdefault.LAST_SYNC_TIME"
#define CONVERSATION_DB_SYNCED @"com.applozic.userdefault.CONVERSATION_DB_SYNCED"
#define LOGOUT_BUTTON_VISIBLITY @"com.applozic.userdefault.LOGOUT_BUTTON_VISIBLITY"
#define BOTTOM_TAB_BAR_VISIBLITY @"com.applozic.userdefault.BOTTOM_TAB_BAR_VISIBLITY"
#define BACK_BTN_VISIBILITY_ON_CON_LIST @"com.applozic.userdefault.BACK_BTN_VISIBILITY_ON_CON_LIST"
#define CONVERSATION_CONTACT_IMAGE_VISIBILITY @"com.applozic.userdefault.CONVERSATION_CONTACT_IMAGE_VISIBILITY"
#define MSG_LIST_CALL_SUFIX @"com.applozic.userdefault.MSG_CALL_MADE"
#define PROCESSED_NOTIFICATION_IDS @"com.applozic.userdefault.PROCESSED_NOTIFICATION_IDS"
#define LAST_SEEN_SYNC_TIME @"com.applozic.userdefault.LAST_SEEN_SYNC_TIME"
#define SHOW_LOAD_MORE_BUTTON @"com.applozic.userdefault.SHOW_LOAD_MORE_BUTTON"
#define DEVICE_APNS_TYPE_ID @"com.applozic.userdefault.DEVICE_APNS_TYPE"

#define KEY_PREFIX @"com.applozic.userdefault"

#import <Foundation/Foundation.h>

@interface ALUserDefaultsHandler : NSObject

+(void) setConversationContactImageVisibility: (BOOL) visibility;

+(BOOL) isConversationContactImageVisible;

+(void) setBottomTabBarHidden: (BOOL) visibleStatus;

+(BOOL) isBottomTabBarHidden;

+(void) setLogoutButtonHidden: (BOOL)flagValue;

+(BOOL) isLogoutButtonHidden;

+(void) setBackButtonHidden: (BOOL)flagValue;

+(BOOL) isBackButtonHidden;

+(BOOL) isLoggedIn;

+(void) clearAll;

+(NSString *) getApplicationKey;

+(void) setApplicationKey: (NSString*) applicationKey;

+(void) setEmailVerified: (BOOL) value;

+(void) setApnDeviceToken: (NSString*) apnDeviceToken;

+(NSString *) getApnDeviceToken;

+(void) setBoolForKey_isConversationDbSynced:(BOOL) value;

+(BOOL) getBoolForKey_isConversationDbSynced;

+(void) setDeviceKeyString:(NSString*)deviceKeyString;

+(void) setUserKeyString:(NSString*)userKeyString;

+(void) setDisplayName:(NSString*)displayName;

+(void) setEmailId:(NSString*)emailId;
+(NSString *)getEmailId;
+(NSString *) getDeviceKeyString;

+(void) setUserId: (NSString *) userId;

+(NSString*)getUserId;

+(void) setLastSyncTime: (NSNumber *) lastSyncTime;

+(void)setServerCallDoneForMSGList:(BOOL) value forContactId:(NSString*)constactId;

+(BOOL)isServerCallDoneForMSGList:(NSString *) contactId;

+(void) setProcessedNotificationIds:(NSMutableArray*) arrayWithIds;

+(NSMutableArray*) getProcessedNotificationIds;

+(BOOL)isNotificationProcessd:(NSString*)withNotificationId;

+(NSNumber *) getLastSeenSyncTime;

+(void ) setLastSeenSyncTime :(NSNumber*) lastSeenTime;

+(void)setShowLoadMore:(BOOL) value forContactId:(NSString*)constactId;

+(BOOL)isShowLoadMore:(NSString *) contactId;

+(void)setNotificationTitle:(NSString *)notificationTitle;

+(NSString *)getNotificationTitle;

+(void)setDeviceApnsType:(short)type;
+(short)getDeviceApnsType;

+(NSNumber *)getLastSyncTime;
+(NSString *)getUserKeyString;
+(NSString *)getDisplayName;
@end
