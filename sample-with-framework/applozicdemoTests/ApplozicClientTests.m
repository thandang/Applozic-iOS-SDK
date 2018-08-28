//
//  ApplozicClientTests.m
//  applozicdemoTests
//
//  Created by Mukesh Thawani on 23/08/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Applozic/Applozic.h>
#import <OCMock/OCMock.h>

@interface ApplozicClientTests : XCTestCase

@end

@implementation ApplozicClientTests

ApplozicClient * client;
id mockService;
ALMessage *testMessage;

- (void)setUp {
    [super setUp];
    client = [[ApplozicClient alloc] init];
    mockService = OCMClassMock([ALMessageService class]);
    client.messageService = mockService;

    testMessage = [ALMessage build:^(ALMessgaeBuilder * alMessageBuilder) {
        alMessageBuilder.to = @"userId";
        alMessageBuilder.message = @"messageText";
    }];
}

- (void)test_whenMessageSentSuccessfully_thatErrorIsNil{

    OCMStub([mockService sendMessages:testMessage withCompletion:([OCMArg invokeBlockWithArgs:@"message",[OCMArg defaultValue], nil])]);
    [client sendTextMessage:testMessage withCompletion:^(ALMessage* message, NSError* error) {
        XCTAssert(error == nil);
        XCTAssert([message.message isEqualToString:@"messageText"]);
    }];
}

- (void)test_whenMessageSentUnsuccessful_thatErrorIsPresent{

    NSError *theError = [NSError errorWithDomain:@"Network Error" code:999 userInfo:nil];
    OCMStub([mockService sendMessages:testMessage withCompletion:([OCMArg invokeBlockWithArgs:@"message", theError, nil])]);
    [client sendTextMessage:testMessage withCompletion:^(ALMessage* message, NSError* error) {
        XCTAssert(error.code == 999);
        XCTAssert(message == nil);
    }];
}

- (void)test_whenMessagePassedIsNil_thatErrorIsPresent{
    [client sendTextMessage:nil withCompletion:^(ALMessage* message, NSError* error) {
        XCTAssert(error.code == MessageNotPresent);
    }];
}

@end
