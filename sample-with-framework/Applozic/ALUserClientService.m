//
//  ALUserClientService.m
//  Applozic
//
//  Created by Devashish on 21/12/15.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import "ALUserClientService.h"
#import <Foundation/Foundation.h>
#import "ALConstant.h"
#import "ALUserDefaultsHandler.h"
#import "ALRequestHandler.h"
#import "ALResponseHandler.h"
#import  "ALContact.h"

@implementation ALUserClientService

+(void)userLastSeenDetail:(NSNumber *)lastSeenAt withCompletion:(void(^)(ALLastSeenSyncFeed *))completionMark
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/status",KBASE_URL];
    if(!lastSeenAt){
        lastSeenAt = [ALUserDefaultsHandler getLastSyncTime];
        NSLog(@"lastSeenAt is coming as null seeting default vlaue to %@", lastSeenAt);
    }
    NSString * theParamString = [NSString stringWithFormat:@"lastSeenAt=%@",lastSeenAt.stringValue];
    NSLog(@"calling last seen at api for userIds: %@", theParamString);
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_LAST_SEEN_NEW" WithCompletionHandler:^(id theJson, NSError *theError) {
        if (theError)
        {
            NSLog(@"ERROR IN LAST SEEN %@", theError);
        }
        else
        {
            NSLog(@"SEVER RESPONSE FROM JSON : %@", (NSString *)theJson);
            NSNumber * generatedAt =  [theJson  valueForKey:@"generatedAt"];
            [ALUserDefaultsHandler setLastSeenSyncTime:generatedAt];
            ALLastSeenSyncFeed  * responseFeed =  [[ALLastSeenSyncFeed alloc] initWithJSONString:(NSString*)theJson];
            
            completionMark(responseFeed);
        }
        
        
    }];
}

-(void)updateUserDisplayName:(ALContact *)alContact withCompletion:(void(^)(id theJson, NSError *theError))completion
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/name", KBASE_URL];
    NSString * theParamString = [NSString stringWithFormat:@"userId=%@&displayName=%@", alContact.userId, alContact.displayName];
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_DISPLAY_NAME_UPDATE" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        if (theError)
        {
            completion(nil,theError);
            return ;
        }
        else
        {
            NSLog(@"Response of USER_DISPLAY_NAME_UPDATE : %@", (NSString *)theJson);
            completion((NSString *)theJson, nil);
        }
        
    }];
}

-(void)subProcessUserDetailServerCall:(NSString *)paramString withCompletion:(void(^)(NSMutableArray * userDetailArray, NSError * theError))completionMark
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/detail",KBASE_URL];
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:paramString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USERS_DETAIL" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        if (theError)
        {
            completionMark(nil, theError);
            NSLog(@"ERROR_IN_USERS_DETAILS : %@", theError);
            return;
        }
        
        NSLog(@"SEVER_RESPONSE :: %@", (NSString *)theJson);
        NSArray * jsonArray = [NSArray arrayWithArray:(NSArray *)theJson];
        
        if(jsonArray.count)
        {
            NSMutableArray * ALLUserDetailArray = [NSMutableArray new];
            NSDictionary * JSONDictionary = (NSDictionary *)theJson;
            for (NSDictionary * theDictionary in JSONDictionary)
            {
                ALUserDetail * userDetail = [[ALUserDetail alloc] initWithDictonary:theDictionary];
                [ALLUserDetailArray addObject:userDetail];
            }
            completionMark(ALLUserDetailArray, theError);
        }
    }];
}

@end
