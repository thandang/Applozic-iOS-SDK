//
//  KMConversationFeed.h
//  Applozic
//
//  Created by Sunil on 16/02/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALJson.h"

@interface KMConversation : ALJson

@property (nonatomic, strong) NSNumber *groupId;
@property (nonatomic, strong) NSString *participentUserId;
@property (nonatomic, strong) NSString *defaultAgentId;
@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *createdBy;

-(id)initWithDictonary:(NSDictionary *)messageDictonary;

@end
