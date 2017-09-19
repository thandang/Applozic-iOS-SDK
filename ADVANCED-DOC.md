### Notifications 

Enable/Disable Notification & Sound

Below method should be called to change notification.

```
//THIS IS OPTIONAL AND USE IF USER NEEDS TO UPDATE NOTIFICATIONS IN REAL TIME

short mode = 0  // SOUND + NOTIFICATION : THIS IS DEFAULT
short mode = 1  // NOTIFICATION WITHOUT SOUND
short mode = 2  // DISABLE NOTIFICATION : NO NOTIFICATION WILL COME FROM SERVER

[ALRegisterUserClientService updateNotificationMode:mode withCompletion:^(ALRegistrationResponse *response, NSError *error) { 
     [ALUserDefaultsHandler setNotificationMode:mode] ; 
      NSLog(@"UPDATE Notification Mode Response:%@ Error:%@",response,error); 
}];

```

You can clear the remote notifications from the notification banner once the app is launched. In your AppDelegate.m file under didFinishLaunchingWithOptions add:
```
application.applicationIconBadgeNumber = 1;
application.applicationIconBadgeNumber = 0;
[application cancelAllLocalNotifications];

```


### Unread Count



1. UNREAD COUNT FOR INDIVIDUAL CONTACT/USER

 ```
    ALContactService* contactService = [ALContactService new];
    ALContact *contact = [contactService loadContactByKey:@"userId" value:userID];
    NSNumber *unreadCount = [contact unreadCount];
 ```
2. UNREAD COUNT FOR INDIVIDUAL GROUP
  ``` 
     ALChannelService *channelService = [ALChannelService new];
     ALChannel *alChannel = [channelService getChannelByKey:channelKey];
     NSNumber *unreadCount = [alChannel unreadCount];
 ```
  
3. OVER ALL UNREAD COUNT (Contacts + Groups)

 ```
    ALUserService * alUserService = [[ALUserService alloc] init];
    NSNumber * totalUnreadCount = [alUserService getTotalUnreadCount];
 ```

NOTE: For real time update of count(like badge count on icon/view),you can observe notification for new incoming message and update count in view.

```
//Observe notification for new incoming message and refresh count in handler method. You can add this in viewWillAppear of your controller.

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMessageHandler)
                                                 name:NEW_MESSAGE_NOTIFICATION
                                               object:nil];
//Handler method in your controller.
-(void)newMessageHandler
{
   //refresh your count in this method
    [YourLabel setText:[NSString stringWithFormat:@"%@", contactUnreadCount]];   // UPDATE YOUR LABEL
}

//STOP observing new message notification. You can add this in -(void)viewWillDisappear
[[NSNotificationCenter defaultCenter] removeObserver:self name:NEW_MESSAGE_NOTIFICATION object:nil];
    

```

### Send Message

```
//IMPORT ALMessageService.h

//CREATE MESSAGE OBJECT

    ALMessage * alMessage = [[ALMessage alloc] init];
    
    alMessage.contactIds = USER-ID;     // REPLACE USER-ID BY Receiver's userId
    alMessage.to = USER-ID;             // REPLACE USER-ID BY Receiver's userId
    alMessage.message = TEXT;           // REPLACE TEXT BY Your message text
    //alMessage.groupId= groupId        // REPLACE groupId or ChannelKey. This should be set while sending message to group.
    alMessage.contentType = 0; 
    alMessage.type = @"5";
    alMessage.createdAtTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    alMessage.deviceKey = [ALUserDefaultsHandler getDeviceKeyString];
    alMessage.sendToDevice = NO;
    alMessage.shared = NO;
    alMessage.fileMeta = nil;
    alMessage.storeOnDevice = NO;
    alMessage.key = [[NSUUID UUID] UUIDString];
    alMessage.delivered = NO;
    alMessage.fileMetaKey = nil;

// Send Message 

    [ALMessageService sendMessages:alMessage withCompletion:^(NSString *message, NSError *error) {
        if(!error)
        {
            // WRITE YOUR LOGIC (IF - ANY)
        }
    }];
    
```


### Send Message with MetaData

You can send extra information along with message text as meta-data. These key value pair can be used to do some extra processing or keep information about messages.

```
    // GETTING DICTIONARY FOR METADATA
    NSMutableDictionary * metaDictionary = [self getNewMetaDataDictionary]; 
   
    ALMessage * alMessage = [[ALMessage alloc] init];
    
    alMessage.contactIds = USER-ID;     // REPLACE USER-ID BY Receiver's userId
    alMessage.to = USER-ID;             // REPLACE USER-ID BY Receiver's userId
    alMessage.message = TEXT;           // REPLACE TEXT BY Your message text
    alMessage.contentType = 0; 
    alMessage.type = @"5";
    alMessage.createdAtTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    alMessage.deviceKey = [ALUserDefaultsHandler getDeviceKeyString];
    alMessage.sendToDevice = NO;
    alMessage.shared = NO;
    alMessage.fileMeta = nil;
    alMessage.storeOnDevice = NO;
    alMessage.key = [[NSUUID UUID] UUIDString];
    alMessage.delivered = NO;
    alMessage.fileMetaKey = nil;
    alMessage.metadata = metaDictionary  // HERE DICTIONARY ADDED WITH ALMessage object
    
    [ALMessageService sendMessages:alMessage withCompletion:^(NSString *message, NSError *error) {
        if(!error)
        {
             // WRITE YOUR LOGIC (IF - ANY)
        }
    }];

// ADD METADATA DICTIONARY METHOD 

-(NSMutableDictionary *)getNewMetaDataDictionary 
{
    NSMutableDictionary *metaDict = [[NSMutableDictionary alloc] init];
    [metaDict setObject:@"VALUE1" forKey:@"KEY1"];
    [metaDict setObject:@"VALUE2" forKey:@"KEY2"];
    return metaDict;
}

```
### Send Message With Attachment

You can use below method to send message with attachments.  

```
MessageServiceWrapper * wrapperService  = [MessageServiceWrapper new];

//build message Objects
ALMessage * almessage = [wrapperService createMessageEntityOfContentType:ALMESSAGE_CONTENT_ATTACHMENT toSendTo:@"receiverContact" withText:@"Text"];

//get file path of attachment
UIImage *image = [UIImage imageNamed:@"IMGE_NAME"]; 
NSString * filePath = [ALImagePickerHandler saveImageToDocDirectory:image];

[wrapperService sendMessage:almessage withAttachmentAtLocation:filePath andWithStatusDelegate:self andContentType:ALMESSAGE_CONTENT_ATTACHMENT];
```

- You can also implement delegate to recevie status update of upload and download.

```
// bytes downloaded  
-(void)updateBytesDownloaded:(NSUInteger) bytesReceived;

//bytes uploaded 
-(void)updateBytesUploaded:(NSUInteger) bytesSent;

//download OR upload  failed 
-(void)uploadDownloadFailed:(ALMessage*)alMessage;

//upload completed 
-(void)uploadCompleted:(ALMessage *) alMessage;

//download completed
-(void)DownloadCompleted:(ALMessage *) alMessage;

```

### Download Message's attachment

```
ALMessageServiceWrapper * wrapperService  = [ALMessageServiceWrapper new];
wrapperService.messageServiceDelegate = self;
wrapperService downloadMessageAttachment:alMessage];
```
NOTE: Once successfully downloaded, attachment will be saved and almessage object will have file path  information(almessage.imageFilePath).

### Get Latest Messages From Each Conversation

STEP1:  Implement ALMessagesDelegate delegate in your controller.

```
    //Delegate method.
   -(void)getMessagesArray:(NSMutableArray*)messagesArray{
   
     //messageArray contains array of ALMessage object
   }

```
STEP 2: Add below code to get the latest messages in your controller.
```
   ALMessageDBService * dBService = [ALMessageDBService new];
  dBService.delegate = self; // Controller reference for ALMessagesDelegate delegate
  [dBService getMessages:self.nil];

```




### Get Latest Message For USER And CHANNEL

```

FOR USER :

ALMessageService *msgService = [[ALMessageService alloc] init];
ALMessage * msgService = [msgService getLatestMessageForUser:@"USER_ID"];


FOR CHANNEL :
// NOTE : IF PASSING 'YES' THEN IT WILL EXCLUDE GROUP OPERATIONS LIKE ADD/REMOVE etc. MESSSAGES

ALMessageService *msgService = [[ALMessageService alloc] init];
ALMessage * = [msgService getLatestMessageForChannel:[NSNumber numberWithInt:<GROUP_ID>] excludeChannelOperations:NO];

```

### Encryption

If encryption is required

```
Objective-C

[ALUserDefaultsHandler setEnableEncryption:YES]; 


SWIFT

ALUserDefaultsHandler.setEnableEncryption(true)

```


### Contacts

Applozic framework provides convenient APIs for building your own contact. Developers can build and store contacts in three different ways. 

 **Build your contact:** 

** a) Simple method to create your contact is to create contact.
**                 




** Objective - C **        
```
ALContact *contact1 = [[ALContact alloc] init];              
contact1.userId = @"adarshk"; // unique Id for user               
contact1.fullName = @"Adarsh Kumar"; // Fullname of the contact.               

//Display name for contact. This name would be displayed to the user in chat and contact list.                  
contact1.displayName = @"Adarsh";               
contact1.email = @"github@applozic.com"; //Email Id for the contact.              
//Contact image url. Contact image would be downloaded automatically from URL.                  
ontact1.contactImageUrl =@"https://www.applozic.com/resources/images/applozic_logo.gif";        
contact1.localImageResourceName = @"adarsh.jpg"; // If this field is mentioned,
Contact image will be taken from local storges.   
```


**b) Creating contact from dictionary:
**
You can directly create contact from dictionary, all you have to do is just pass a dictionary while initialising object.          




** Objective -C **  
```
  //Contact ------- Example with dictonary 
  NSMutableDictionary *demodictionary = [[NSMutableDictionary alloc] init]; 
  [demodictionary setValue:@"adarshk" forKey:@"userId"]; 
  [demodictionary setValue:@"Adarsh Kumar" forKey:@"fullName"]; 
  [demodictionary setValue:@"Adarsh" forKey:@"displayName"];  
  [demodictionary setValue:@"github@applozic.com" forKey:@"email"]; 
  [demodictionary setValue:@"https://www.applozic.com/resources/images/applozic_logo.gif" forKey:@"contactImageUrl"]; 
  [demodictionary setValue:nil forKey:@"localImageResourceName"];              
  ALContact *contact5 = [[ALContact alloc] initWithDict:demodictionary];                   
```




**b) Building contact from JSON:
**           



** Objective -C **       
```
//Contact -------- Example with json                   
NSString *jsonString =@"{\"userId\": \"applozic\",\"fullName\": \"Applozic\",
\"contactNumber\": \"9535008745\",\"displayName\":  \"Applozic Support\",
\"contactImageUrl\": \"https://www.applozic.com/resources/images/applozic_logo.gif\",\"email\":       
\"devashish@applozic.com\",\"localImageResourceName\":\"sample.jpg\"}";                   
ALContact *contact4 = [[ALContact alloc] initWithJSONString:jsonString];                        
 ```
 
 
 
 **Add Your Contact:** 


**Add single contact API
**


** Objective - C **    

 ```
 -(BOOL)addContact:(ALContact *)contact;
 ```
 
 Example:
 ```
 ALContact *contact  = [[ALContact alloc] init];              
 contact.userId      = @"adarshk";      // Unique Id for user               
 contact.fullName    = @"Adarsh Kumar"; // Fullname of the contact.  
 contact.displayName = @"Adarsh";       // Name on display
 
 ALContactService * alContactService = [[ALContactService alloc] init];                   
 [alContactService addContact:contact]; 
```


Below are additional APIs for contact load, update, delete and requires a ALContact object or array of ALContact objects. 

** Objective - C **            
```

#  Fetch/Load contact API
/*  Use "userId" for <key> and contact's user id string as <value> for below API */
  - (ALContact *)loadContactByKey:(NSString *) key value:(NSString*) value
  
#   Update APIS                 
  -(BOOL)updateContact:(ALContact *)contact                    
  -(BOOL)updateListOfContacts:(NSArray *)contacts
 
#  Add contact(s) APIs              
  -(BOOL)addListOfContacts:(NSArray *)contacts          
  -(BOOL)addContact:(ALContact *)contact
 
#    Deleting APIS               
  //For purging single contact 
  -(BOOL)purgeContact:(ALContact *)contact             
  
  //For purging multiple contacts                
  -(BOOL)purgeListOfContacts:(NSArray *)contacts
  
  //For purging all contacts at once              
  -(BOOL)purgeAllContacts 
  
 ```
 
Show all registered contacts in my application 

** Objective - C **

In AlChatManager.m in method -(void)ALDefaultChatViewSettings method update

```
   [ALApplozicSettings setFilterContactsStatus:YES]; 
   
```

** Swift **

In AlChatManager.m in method func ALDefaultChatViewSettings () method update

```
   ALApplozicSettings.setFilterContactsStatus(true) 
   
```

### Contextual Conversation
 
 Applozic SDK provide APIs which let you set and customise the chat's context. Developers can create a Conversation and launch a chat with context set. 

The picture below shown depicts the context header set below the navigation bar.Suppose a buyer want to have context chat with seller 'Adarsh' on product macbook pro.

 ![picture alt](https://raw.githubusercontent.com/AppLozic/Applozic-iOS-SDK/master/images/contextBased.png "Context-based header view")

__ALConversationProxy__ is a class which let you build your conversation context

ALConversationProxy have three type of properties as following:          


   1. topicId : A unique ID for your Topic/context you want to chat.                        
   2. userId : User ID of receiver. 
   3. alTopicDetail: Contains the following:
   
      Topic title                                               
      Topic subtitle             
      Image link                
      key1 and value1: For ex. key1 be "Product ID" and value1 be "569-01"         
      key2 and value2: For ex. key1 be "Price" and value2 be "Rs.1,50,00"             



Key1 and Key2 is a placeholder to store with respective value1 and value2 values

##### Objective - C            

```
ALConversationProxy * alConversationProxy = [[ALConversationProxy alloc] init];
alConversationProxy.topicId = @”buyMacPro";
alConversationProxy.userId = @"adarshk"
   
ALTopicDetail * alTopicDetail	= [[ALTopicDetail alloc] init];
alTopicDetail.title 		 	= @”Mac Book Pro";
alTopicDetail.subtitle 	  	= @"13’ Retina";
alTopicDetail.link = @"http://d.ibtimes.co.uk/en/full/319949/macbook-pro-13in-retina.jpg";
alTopicDetail.key1      	 	= @"Product ID";
alTopicDetail.value1    		= @"mac-pro-r-13";
alTopicDetail.key2      		= @"Price”;
alTopicDetail.value2    		= @"Rs.1,04,999.0";

NSData *jsonData = [NSJSONSerialization dataWithJSONObject:alTopicDetail.dictionary  
options:NSJSONWritingPrettyPrinted error:nil];
NSString *topicDetails = [[NSString alloc] initWithData:jsonData    encoding:NSUTF8StringEncoding];
 
alConversationProxy.topicDetailJson = topicDetails;
```

##### API to create conversation using ALConversationProxy object 

```
-(void)createConversation:(ALConversationProxy *)alConversationProxy withCompletion:(void(^)(NSError *error,ALConversationProxy * proxy ))completion;
```


### Channel/Group Messaging

This section explain about convenient SDK APIs  related to group.  

__Class to import :__ Applozic/ALChannelService.h 

##### Create Channel/Group

You can create a Channel/Group by simply calling createChannel method. The callback argument ALChannel will have Channel information created by applozic server.In case you are not passing clientChannelKey, you need to store channelKey from ALChannel object for any further operations( like : add member, remove  member, delete group/channel etc) on Channel/Group.   
```
Objective-C

-(void)createChannel:(NSString *)channelName orClientChannelKey:(NSString *)clientChannelKey 
andMembersList:(NSMutableArray *)memberArray andImageLink:(NSString *)imageLink channelType:(short)type 
andMetaData:(NSMutableDictionary *)metaData withCompletion:(void(^)(ALChannel *alChannel))completion
         
SWIFT

open func createChannel(_ channelName: String!, orClientChannelKey clientChannelKey: String!, 
andMembersList memberArray: NSMutableArray!, andImageLink imageLink: String!, 
withCompletion completion: ((ALChannel?) -> Swift.Void)!)

```

| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| channelName  | Yes  |   | channel name  |
| clientChannelKey  | No  | nil  | Channel key maintain by client. This can be any unique identifier passed by client, to identify his group/channel |
| memberArray  | Yes  |   | Array of group member's userId  |
| imageLink  | Yes  |   | group profile image link  |
| type  | Yes  |  PUBLIC=2 | type of the group. PRIVATE = 1,PUBLIC = 2, OPEN = 6 |
|metaData | optional | nil| Setting group meta data for messages like created group, left group, removed from group, group deleted, group icon changed and group name changed.|
| (void(^)(ALChannel *alChannel))completion  |   |   | completion block, once group is created successfully. This will return ALChannel object, which stores information about newly created channel. |

 
NOTE: Group metadata is optional and should be passed for custom group notification message only. Example method is below, how you can get custom message:

```
/**
 * :adminName - Admin display name of group
 * :userName -  user's display name
 * :groupName -  Group's Name
 *
 **/
 
Objective-C

-(NSMutableDictionary *)getChannelMetaData
{
    NSMutableDictionary *grpMetaData = [NSMutableDictionary new];

    [grpMetaData setObject:@":adminName created group" forKey:@"CREATE_GROUP_MESSAGE"];
    [grpMetaData setObject:@":userName removed" forKey:@"REMOVE_MEMBER_MESSAGE"];
    [grpMetaData setObject:@":userName added" forKey:@"ADD_MEMBER_MESSAGE"];
    [grpMetaData setObject:@":userName joined" forKey:@"JOIN_MEMBER_MESSAGE"];
    [grpMetaData setObject:@"Group renamed to :groupName" forKey:@"GROUP_NAME_CHANGE_MESSAGE"];
    [grpMetaData setObject:@":groupName icon changed" forKey:@"GROUP_ICON_CHANGE_MESSAGE"];
    [grpMetaData setObject:@":userName left" forKey:@"GROUP_LEFT_MESSAGE"];
    [grpMetaData setObject:@":groupName deleted" forKey:@"DELETED_GROUP_MESSAGE"];
    
    return grpMetaData;
}

SWIFT

func getChannelMetaData() -> NSMutableDictionary
{
    let grpMetaData: NSMutableDictionary = NSMutableDictionary()
    
    grpMetaData["CREATE_GROUP_MESSAGE"] = ":adminName created group"
    grpMetaData["REMOVE_MEMBER_MESSAGE"] = ":userName removed"
    grpMetaData["ADD_MEMBER_MESSAGE"] = ":userName added"
    grpMetaData["JOIN_MEMBER_MESSAGE"] = ":userName joined"
    grpMetaData["GROUP_NAME_CHANGE_MESSAGE"] = "Group renamed to :groupName"
    grpMetaData["GROUP_ICON_CHANGE_MESSAGE"] = ":groupName icon changed"
    grpMetaData["GROUP_LEFT_MESSAGE"] = ":userName left"
    grpMetaData["DELETED_GROUP_MESSAGE"] = ":groupName deleted"
    
    return grpMetaData
}

```

##### Add User to Channel/Group
```
Objective-C

-(void)addMemberToChannel:(NSString *)userId andChannelKey:(NSNumber *)channelKey 
orClientChannelKey:(NSString *)clientChannelKey 
withCompletion:(void(^)(NSError *error,ALAPIResponse *response))completion


SWIFT

open func addMember(toChannel userId: String!, andChannelKey channelKey: NSNumber!, orClientChannelKey 
clientChannelKey: String!, withCompletion completion: ((Error?, ALAPIResponse?) -> Swift.Void)!)

``` 	 
 
| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| userId  | Yes  |   | member's userId to be added to group  |
| channelKey  | No |   | applozic channelKey. If clientChannelKey is passed, this should be passed as nil. |
| clientChannelKey  | No  |   | client channel identifier. This is mandatory if applozic channelKey is not passed. |
| (void(^)(NSError *error,ALAPIResponse *response))completion  | Yes  |   | completion block. If member added successfully, response object's status will have value as sucess. |


__NOTE:__ Only admin can add member to the group/channel. For more detail see check Admin section.


##### Remove user from Channel/Group
 ```
Objective-C
 
-(void)removeMemberFromChannel:(NSString *)userId andChannelKey:(NSNumber *)channelKey 
orClientChannelKey:(NSString *)clientChannelKey withCompletion:(void(^)(NSError *error, ALAPIResponse *response))completion


SWIFT

open func removeMember(fromChannel userId: String!, andChannelKey channelKey: NSNumber!, 
orClientChannelKey clientChannelKey: String!, withCompletion completion: ((Error?, ALAPIResponse?) -> Swift.Void)!)

```
 
| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| userId  | Yes  |   | member's userId to be removed from group  |
| channelKey  | No |   | applozic channelKey. If clientChannelKey is passed, this should be passed as nil. |
| clientChannelKey  | No  |   | client channel identifier. This is mandatory if applozic channelKey is not passed. |
| (void(^)(NSError *error, ALAPIResponse *response))completion  | Yes  |   | completion block. |


##### Delete Channel/Group
```
Objective-C

-(void)deleteChannel:(NSNumber *)channelKey orClientChannelKey:(NSString *)clientChannelKey 
withCompletion:(void(^)(NSError *error, ALAPIResponse *response))completion
      
SWIFT

open func deleteChannel(_ channelKey: NSNumber!, orClientChannelKey 
clientChannelKey: String!, withCompletion completion: ((Error?, ALAPIResponse?) -> Swift.Void)!)

```
 
| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| channelKey  | No |   | applozic channelKey. If clientChannelKey is passed, this should be passed as nil. |
| clientChannelKey  | No  |   | client channel identifier. This is mandatory if applozic channelKey is not passed. |
| (void(^)(NSError *error, ALAPIResponse *response))completion  | Yes  |   | completion block. In case of sucess, error object will be nil |

__NOTE:__ Only admin can add member to the group/channel. For more detail see check Admin section.


##### Leave Channel/Group
```
Objective-C

-(void)leaveChannel:(NSNumber *)channelKey andUserId:(NSString *)userId 
orClientChannelKey:(NSString *)clientChannelKey withCompletion:(void(^)(NSError *error))completion
     
SWIFT

open func leaveChannel(_ channelKey: NSNumber!, andUserId userId: String!, orClientChannelKey 
clientChannelKey: String!, withCompletion completion: ((Error?) -> Swift.Void)!)

```

| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| channelKey  | No |   | applozic channelKey. If clientChannelKey is passed, this should be passed as nil. |
| clientChannelKey  | No  |   | client channel identifier. This is mandatory if applozic channelKey is not passed. |
| (void(^)(NSError *error))completion  | Yes  |   | completion block. In case of sucess, error object will be nil |


##### Update Channel/Group
```
Objective-C


-(void)updateChannel:(NSNumber *)channelKey andNewName:(NSString *)newName andImageURL:(NSString *)imageURL orClientChannelKey:(NSString *)clientChannelKey
  isUpdatingMetaData:(BOOL)flag metadata:(NSMutableDictionary *)metaData orChildKeys:(NSMutableArray *)childKeysList orChannelUsers:(NSMutableArray *)channelUsers withCompletion:(void(^)(NSError *error))completion
  
SWIFT

open func updateChannel(_ channelKey: NSNumber!, andNewName newName: String!, 
andImageURL imageURL: String!, orClientChannelKey clientChannelKey: String!, isUpdatingMetaData flag: Bool!, metadata metaData: NSMutableDictionary!, orChildKeys childKeysList: NSMutableArray!, orChannelUsers channelUsers: NSMutableArray!,
withCompletion completion: ((Error?) -> Swift.Void)!)

```

| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| channelKey  | No |   | applozic channelKey. If clientChannelKey is passed, this should be passed as nil. |
| newName  | Yes |   | new name of channel.|
| imageURL  | No |   | new Image of channel. If require to change image of channel/group|
| clientChannelKey  | No  |   | client channel identifier. This is mandatory if applozic channelKey is not passed. |
| metaData |No |  | pass if you want to update channel meta data |
|isUpdatingMetaData | No | | pass true in case if your updating meta data |
|childKeysList|No| |To update childKeys |
|channelUsers|No| |To update role of user in group/channel |
| (void(^)(NSError *error))completion  | Yes  |   | completion block. In case of sucess, error object will be nil |

__NOTE:__ Only admin can change the roles of user, For building channelUsers for role change update 

     ALChannelService *channelService = [ALChannelService new];
     ALChannelUser * alChannelUsers = [ALChannelUser new];
     alChannelUsers.role = [NSNumber numberWithInt:1];//  USER = 0,ADMIN = 1,MODERATOR = 2,MEMBER = 3
     alChannelUsers.userId = userId;//user to update the role
     NSMutableArray * channelUsers = [NSMutableArray new];
     [channelUsers addObject:alChannelUsers.dictionary];

##### Group Admin

This method is to check whether the current login user is channel/group admin or not.
As group admin have rights to do delete channel, remove  channel and add new member to channel. it is suggested to call this method to check admin rights before performing operations.
```
Objective-C

-(BOOL) checkAdmin:(NSNumber *) channelKey


SWIFT

open func checkAdmin(_ channelKey: NSNumber!) -> Bool

```
| Parameter  | Required | Default | Description |
| ------------- | ------------- | ------------- | ------------- |       
| channelKey  | No |   | applozic channelKey.|

If admin successfully then it will return YES else NO.                   

### Adding button on navigationbar and getting callback outside SDK.

- To Add custom buttons on navigationbar and executing callbacks outside SDK, you need to [checkout and add our open source client code](https://www.applozic.com/blog/add-applozic-chat-framework-ios/) and make below changes.

STEP 1: Create your custom navigation class extending ALNavigationController and override
-(void)customNavigationItemClicked:(id)sender withTag:(NSString*)buttonName;

STEP2: Set this setting in ALDefaultChatViewSettings
```
[ALApplozicSettings setNavigationControllerClassName:@"YOUR CUSTOM CLASS NAME (STEP1)"];
```
STEP3: Add below in button selector -(void)buttonSelector.

```
-(void)buttonSelector
{
    ALNavigationController * controller = (ALNavigationController*)self.navigationController;
    [ controller customNavigationItemClicked:nil withTag:@"button_tag"];
}
```
### Contacts group 

Contacts group is for showing particular users/contacts in contact screen 


 ##### Settings for contacts group

**Objective - C**

In AlChatManager.m in method -(void)ALDefaultChatViewSettings method update

```
   [ALApplozicSettings setFilterContactsStatus:NO]; //make this to NO
   [ALApplozicSettings enableOrDisableContactsGroup:TRUE]; //paste this in inside of -(void)ALDefaultChatViewSettings method
   
```

#####  Add member into contacts group 


```

   NSMutableArray * memberArray = [NSMutableArray new];
    [memberArray addObject:@"user1"];//pass the UserId of user whom you want to add into the contacts group
    [memberArray addObject:@"user2"];
    NSString * contactsGroupId = @"organization1";//contactsGroupId can be an unique id, it can be be an organization id, event id or any
    
    [ALChannelService addMemberToContactGroupOfType:contactsGroupId withMembers:memberArray withGroupType:CONTACT_GROUP withCompletion:^(ALAPIResponse *response, NSError *error) {
        
        if(error ){
            NSLog(@"Error while adding user %@",error);
            return ;
        }
        
        if (response && [@"success" isEqualToString:response.status]) {
          NSLog(@"User added to contacts group");
        }else{
            NSLog(@"User not able to add to contacts group");
        }
    }];
    
 ```
 
 ##### Settings to add while chat Launching 
 
 ```
   [ALApplozicSettings setContactsGroupId:contactsGroupId]; //contactsGroupId can be any unique id, it can be be an organization id, event id or any
 ```
 
 
#####  Remove Member from contacts group

Note : only admin can remove user from contacts group 

    NSString * contactsGroupId = @"organization1";//contactsGroupId can be any unique id, it can be be an organization id, event id or any
    NSString *removeMemeberUserId = @"user2";
    
    [ALChannelService removeMemberFromContactGroupOfType:(NSString *)contactsGroupId withGroupType:CONTACT_GROUP withUserId:(NSString *) removeMemeberUserId withCompletion:^(ALAPIResponse *response, NSError *error){
        if(error ){
            NSLog(@"Error while  remove Member user %@",error);
            return ;
        }
        
        if (response && [@"success" isEqualToString:response.status]) {
            NSLog(@"User removed from contacts group");
        }else{
            NSLog(@"Not able to remove user");
        }
    }];


### Audio/Video Call Setup

**Installation** 

**1) Framework:**

**Using cocoapods**

Add below pod dependency:
```
  pod 'TwilioVideo', '~> 1.1.0'
  pod 'Applozic', '~> 4.2.0'
```
NOTE: Continue follwing integration steps and skip using framework step.
 
**Using Framework**

**Installing lfs**

i)  To fetch framowrk files(larger-file), you need to install lfs. You can install it by running below command:

```
brew install git-lfs 
```
ii)  You can verify installation was successful, by running below command on terminal.

```
git lfs install
```

iii) Once you complete checkout of sample-repo, go to project's root folder and run below command:

```
git lfs pull
```


**2) Navigate to your Xcode project's General settings page and add Applozic.framework,Twillio.framework from [sample project root folder](https://github.com/AppLozic/applozic-ios-video-call-sample/tree/master/ALAudioVideo) as Embeded binaries.**

**3) Add below libraries in Linked Frameworks and Libraries.**

- AudioToolbox.framework
- VideoToolbox.framework
- AVFoundation.framework
- CoreTelephony.framework
- GLKit.framework
- CoreMedia.framework
- SystemConfiguration.framework
- libc++.tbd


**Integration Steps:**

**1) Add Audio/Video code to your project.**
 - Copy paste [AudioVideo](https://github.com/AppLozic/applozic-ios-video-call-sample/tree/master/ALAudioVideo/ALAudioVideo/AudioVideo) folder from sample project and paste it into your root directory of your project. Go to Add Files to project, select all files present in Folder and add it to your project.

**2) Follow basic integration steps:**
- After above steps, follow our documentaion page from steps 2) onward for integration:

https://www.applozic.com/docs/ios-chat-sdk.html#step-2-login-register-user


**3) Notification setup:** 

  Apart from basic notification setup done in [step 4](https://www.applozic.com/docs/ios-chat-sdk.html#step-4-push-notification-setup). Add below Pushkit delegates.

**Objective-C**
  
 ``` 
  //=====================================
#pragma mark : PUSHKIT DELEGATES
//=======================================
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    
    PKPushRegistry * pushKitVOIP = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushKitVOIP.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    pushKitVOIP.delegate = self;
}

-(void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    
    NSLog(@"PUSHKIT : VOIP_TOKEN_DATA : %@",credentials.token);
    const unsigned *tokenBytes = [credentials.token bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"PUSHKIT : VOIP_TOKEN : %@",hexToken);
    if ([[ALUserDefaultsHandler getApnDeviceToken] isEqualToString:hexToken])
    {
        return;
    }
    
    NSLog(@"PUSHKIT : VOIP_TOKEN_UPDATE_CALL");
    ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];
    [registerUserClientService updateApnDeviceTokenWithCompletion:hexToken withCompletion:^(ALRegistrationResponse *rResponse, NSError *error) {
        
        if (error)
        {
            NSLog(@"PUSHKIT : VOIP TOKEN : REGISTRATION ERROR :: %@",error.description);
            return;
        }
        
        NSLog(@"PUSHKIT : VOIP_TOKEN_UPDATE : %@", rResponse);
    }];
}

-(void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type {
    
    NSLog(@"PUSHKIT : INVALID_PUSHKIT_TOKEN");
}

-(void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type {
    
    NSLog(@"PUSHKIT : INCOMING VOIP NOTIFICATION : %@",payload.dictionaryPayload.description);
    
    UIApplication * application = [UIApplication sharedApplication];
    ALPushNotificationService *pushNotificationService = [[ALPushNotificationService alloc] init];
    [pushNotificationService notificationArrivedToApplication:application withDictionary:[payload dictionaryPayload]];
    
    NSDictionary *payloadDict = [[payload dictionaryPayload] objectForKey:@"aps"];
    NSString * alert = [payloadDict objectForKey:@"alert"];
    NSString * sound = [payloadDict objectForKey:@"sound"];
    
    if (alert)
    {
        if(SYSTEM_VERSION_LESS_THAN(@"10.0"))
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertBody = alert;
            if (sound)
            {
                localNotification.soundName = UILocalNotificationDefaultSoundName;
            }
            localNotification.userInfo = [payload dictionaryPayload];
            [application presentLocalNotificationNow:localNotification];
        }
        else
        {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            NSArray * msgContent = [alert componentsSeparatedByString:@":"];
            content.title = [NSString localizedUserNotificationStringForKey:(msgContent[0] ? msgContent[0] : alert) arguments:nil];
            content.body = [NSString localizedUserNotificationStringForKey:(msgContent[1] ? msgContent[1] : alert) arguments:nil];
            content.userInfo = [payload dictionaryPayload];
            if (sound)
            {
                content.sound = [UNNotificationSound defaultSound];
            }
            
            UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:@"VOIP_APNS" content:content trigger:nil];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"PUSHKIT : Add NotificationRequest Succeeded!");
                }
            }];
        }
    }
}
 ```

**Swift**

```
extension AppDelegate: PKPushRegistryDelegate {
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        let pushKitVOIP = PKPushRegistry(queue: DispatchQueue.main)
        pushKitVOIP.desiredPushTypes = Set<PKPushType>([PKPushType.voIP])
        pushKitVOIP.delegate = self
    }

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        NSLog("PUSHKIT : VOIP_TOKEN_DATA : %@",credentials.token.description)

        let hexToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        NSLog("PUSHKIT : VOIP_TOKEN : %@",hexToken)

        if let apnToken = ALUserDefaultsHandler.getApnDeviceToken(), apnToken == hexToken {
            return
        }
        NSLog("PUSHKIT : VOIP_TOKEN_UPDATE_CALL")

        let registerUserClientService = ALRegisterUserClientService()
        registerUserClientService.updateApnDeviceToken(withCompletion: hexToken, withCompletion: {
            response, error in
            if error != nil {
                NSLog("PUSHKIT : VOIP TOKEN : REGISTRATION ERROR :: %@", error.debugDescription)
                return
            }

            NSLog("PUSHKIT : VOIP_TOKEN_UPDATE : %@", response?.description ?? "")
        })
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenForType type: PKPushType) {
        NSLog("PUSHKIT : INVALID_PUSHKIT_TOKEN")
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        NSLog("PUSHKIT : INCOMING VOIP NOTIFICATION : %@",payload.dictionaryPayload.description)

        let application = UIApplication.shared
        let pushNotificationService = ALPushNotificationService()
        pushNotificationService.notificationArrived(to: application, with: payload.dictionaryPayload)

        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any]
        let notifAlert = payloadDict?["alert"]
        let notifSound = payloadDict?["sound"]

        guard let alert = notifAlert as? String  else { return }

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            let messageContent = alert.components(separatedBy: ":")

            content.title = messageContent.count > 0 ? messageContent[0]: alert
            if notifSound != nil {
                content.sound = UNNotificationSound.default()
            }

            content.body = messageContent.count > 1 ? messageContent[1]: alert
            content.userInfo = payload.dictionaryPayload
	    center.delegate = self
            let request = UNNotificationRequest(identifier: "VOIP_APNS", content: content, trigger: nil)
            center.add(request, withCompletionHandler: {
                error in
                if error == nil {
                    NSLog("PUSHKIT : Add NotificationRequest Succeeded!")
                }
            })
        } else {
            let localNotification = UILocalNotification()
            localNotification.alertBody = alert
            if notifSound != nil {
                localNotification.soundName = UILocalNotificationDefaultSoundName
            }

            localNotification.userInfo = payload.dictionaryPayload
            application.presentLocalNotificationNow(localNotification)
        }
    }
}
```

**NOTE: You need to upload VoIP Services Certificate in both development and distribution section on Applozic Dashboard**

**4) Add below setting in ALChatManger.m's in ALDefaultChatViewSettings.**

    [ALApplozicSettings setAudioVideoClassName:@"ALAudioVideoCallVC"];
    [ALApplozicSettings setAudioVideoEnabled:YES];
