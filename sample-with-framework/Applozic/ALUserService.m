//
//  ALUserService.m
//  Applozic
//
//  Created by Divjyot Singh on 05/11/15.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import "ALUserService.h"
#import "ALRequestHandler.h"
#import "ALResponseHandler.h"
#import "ALUtilityClass.h"
#import "ALSyncMessageFeed.h"
#import "ALMessageDBService.h"
#import "ALMessageList.h"
#import "ALMessageClientService.h"
#import "ALMessageService.h"
#import "ALContactDBService.h"
#import "ALMessagesViewController.h"
#import "ALLastSeenSyncFeed.h"
#import "ALUserDefaultsHandler.h"
#import "ALUserClientService.h"
#import "ALUserDetail.h"
#import "ALMessageDBService.h"
#import "ALAPIResponse.h"


@implementation ALUserService


//1. call this when each message comes

+ (void)processContactFromMessages:(NSArray *) messagesArr withCompletion:(void(^)())completionMark
{
    
    NSMutableOrderedSet* contactIdsArr=[[NSMutableOrderedSet alloc] init ];
    NSMutableString * repString=[[NSMutableString alloc] init];
    ALContactDBService* dbObj=[[ALContactDBService alloc] init];
    for(ALMessage* msg in messagesArr) {
        if(![dbObj getContactByKey:@"userId" value:msg.contactIds]) {
            NSMutableString* appStr=[[NSMutableString alloc] initWithString:msg.contactIds];
            [appStr insertString:@"&userIds=" atIndex:0];
            [contactIdsArr addObject:appStr];
        }
    }
    
    if ([contactIdsArr count] == 0) {
         completionMark();
        return;
    };
    for(NSString* strr in contactIdsArr)
    {
        [repString appendString:strr];
    }
    
    NSLog(@"USER_ID_STRING :: %@",repString);
    
    ALUserClientService * client = [ALUserClientService new];
    [client subProcessUserDetailServerCall:repString withCompletion:^(NSMutableArray * userDetailArray, NSError * error) {
        
        if(error)
        {
            completionMark();
            return;
        }
        ALContactDBService * contactDB = [ALContactDBService new];
        for(ALUserDetail * userDetail in userDetailArray)
        {
            [contactDB updateUserDetail: userDetail];
        }
        
        completionMark();
        
    }];
}

+(void)getLastSeenUpdateForUsers:(NSNumber *)lastSeenAt withCompletion:(void(^)(NSMutableArray *))completionMark
{
    
    [ALUserClientService userLastSeenDetail:lastSeenAt withCompletion:^(ALLastSeenSyncFeed * messageFeed) {
    NSMutableArray* lastSeenUpdateArray=   messageFeed.lastSeenArray;
        ALContactDBService *contactDBService =  [[ALContactDBService alloc]init];
        for ( ALUserDetail * userDetail in lastSeenUpdateArray){
            [ contactDBService updateUserDetail:userDetail];
        }
        completionMark(lastSeenUpdateArray);
    }];
    
}

+(void)updateUserDisplayName:(ALContact *)alContact{
    if(alContact.userId && alContact.displayName){
        ALUserClientService * alUserClientService  = [[ALUserClientService alloc] init];
        [alUserClientService updateUserDisplayName:alContact withCompletion:^(id theJson, NSError *theError) {
            
            if(theError){
                NSLog(@"GETTING ERROR in SEVER CALL FOR DISPLAY NAME");
            }
            else{
                ALAPIResponse *apiResponse = [[ALAPIResponse alloc] initWithJSONString:theJson];
            }
        }];
    }
    
    else{
        return;
    }
}

@end

