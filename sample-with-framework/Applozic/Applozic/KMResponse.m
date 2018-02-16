//
//  KMResponse.m
//  Applozic
//
//  Created by Sunil on 16/02/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import "KMResponse.h"

@implementation KMResponse


-(id)initWithJSONString:(NSString *)JSONString
{
    [self parseMessage:JSONString];
    return self;
}

-(void)parseMessage:(id) json;
{
    self.code = [self getStringFromJsonValue:json[@"code"]];    
}




@end
