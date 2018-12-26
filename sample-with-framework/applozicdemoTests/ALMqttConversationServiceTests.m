//
//  ALMqttConversationServiceTests.m
//  applozicdemoTests
//
//  Created by Mukesh on 26/12/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Applozic/Applozic.h>
#import "MqttConversationDelegateObjectMock.h"
#import <OCMock/OCMock.h>

@interface ALMqttConversationServiceTests : XCTestCase

@end

@implementation ALMqttConversationServiceTests

ALMQTTConversationService *mqttService;
MqttConversationDelegateObjectMock *mockMqttObject;

- (void)setUp {
    mqttService = [ALMQTTConversationService sharedInstance];
    mockMqttObject = [[MqttConversationDelegateObjectMock alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMqttConversationDelegate_createsWeakRelationship {

    __weak typeof(mockMqttObject) weakFakeObject = mockMqttObject;
    mqttService.mqttConversationDelegate = mockMqttObject;

    mockMqttObject = nil;
    XCTAssertNil(weakFakeObject);
}

- (void)testRealTimeUpdateDelegate_createsWeakRelationship {

    __weak typeof(mockMqttObject) weakFakeObject = mockMqttObject;
    mqttService.realTimeUpdate = mockMqttObject;

    mockMqttObject = nil;
    XCTAssertNil(weakFakeObject);
}

@end
