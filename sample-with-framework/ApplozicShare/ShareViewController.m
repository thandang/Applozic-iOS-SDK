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

    self.passSelectedItemsToApp;
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    //[self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}


- ( NSString * ) saveImageToAppGroupFolder: ( UIImage * ) image{

    assert( NULL != image );

    NSString * docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * timestamp = [NSString stringWithFormat:@"IMG-%f.jpeg",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString * filePath = [docDirPath stringByAppendingPathComponent:timestamp];
    NSData * imageData = [image getCompressedImageData];
    [ imageData writeToFile: filePath atomically: YES ];
    return filePath;
}



- ( void ) passSelectedItemsToApp
{
    NSExtensionItem * item = self.extensionContext.inputItems.firstObject;

    // Reset the counter and the argument list for invoking the app:

    // Iterate through the attached files
    for ( NSItemProvider * itemProvider in item.attachments )
    {
        // Check if we are sharing a Image
        if ( [ itemProvider hasItemConformingToTypeIdentifier: ( NSString * ) kUTTypeImage ] )
        {
            // Load it, so we can get the path to it
            [ itemProvider loadItemForTypeIdentifier: ( NSString * ) kUTTypeImage
                                             options: NULL
                                   completionHandler: ^ ( UIImage * image, NSError * error )
             {

                 if ( NULL != error )
                 {
                     NSLog( @"There was an error retrieving the attachments: %@", error );
                     return;
                 }

                 // The app won't be able to access the images by path directly in the Camera Roll folder,
                 // so we temporary copy them to a folder which both the extension and the app can access:
                 NSString * filePath = [ self saveImageToAppGroupFolder: image];
                 [self buildAttachmentMessageWithFilePath:filePath];
             } ];
        }
    }
}


-(void)buildAttachmentMessageWithFilePath:(NSString *)filePath{

    ALFileMetaInfo *info = [ALFileMetaInfo new];

    info.blobKey = nil;
    info.contentType = @"";
    info.createdAtTime = nil;
    info.key = nil;
    info.name = @"";
    info.size = @"";
    info.userKey = @"";
    info.thumbnailUrl = @"";
    info.progressValue = 0;

    ALMessage * theMessage = [ALMessage new];
    theMessage.type = @"5";
    theMessage.fileMeta = info;
    theMessage.imageFilePath = [filePath lastPathComponent];
    theMessage.createdAtTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    theMessage.deviceKey = [ALUserDefaultsHandler getDeviceKeyString];
    theMessage.message = @"This is text message";
    theMessage.sendToDevice = NO;
    theMessage.shared = NO;
    theMessage.fileMeta = info;
    theMessage.storeOnDevice = NO;
    theMessage.key = [[NSUUID UUID] UUIDString];
    theMessage.delivered = NO;
    theMessage.fileMetaKey = nil;
    theMessage.source = SOURCE_IOS;
    [self launchContactScreen:theMessage];
}


-(void)launchContactScreen:(ALMessage *)message{
        ALChatLauncher* chatmanager = [[ALChatLauncher alloc] init];
        [chatmanager launchContactScreenWithMessage:message andFromViewController:self];
}


- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
