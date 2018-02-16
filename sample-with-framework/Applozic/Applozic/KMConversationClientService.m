//
//  KMConversationClientService.m
//  Applozic
//
//  Created by Sunil on 16/02/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import "ALRequestHandler.h"
#import "ALResponseHandler.h"

#import "KMConversationClientService.h"

@implementation KMConversationClientService

-(void)createConversation :(KMConversation *) conversation withCompletion:(void(^)(NSError *error, KMResponse *response))completion
{
    
    NSError * error;
    NSData * postdata = [NSJSONSerialization dataWithJSONObject:conversation.dictionary options:0 error:&error];
    NSString *paramString = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    
    NSLog(@"PARAM_POST_CALL : %@",paramString);
    
    NSMutableURLRequest * theRequest = [ALRequestHandler createPOSTRequestWithUrlString:CONVERSATION_CREATE_API paramString:paramString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"KM_CONVERSATION_CREATE" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        KMResponse* kmResponse;
        NSLog(@"KM_CONVERSATION_CREATE server call response : %@", (NSString *)theJson);
        if (theError)
        {
            completion(theError,nil );
            NSLog(@"ERROR_SEVER_RESPONSE_POST_KM_CONVERSATION_CREATE: %@", theError);
            return;
        }else{
            kmResponse = [[KMResponse alloc] initWithJSONString:theJson];
        }
        
        completion(theError,kmResponse);
    }];
    
}

@end
