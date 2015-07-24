# ParseHelper
Wrapper for Parse Integration

# TO-DO

-Parse Relationships
-Easier way to upload PFFiles or photos to Parse

# Install
To use this class without Facebook you will have to create a pod file and add 
         
          pod 'Parse'

If you want to use Facebook you will have to create a pod file and add
          
          pod 'Parse'
          pod 'ParseFacebookUtilsV4'

If you wish not to use Facebook see Configure section

**Remember to add 'use_frameworks!'**

# Configure
In your AppDelegate.swift file you will have to add

          // To enable local storage
          Parse.enableLocalDatastore()
          
          // Setup Parse
          Parse.setApplicationId("ENTER YOUR APPLICATION ID", clientKey: "ENTER YOUR CLIENT KEY")
          
          // This is only needed if you plan on using Facebook with Parse
          // Go to https://parse.com/docs/ios/guide#users-facebook-users to help configure Facebook
          PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
          // This is only needed if you plan on using Twitter with Parse
          // Go to https://parse.com/docs/ios/guide#users-twitter-users to help configure Twitter
          PFTwitterUtils.initializeWithConsumerKey("YOUR CONSUMER KEY", consumerSecret: "YOUR CONSUMER SECRET")

I have included Facebook and Twitter Integration by default but if you want to remove them all you have to delete the appropriate functions.

# Usage

**Create a new user**

    let parseLogic = ParseLogic.sharedInstance
    parseLogic.createUser("example@example.com", password: "password", confirmPassword: "password", parameters:["fullName": "Example Example"]) { (success, errorMesssage) -> Void in
      if error == nil {
        // User Created Successfully
      } else {
        // Error Occured
        println(error)
      }
    }

**Log a user in**

    let parseLogic = ParseLogic.sharedInstance
    parseLogic.logInUser("example@example.com", password: "password") { (success, errorMesssage) -> Void in
      if success == false {
        // User Logged in Successfully
      } else {
        // Error Occured
        println(errorMesssage)
      }
    }
    
**Send password reset email**

    let parseLogic = ParseLogic.sharedInstance
    parseLogic.sendForgotPasswordEmail("example@example.com", completion: { (success, errorMesssage) -> Void in
      if success == false {
        // User Logged in Successfully
      } else {
        // Error Occured
        println(errorMesssage)
      }
