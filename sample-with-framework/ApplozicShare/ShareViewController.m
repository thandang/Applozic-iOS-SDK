//
//  ShareViewController.m
//  ApplozicShare
//
//  Created by apple on 25/04/19.
//  Copyright © 2019 applozic Inc. All rights reserved.
//

#import "ShareViewController.h"
#import <Applozic/Applozic.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {


    dispatch_async(dispatch_get_main_queue(), ^{

        ALMessage * theMessage = [ALMessage new];
        theMessage.type = @"5";
        theMessage.createdAtTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
        theMessage.deviceKey = [ALUserDefaultsHandler getDeviceKeyString];
        theMessage.message = @"This is text message";
        theMessage.sendToDevice = NO;
        theMessage.shared = NO;
        theMessage.fileMeta = nil;
        theMessage.storeOnDevice = NO;
        theMessage.key = [[NSUUID UUID] UUIDString];
        theMessage.delivered = NO;
        theMessage.fileMetaKey = nil;
        theMessage.source = SOURCE_IOS;

        ALChatLauncher* chatmanager = [[ALChatLauncher alloc] init];
        [chatmanager launchContactScreenWithMessage:theMessage andFromViewController:self];

    });


    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    //[self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}


- ( NSString * ) saveImageToAppGroupFolder: ( UIImage * ) image
                                imageIndex: ( int ) imageIndex
{
    assert( NULL != image );

    NSData * jpegData = UIImageJPEGRepresentation( image, 1.0 );

    NSURL * containerURL = [ [ NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: @"group.com.applozic.share"];
    NSString * documentsPath = containerURL.path;

    // Note that we aren't using massively unique names for the files in this example:
    NSString * fileName = [ NSString stringWithFormat: @"image%d.jpg", imageIndex ];

    NSString * filePath = [ documentsPath stringByAppendingPathComponent: fileName ];
    [ jpegData writeToFile: filePath atomically: YES ];

    //Mahantesh -- Store image url to NSUserDefaults
    return filePath;
}



- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
