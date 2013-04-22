# iOS - Mobile Services - Authentication
This is an authentication sample which makes use of Windows Azure Mobile Services.  Mobile Services offers built in authentication with Facebook, Google, Microsoft, and Twitter as well as the possibility to implement your own custom authentication.  This sample was built using XCode, the iOS Framework, and the iOS Mobile Services SDK.

Below you will find requirements and deployment instructions.

## Requirements
* OSX - This sample was built on OSX Lion (10.7.4) but should work with more current releases of OSX.
* XCode - This sample was built with XCode 4.4 and requires at least XCode 4.0 due to use of storyboards and ARC.
* Windows Azure Account - Needed to create and run the Mobile Service.  [Sign up for a free trial](https://www.windowsazure.com/en-us/pricing/free-trial/).

## Source Code Folders
* /source/client - This contains code for the application with Mobile Services and requires client side changes noted below.
* /source/scripts - This contains copies of the server side scripts and requires script changes noted below.

## Additional Resources
I've released two blog posts which walks through the code for this sample.  The [first deals with the server side scripts](http://chrisrisner.com/Authentication-with-Mobile-Services) and talks about how to set up the different auth providers.  The [second talks about the iOS Client](http://chrisrisner.com/Authentication-with-iOS-and-Windows-Azure-Mobile-Services) and how to connect that to the Mobile Service.

#Setting up your Mobile Service
After creating your Mobile Service in the Windows Azure Portal, you'll need to create tables named "Accounts", "AuthData", and "BadAuth".  After creating these tables, copy the appropriate scripts over.

#Client Application Changes
In order to run the client applicaiton, you'll need to change a few settings in your application.  After opening the source code in Xcode, open the StorageService.m file.  Find the init method and change the "mobileserviceurl" and "applicationkey" to match the values from the Mobile Service you've created.

#Script Changes
Inside of the accounts.insert.js script, you'll need to set the masterKey variable to the master key of your Mobile Service.  This can be accessed by going to the Dashboard for your Mobile Service in the Windows Azure portal and clicking Manage Keys at the bottom of the screen.

## Contact

For additional questions or feedback, please contact the [team](mailto:chrisner@microsoft.com).