//
//  applozicdemoTests.m
//  applozicdemoTests
//
//  Created by Mukesh Thawani on 20/06/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Applozic/Applozic.h>

@interface ALRegisterUserClientService (Testing)

-(NSString *)getUserParamTextForLogging:(ALUser *)user;

@end

@interface ALRegisterUserClientServiceTests: XCTestCase

@end

@implementation ALRegisterUserClientServiceTests

ALRegisterUserClientService *clientService;

- (void)setUp {
    [super setUp];
    clientService = [[ALRegisterUserClientService alloc] init];
}

- (void)testUserParamTextWhenPasswordIsPresent {
    ALUser *user = [[ALUser alloc] initWithUserId:@"testUserId" password:@"myPass" email:@"" andDisplayName:@"testing"];
    NSString *userParam =  [clientService getUserParamTextForLogging:user];
    XCTAssertNotNil(userParam);
    XCTAssertTrue([userParam containsString:@"\"password\":\"***\""]);
}

- (void)testUserParamTextWhenPasswordIsNotPresent {
    ALUser *user = [[ALUser alloc] initWithUserId:@"testUserId" password:nil email:@"" andDisplayName:@"testing"];
    NSString *userParam =  [clientService getUserParamTextForLogging:user];
    XCTAssertNotNil(userParam);
    XCTAssertTrue([userParam containsString:@"\"password\":\"\""]);
}

@end
