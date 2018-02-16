//
//  KMConversationClientService.h
//  Applozic
//
//  Created by Sunil on 16/02/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMConversation.h"
#import "KMResponse.h"

#define CONVERSATION_CREATE_API @"https://api.kommunicate.io/conversations"

@interface KMConversationClientService : NSObject

-(void)createConversation :(KMConversation *) conversation withCompletion:(void(^)(NSError *error, KMResponse *response))completion;


@end
