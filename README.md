# Applozic-iOS-SDK
iOS Chat SDK


### Overview         

Open source iOS Chat and Messaging SDK that lets you add real time messaging in your mobile (android, iOS) applications and website.

Signup at [https://www.applozic.com/signup.html](https://www.applozic.com/signup.html?utm_source=github&utm_medium=readme&utm_campaign=ios) to get the App ID.


Works for both Objective-C and Swift.

It is a light weight Objective-C Chat and Messenger SDK.

Applozic One to One and Group Chat SDK

**Documentation:** [https://www.applozic.com/docs/ios-chat-sdk.html](https://www.applozic.com/docs/ios-chat-sdk.html?utm_source=github&utm_medium=readme&utm_campaign=ios)

**Sample Projects:** [https://github.com/AppLozic/Applozic-iOS-Chat-Samples](https://github.com/AppLozic/Applozic-iOS-Chat-Samples)

#### Features:


 One to one and Group Chat
 
 Image capture
 
 Photo sharing

 Location sharing
 
 Push notifications
 
 In-App notifications
 
 Online presence
 
 Last seen at 
 
 Unread message count
 
 Typing indicator
 
 Message sent, delivery report
 
 Offline messaging
 
 Multi Device sync
 
 Application to user messaging
 
 Customized chat bubble
 
 UI Customization Toolkit
 
 Cross Platform Support (iOS, Android & Web)


### Getting Started                 


**Create your Application**

a) [**Sign up**](https://www.applozic.com/signup.html?utm_source=github&utm_medium=readme&utm_campaign=ios) with applozic to get your App ID.

b) Once you signed up create your Application with required details on admin dashboard. Upload your push-notification certificate to our portal to enable real time notification.      



c) Once you create your application you can see your App ID listed on admin dashboard. Please use same App ID explained in further steps.          





**Installing the iOS SDK** 

**ADD APPLOZIC FRAMEWORK**
Clone or download the SDK (https://github.com/AppLozic/Applozic-iOS-SDK)
Get the latest framework "Applozic.framework" from Applozic github repo [**sample project**](https://github.com/AppLozic/Applozic-iOS-Chat-Samples)

**Add framework to your project:**

i) Paste Applozic framework to root folder of your project. 
ii) Go to Build Phase. Expand  Embedded frameworks and add applozic framework.         




![dashboard-blank-content](https://raw.githubusercontent.com/AppLozic/Applozic-Chat-SDK-Documentation/master/Resized-adding-applozic-framework.png)        


**Quickly Launch your chat**


You can test your chat quickly by adding below .h and .m file to your project.

[**ALChatManager.h**](https://raw.githubusercontent.com/AppLozic/Applozic-iOS-SDK/master/sample-with-framework/applozicdemo/ALChatManager.h)        

[**ALChatManager.m**](https://raw.githubusercontent.com/AppLozic/Applozic-iOS-SDK/master/sample-with-framework/applozicdemo/ALChatManager.m)  

Change applicationID in ALChatManager and you are ready to launch your chat from your controller :)

Launch your chat

```
//Replace with your App ID in ALChatManager.h

#define APPLICATION_ID @"applozic-sample-app" 


//Launch your Chat from your controller.
 ALChatManager * chatManager = [[ALChatManager alloc]init];
    [chatManager launchChat:<yourcontrollerReference> ];

```

Detail about user creation and registraion:


**PUSH NOTIFICATION REGISTRATION AND HANDLING**

**a) Send device token to applozic server:**

In your AppDelegate’s **didRegisterForRemoteNotificationsWithDeviceToken **method  send device registration to applozic server after you get deviceToken from APNS. Sample code is as below:             

**Swift**
```
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

    let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")

    let deviceTokenString: String = (deviceToken.description as NSString)
    .stringByTrimmingCharactersInSet(characterSet )
    .stringByReplacingOccurrencesOfString(" ", withString: "") as String

    print(deviceTokenString)

    if (ALUserDefaultsHandler.getApnDeviceToken() != deviceTokenString){

        let alRegisterUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
        alRegisterUserClientService.updateApnDeviceTokenWithCompletion(deviceTokenString, withCompletion: { (response, error) in
            print (response)
        })
    }
}
```


**Objective-C**      
```
 - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)
   deviceToken {                
  
    const unsigned *tokenBytes = [deviceToken bytes];            
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",                 
    ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),             
    ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),             
    ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];              
    
    NSString *apnDeviceToken = hexToken;            
    NSLog(@"apnDeviceToken: %@", hexToken);                  
 
   //TO AVOID Multiple call to server check if previous apns token is same as recent one, 
   if different call app lozic server.           

    if (![[ALUserDefaultsHandler getApnDeviceToken] isEqualToString:apnDeviceToken]) {                         
       ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];          
       [registerUserClientService updateApnDeviceTokenWithCompletion
       :apnDeviceToken withCompletion:^(ALRegistrationResponse
       *rResponse, NSError *error) {   
       
       if (error) {          
             NSLog(@"%@",error);             
            return;           
          }              
    NSLog(@"Registration response from server:%@", rResponse);                         
    }]; } }                                 

```


**b) Receiving push notification:**

Once your app receive notification, pass it to applozic handler for applozic notification processing.             

**Swift**
```
func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

    let alPushNotificationService: ALPushNotificationService = ALPushNotificationService()
    let applozicProcessed = alPushNotificationService.processPushNotification(userInfo, updateUI: application.applicationState == UIApplicationState.Active) as Bool

    //IF not a appplozic notification, process it

    if (applozicProcessed) {
        //Note: notification for app
    }
}
```

**Objective-C**      
  ```
  - (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)dictionary {
  
   NSLog(@"Received notification: %@", dictionary);           
   ALPushNotificationService *pushNotificationService = [[ALPushNotificationService alloc] init];        
   BOOL applozicProcessed = [pushNotificationService processPushNotification:dictionary updateUI:
   [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive];             
  
    //IF not a appplozic notification, process it            
    if (!applozicProcessed) {                
         //Note: notification for app          
    } }                                                           
```


**c) Handling app launch on notification click :**          

**Swift**
```
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

// Override point for customization after application launch.
let alApplocalNotificationHnadler : ALAppLocalNotifications =  ALAppLocalNotifications.appLocalNotificationHandler();
alApplocalNotificationHnadler.dataConnectionNotificationHandler();

    if (launchOptions != nil) {
    
    let dictionary = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary

        if (dictionary != nil) {
            print("launched from push notification")
            let alPushNotificationService: ALPushNotificationService = ALPushNotificationService()

            let appState: NSNumber = NSNumber(int: 0)
            let applozicProcessed = alPushNotificationService.processPushNotification(launchOptions,updateUI:appState)
            if (applozicProcessed) {
                return true;
            }
        }
    }

return true
}

```

**Objective-C**    
```
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
  
  // Override point for customization after application launch.                              
  NSLog(@"launchOptions: %@", launchOptions);                  
  if (launchOptions != nil) {
  
  NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];         
  if (dictionary != nil) {
      NSLog(@"Launched from push notification: %@", dictionary);        
      ALPushNotificationService *pushNotificationService = [[ALPushNotificationService alloc] init];            
      BOOL applozicProcessed = [pushNotificationService processPushNotification:dictionary updateUI:NO];               
  if (!applozicProcessed) {            
       //Note: notification for app              
     } } }                                   
      return YES;                 
  }                             
```


### Documentation:
For advanced options and customization, visit [Applozic iOS Chat & Messaging SDK Documentation](https://www.applozic.com/docs/ios-chat-sdk.html?utm_source=github&utm_medium=readme&utm_campaign=ios)



### Sample source code in Objective-C to build messenger and chat app

https://github.com/AppLozic/Applozic-iOS-SDK/tree/master/sample-with-framework

### Sample source code in Swift to build messenger and chat app
https://www.applozic.com/blog/add-applozic-chat-framework-ios/

### How to add chat sdk source code in your xcode project
https://github.com/AppLozic/Applozic-iOS-SDK/tree/master/sampleapp-swift


### Help

We provide support over at [StackOverflow] (http://stackoverflow.com/questions/tagged/applozic) when you tag using applozic, ask us anything.

Applozic is the best ios chat sdk for instant messaging, still not convinced? Write to us at github@applozic.com and we will be happy to schedule a demo for you.

### Free iOS Chat SDK - Supports both Objective-C and Swift
Special plans for startup and open source contributors, write to us at github@applozic.com 

### Github projects

Android Chat SDK https://github.com/AppLozic/Applozic-Android-SDK

Web Chat Plugin https://github.com/AppLozic/Applozic-Web-Plugin

iOS Chat SDK https://github.com/AppLozic/Applozic-iOS-SDK
