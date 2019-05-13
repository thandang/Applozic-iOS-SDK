//
//  ALInternalSettings.m
//  Applozic
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 applozic Inc. All rights reserved.
//

#import "ALInternalSettings.h"

@implementation ALInternalSettings

+(void)setRegistrationStatusMessage:(NSString*)message{

    [[NSUserDefaults standardUserDefaults] setValue:message forKey:REGISTRATION_STATUS_MESSAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getRegistrationStatusMessage{

    NSString *pushRegistrationStatusMessage  =  [[NSUserDefaults standardUserDefaults] valueForKey:REGISTRATION_STATUS_MESSAGE];
    return pushRegistrationStatusMessage  != nil ? pushRegistrationStatusMessage : AL_REGISTERED;

}

@end
