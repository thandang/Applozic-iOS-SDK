

Applozic SDK provides various UI settings to customise chat view easily. If you are using __ALChatManager.h__ explained in the  earlier section, you can put all your settings in below method. 

```
-(void)ALDefaultChatViewSettings;
```

If you have your own implementation, you should set UI Customization setting on successfull registration of user.

Below section explains UI settings provided by Applozic SDK.

#### Chat Bubble

##### Received Message bubble color

__Objective-C__
```
[ALApplozicSettings setColorForReceiveMessages: [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1]];
```

__Swift__
```
ALApplozicSettings.setColorForReceiveMessages(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1))
```

##### Send Message bubble color

__Objective-C__
```
[ALApplozicSettings setColorForSendMessages: [UIColor colorWithRed:66.0/255 green:173.0/255 blue:247.0/255 alpha:1]];
```

__Swift__
```
ALApplozicSettings.setColorForSendMessages(UIColor(red: 66.0/255, green: 173.0/255, blue: 247.0/255, alpha:1))
```

#### Chat Background

__Objective-C__
```
[ALApplozicSettings setChatWallpaperImageName:@"<WALLPAPER NAME>"];
```

__Swift__
```
ALApplozicSettings.setChatWallpaperImageName("<WALLPAPER NAME>")
```

### Chat Screen

Hide/Show profile Image

__Objective-C__
```
[ALApplozicSettings setUserProfileHidden: NO];
```

__Swift__
```
ALApplozicSettings.setUserProfileHidden(false)
```

Hide/Show Refresh Button

__Objective-C__
```
[ALApplozicSettings hideRefreshButton: NO];
```

__Swift__
```
ALApplozicSettings.hideRefreshButton(flag)
```

Chat Title

__Objective-C__
```
[ALApplozicSettings setTitleForConversationScreen: @"Recent Chats"];
```

__Swift__
```
ALApplozicSettings.setTitleForConversationScreen("Recent Chats")
```


#### Group Messaging

__Objective-C__
```
[ALApplozicSettings setGroupOption: YES];
```

__Swift__
```
ALApplozicSettings.setGroupOption(true)
```
This method is used when group feature is required . It will disable group functionality when set to NO.



##### Show/Hide Group Exit Button

__Objective-C__
```
[ALApplozicSettings setGroupExitOption:YES];
```

__Swift__
```
ALApplozicSettings.setGroupExitOption(true)
```


##### Show/Hide Group Member-Add Button (Admin only)

__Objective-C__
```
[ALApplozicSettings setGroupMemberAddOption:YES];
```

__Swift__
```
ALApplozicSettings.setGroupMemberAddOption(true)
```


##### Show/Hide Group Member-Remove Button (Admin only)

__Objective-C__
```
[ALApplozicSettings setGroupMemberRemoveOption:YES];
```

__Swift__
```
ALApplozicSettings.setGroupMemberRemoveOption(true)
```

##### Disable GroupInfo (Tap on group Title)

__Objective-C__
```
[ALApplozicSettings setGroupInfoDisabled:YES];
```

__Swift__
```
ALApplozicSettings.setGroupInfoDisabled(true)
```

##### Disable GroupInfoEdit (Edit group name and image)

__Objective-C__
```
[ALApplozicSettings setGroupInfoEditDisabled:YES];
```

__Swift__
```
 ALApplozicSettings.setGroupInfoEditDisabled(true)
 ```

#### Theme Customization

##### Set Colour for Navigation Bar

__Objective-C__
```
[ALApplozicSettings setColorForNavigation: [UIColor colorWithRed:66.0/255 green:173.0/255 blue:247.0/255 alpha:1]];
```

__Swift__
```
ALApplozicSettings.setColorForNavigation(UIColor(red: 66.0/255, green: 173.0/255, blue: 247.0/255, alpha:1))
```

##### Set Colour for Navigation Bar Item

__Objective-C__
```
[ALApplozicSettings setColorForNavigationItem: [UIColor whiteColor]];
```

__Swift__
```
ALApplozicSettings.setColorForNavigationItem(UIColor.whiteColor())
```


##### Hide/Show Tab Bar

__Objective-C__
```
[ALUserDefaultsHandler setBottomTabBarHidden: YES];
```

__Swift__
```
ALUserDefaultsHandler.setBottomTabBarHidden(true)
```

##### Set Font Face

__Objective-C__
```
[ALApplozicSettings setFontaFace: @"Helvetica"];
```

__Swift__
```
ALApplozicSettings.setFontFace("Helvetica")
```

###  Localization

1)You can get the localisation file from this link [Localizable.strings](https://github.com/AppLozic/Applozic-iOS-SDK/blob/master/sample-with-framework/applozicdemo/Base.lproj/Localizable.strings)

2)Then you need to copy text entries  from above Localizable.strings  in your file with translations for your language.


Example : 

"placeHolderText" ="Write a Message...";

Add and change the string values in your app Localizable.strings(arabic)

"placeHolderText" ="اكتب رسالة...;



#### Container View

__Objective-C__

```
// Add this in viewDidLoad to add Applozic as subview:

UIView * containerView = [[UIView alloc] init];
containerView.translatesAutoresizingMaskIntoConstraints = false;
[self.view addSubview:containerView];

[containerView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = true;
[containerView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = true;
[containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
[containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;

// Add child view controller view to container
NSBundle * bundle = [NSBundle bundleForClass:ALMessagesViewController.class];
UIStoryboard * storyboard = [UIStoryboard storyboardWithName: @"Applozic" bundle:bundle];
UIViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"ALViewController"];
[self addChildViewController: controller];
controller.view.translatesAutoresizingMaskIntoConstraints = true;
[containerView addSubview:controller.view];

[controller.view.leadingAnchor constraintEqualToAnchor: containerView.leadingAnchor].active = true;
[controller.view.trailingAnchor constraintEqualToAnchor: containerView.trailingAnchor].active = true;
[controller.view.topAnchor constraintEqualToAnchor:containerView.topAnchor].active = true;
[controller.view.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor].active = true;

[controller didMoveToParentViewController:self];
```


__Swift__
```
// Add this in viewDidLoad to add Applozic as subview:

let containerView = UIView()
containerView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(containerView)
NSLayoutConstraint.activate([
    containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
    containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
    containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
    containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
    ])

// Add child view controller view to container
let story = UIStoryboard(name: "Applozic", bundle: Bundle(for: ALMessagesViewController.self))
let controller = story.instantiateViewController(withIdentifier: "ALViewController")
addChildViewController(controller)
controller.view.translatesAutoresizingMaskIntoConstraints = false
containerView.addSubview(controller.view)

NSLayoutConstraint.activate([
    controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
    controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
    controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
    controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])

controller.didMove(toParentViewController: self)
```

#### UI source code

For complete control over UI, you can also download open source chat UI toolkit and change it as per your designs :

[https://github.com/AppLozic/Applozic-iOS-SDK](https://github.com/AppLozic/Applozic-iOS-SDK)


Import [Applozic iOS Library](https://github.com/AppLozic/Applozic-iOS-SDK/tree/master/sample-with-framework/Applozic) into your Xcode project.

Applozic contains the UI related source code, icons, views and other resources which you can customize based on your design needs.

Sample app with integration is available under [**sampleapp**](https://github.com/AppLozic/Applozic-iOS-Chat-Samples)
