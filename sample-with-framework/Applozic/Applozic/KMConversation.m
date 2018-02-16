//
//  KMConversationFeed.m
//  Applozic
//
//  Created by Sunil on 16/02/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import "KMConversation.h"

@implementation KMConversation



-(id)initWithDictonary:(NSDictionary *)messageDictonary
{
    [self parseMessage:messageDictonary];
    return self;
}

-(void)parseMessage:(id) messageJson
{
    self.groupId = [self getNSNumberFromJsonValue:messageJson[@"groupId"]];
    self.participentUserId = [self getStringFromJsonValue:messageJson[@"participentUserId"]];
    self.defaultAgentId = [self getStringFromJsonValue:messageJson[@"defaultAgentId"]];
    self.createdBy = [self getStringFromJsonValue:messageJson[@"applicationId"]];

}



@end
