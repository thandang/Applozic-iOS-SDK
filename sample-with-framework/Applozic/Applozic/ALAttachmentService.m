//
//  ALAttachmentService.m
//  Applozic
//
//  Created by Sunil on 25/09/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import "ALAttachmentService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ALMessageClientService.h"
#import "ApplozicClient.h"
#import "ALMessageService.h"

@implementation ALAttachmentService


+(ALAttachmentService *)sharedInstance
{
    static ALAttachmentService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ALAttachmentService alloc] init];
    });
    return sharedInstance;
}


-(void)sendMessageWithAttachment:(ALMessage*) attachmentMessage withDelegate:(id<ApplozicUpdatesDelegate>) delegate withAttachmentDelegate:(id<ApplozicAttachmentDelegate>)attachmentProgressDelegate{
    
    if(!attachmentMessage || !attachmentMessage.imageFilePath){
        return;
    }
    self.delegate = delegate;
    self.attachmentProgressDelegate = attachmentProgressDelegate;
    
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[attachmentMessage.imageFilePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    
    attachmentMessage.fileMeta.contentType = mimeType;
    if( attachmentMessage.contentType == ALMESSAGE_CONTENT_VCARD){
        attachmentMessage.fileMeta.contentType = @"text/x-vcard";
    }
    NSData *imageSize = [NSData dataWithContentsOfFile:attachmentMessage.imageFilePath];
    attachmentMessage.fileMeta.size = [NSString stringWithFormat:@"%lu",(unsigned long)imageSize.length];
    
    //DB Addition

    ALMessageDBService *alMessageDbService = [[ALMessageDBService alloc]init];

    DB_Message *dbMessage =   [alMessageDbService addAttachmentMessage:attachmentMessage];

    NSDictionary * userInfo = [attachmentMessage dictionary];
    
    ALMessageClientService * clientService  = [[ALMessageClientService alloc]init];
    [clientService sendPhotoForUserInfo:userInfo withCompletion:^(NSString *responseUrl, NSError *error) {
        
        if (error)
        {
            
            [self.attachmentProgressDelegate onUploadFailed:[[ALMessageService sharedInstance] handleMessageFailedStatus:attachmentMessage]];
            return;
        }

        ALHTTPManager *httpManager = [[ALHTTPManager alloc]init];
        httpManager.attachmentProgressDelegate = self.attachmentProgressDelegate;
        httpManager.delegate = self.delegate;
        ALUploadTask * alUploadTask = [[ALUploadTask alloc]init];
        alUploadTask.identifier = dbMessage.key;
        httpManager.uploadTask = alUploadTask;
        [httpManager proessUploadFileForMessage:[alMessageDbService createMessageEntity:dbMessage] uploadURL:responseUrl];
    }];
    
}

-(void) downloadMessageAttachment:(ALMessage*)alMessage withDelegate:(id<ApplozicAttachmentDelegate>)attachmentProgressDelegate{
    
    self.attachmentProgressDelegate = attachmentProgressDelegate;
    ALDownloadTask * downloadTask = [[ALDownloadTask alloc]init];
    downloadTask.identifier = alMessage.key;
    downloadTask.isThumbnail = NO;

    ALHTTPManager * manager =  [[ALHTTPManager alloc] init];
    manager.downloadTask = downloadTask;
    manager.attachmentProgressDelegate = self.attachmentProgressDelegate;
    [manager processDownloadforMessage:alMessage];

}

-(void) downloadImageThumbnail:(ALMessage*)alMessage withDelegate:(id<ApplozicAttachmentDelegate>)attachmentProgressDelegate{

    self.attachmentProgressDelegate = attachmentProgressDelegate;
    ALDownloadTask * downloadTask = [[ALDownloadTask alloc]init];
    downloadTask.identifier = alMessage.key;
    downloadTask.isThumbnail = YES;

    ALHTTPManager * manager =  [[ALHTTPManager alloc] init];
    manager.downloadTask = downloadTask;
    manager.attachmentProgressDelegate = self.attachmentProgressDelegate;
    [manager processDownloadforMessage:alMessage];
}


@end
