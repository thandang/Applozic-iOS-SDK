## Migration Guides

#### Migrating from old version to new version 6.9.5

Add the below settings in two files 

1) In `AppDelegate` file inside the method of  `didFinishLaunchingWithOptions`  paste the below settings code 
2) In `ALChatManager`  file  inside the  method   `ALDefaultChatViewSettings`  paste the below settings

Settings code : 

Objective- c
```
[ALApplozicSettings setupSuiteAndMigrate];
```
Swift
```
ALApplozicSettings.setupSuiteAndMigrate()
```
