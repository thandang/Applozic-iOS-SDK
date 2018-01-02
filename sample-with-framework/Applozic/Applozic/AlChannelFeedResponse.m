//
//  AlChannelFeedResponse.m
//  Applozic
//
//  Created by Nitin on 20/10/17.
//  Copyright © 2017 applozic Inc. All rights reserved.
//

#import "AlChannelFeedResponse.h"
#import "ALChannelCreateResponse.h"
#import "ALUserDetail.h"
#import "ALContactDBService.h"

@implementation AlChannelFeedResponse


-(instancetype)initWithJSONString:(NSString *)JSONString
{
    self = [super initWithJSONString:JSONString];
    
    if([super.status isEqualToString: RESPONSE_SUCCESS])
    {
        NSDictionary *JSONDictionary = [JSONString valueForKey:@"response"];
        self.alChannel = [[ALChannel alloc] initWithDictonary:JSONDictionary];
        [self pasreUserDetails:[[NSMutableArray alloc] initWithArray:[JSONDictionary objectForKey:@"users"]]];
        
        return self;
    }
    else
    {
        return self;
    }
    
}

-(void) pasreUserDetails:(NSMutableArray * ) userDetailJsonArray {
    
    for(NSDictionary *JSONDictionaryObject in userDetailJsonArray)
    {
        ALUserDetail *userDetail = [[ALUserDetail alloc] initWithDictonary:JSONDictionaryObject];
        ALContactDBService * contactDB = [ALContactDBService new];
        [contactDB updateUserDetail: userDetail];
    }
}


@end
