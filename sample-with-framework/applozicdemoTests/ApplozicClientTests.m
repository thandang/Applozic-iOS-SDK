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

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)test_whenMessageSentSuccessfully_thatErrorIsNil{
    ApplozicClient * client = [[ApplozicClient alloc] init];;
    id mockConnection = OCMClassMock([ALMessageService class]);
    client.messageService = mockConnection;

    ALMessage *alMessage = [ALMessage build:^(ALMessgaeBuilder * alMessageBuilder) {
        alMessageBuilder.to = @"userId";
        alMessageBuilder.message = @"messageText";
    }];

    OCMStub([mockConnection sendMessages:alMessage withCompletion:([OCMArg invokeBlockWithArgs:@"message",[OCMArg defaultValue], nil])]);
    [client sendTextMessage:alMessage withCompletion:^(ALMessage* message, NSError* error) {
        XCTAssert(error == nil);
        XCTAssert([message.message isEqualToString:@"messageText"]);
    }];
}

- (void)test_whenMessageSentUnsuccessful_thatErrorIsPresent{
    ApplozicClient * client = [[ApplozicClient alloc] init];
    id mockConnection = OCMClassMock([ALMessageService class]);
    client.messageService = mockConnection;

    ALMessage *alMessage = [ALMessage build:^(ALMessgaeBuilder * alMessageBuilder) {
        alMessageBuilder.to = @"userId";
        alMessageBuilder.message = @"messageText";
    }];
    NSError *theError = [NSError errorWithDomain:@"Network Error" code:999 userInfo:nil];
    OCMStub([mockConnection sendMessages:alMessage withCompletion:([OCMArg invokeBlockWithArgs:@"message", theError, nil])]);
    [client sendTextMessage:alMessage withCompletion:^(ALMessage* message, NSError* error) {
        XCTAssert(error.code == 999);
        XCTAssert(message == nil);
    }];
}

@end
