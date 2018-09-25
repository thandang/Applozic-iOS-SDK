//
//  ALAttachmentService.m
//  Applozic
//
//  Created by apple on 25/09/18.
//  Copyright © 2018 applozic Inc. All rights reserved.
//

#import "ALAttachmentService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ALMessageClientService.h"
#import "ApplozicClient.h"

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
    ALDBHandler * theDBHandler = [ALDBHandler sharedInstance];
    ALMessageDBService* messageDBService = [[ALMessageDBService alloc] init];
    DB_Message * theMessageEntity = [messageDBService createMessageEntityForDBInsertionWithMessage:attachmentMessage];;
    [theDBHandler.managedObjectContext save:nil];
    attachmentMessage.msgDBObjectId = [theMessageEntity objectID];
    theMessageEntity.inProgress = [NSNumber numberWithBool:YES];
    theMessageEntity.isUploadFailed = [NSNumber numberWithBool:NO];
    [[ALDBHandler sharedInstance].managedObjectContext save:nil];
    
    NSDictionary * userInfo = [attachmentMessage dictionary];
    
    ALMessageClientService * clientService  = [[ALMessageClientService alloc]init];
    [clientService sendPhotoForUserInfo:userInfo withCompletion:^(NSString *responseUrl, NSError *error) {
        
        if (error)
        {
            
        [self.attachmentProgressDelegate onUploadFailed:attachmentMessage];
          return;
        }
        
        [ALMessageService proessUploadImageForMessage:attachmentMessage databaseObj:theMessageEntity.fileMetaInfo uploadURL:responseUrl  withdelegate:self];
        
    }];
    
}


-(void)connectionDidFinishLoading:(ALConnection *)connection{
    
    [[[ALConnectionQueueHandler sharedConnectionQueueHandler] getCurrentConnectionQueue] removeObject:connection];
    ALMessageDBService * dbService = [[ALMessageDBService alloc] init];
    if ([connection.connectionType isEqualToString:@"Image Posting"])
    {
        DB_Message * dbMessage = (DB_Message*)[dbService getMessageByKey:@"key" value:connection.keystring];
        ALMessage * message = [dbService createMessageEntity:dbMessage];
        NSError * theJsonError = nil;
        NSDictionary *theJson = [NSJSONSerialization JSONObjectWithData:connection.mData options:NSJSONReadingMutableLeaves error:&theJsonError];
        
        if(ALApplozicSettings.isS3StorageServiceEnabled){
            [message.fileMeta populate:theJson];
        }else{
            NSDictionary *fileInfo = [theJson objectForKey:@"fileMeta"];
            [message.fileMeta populate:fileInfo];
        }
        ALMessage * almessage =  [ALMessageService processFileUploadSucess:message];
        ALMessageService *messageService = [[ALMessageService alloc] init];
        [messageService sendMessages:almessage withCompletion:^(NSString *message, NSError *error) {
            
            if(error)
            {
                NSLog(@"REACH_SEND_ERROR : %@",error);
                if(self.attachmentProgressDelegate){
                    [self.attachmentProgressDelegate onUploadFailed:almessage];
                }
                return;
            }else{
                if(self.attachmentProgressDelegate){
                    [self.attachmentProgressDelegate onUploadCompleted:almessage];
                }
                if(self.delegate){
                    [self.delegate onMessageSent:almessage];
                }
            }
        }];
        
    } else {
        
        //This is download Sucessfull...
        DB_Message * messageEntity = (DB_Message*)[dbService getMessageByKey:@"key" value:connection.keystring];
        
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *componentsArray = [messageEntity.fileMetaInfo.name componentsSeparatedByString:@"."];
        NSString *fileExtension = [componentsArray lastObject];
        NSString * filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_local.%@",connection.keystring,fileExtension]];
        [connection.mData writeToFile:filePath atomically:YES];
        
        // UPDATE DB
        messageEntity.inProgress = [NSNumber numberWithBool:NO];
        messageEntity.isUploadFailed=[NSNumber numberWithBool:NO];
        messageEntity.filePath = [NSString stringWithFormat:@"%@_local.%@",connection.keystring,fileExtension];
        [[ALDBHandler sharedInstance].managedObjectContext save:nil];
        ALMessage * almessage = [[ALMessageDBService new ] createMessageEntity:messageEntity];
        if(self.attachmentProgressDelegate){
            [self.attachmentProgressDelegate onDownloadCompleted:almessage];
        }
    }
    
}

-(void)connection:(ALConnection *)connection didReceiveData:(NSData *)data{
    
    [connection.mData appendData:data];
    
    if ([connection.connectionType isEqualToString:@"Image Posting"])
    {
        NSLog(@" file posting done");
        return;
    }
    if(self.attachmentProgressDelegate){
        [self.attachmentProgressDelegate onUpdateBytesDownloaded:connection.mData.length];
    }
    
}

-(void)connection:(ALConnection *)connection didSendBodyData:(NSInteger)bytesWritten
totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    //upload percentage
    NSLog(@"didSendBodyData..upload is in process...");
    if(self.attachmentProgressDelegate){
        [self.attachmentProgressDelegate onUpdateBytesUploaded:totalBytesWritten];
    }
}



@end
