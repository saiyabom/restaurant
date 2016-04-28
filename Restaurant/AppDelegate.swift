//
//  AppDelegate.swift
//  Restaurant
//
//  Created by user on 2/16/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate {
    //Google Map API
    //AIzaSyCp7L1--yKEFFHEmOhQcowBvhyj3jvBLHA
    
    //GCM from APN
    //Server API key :AIzaSyAH1LTyFbxn7bJ9urtZ-3rUDEu5qh0UA3s
    //Sender ID:406181226043

    var window: UIWindow?
    
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"
    let googleMapsAPIKey = "AIzaSyCp7L1--yKEFFHEmOhQcowBvhyj3jvBLHA"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        // [END_EXCLUDE]
        // Register for remote notifications

        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        GMSServices.provideAPIKey(googleMapsAPIKey)
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                                                          options: nil, handler: {(error:NSError?) -> Void in
                                                            if let error = error {
                                                                // Treat the "already subscribed" error more gently
                                                                if error.code == 3001 {
                                                                    print("Already subscribed to \(self.subscriptionTopic)")
                                                                } else {
                                                                    print("Subscription failed: \(error.localizedDescription)");
                                                                }
                                                            } else {
                                                                self.subscribedToTopic = true;
                                                                NSLog("Subscribed to \(self.subscriptionTopic)");
                                                            }
            })
        }
    }
    
    // [START connect_gcm_service]
    func applicationDidBecomeActive( application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connectWithHandler({(error:NSError?) -> Void in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
    }
    // [END connect_gcm_service]
    
    // [START disconnect_gcm_service]
    func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }
    // [END disconnect_gcm_service]
    
    // [START receive_apns_token]
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
        // [END receive_apns_token]
        // [START get_gcm_reg_token]
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
                               kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        // [END get_gcm_reg_token]
    }
    
    // [START receive_apns_token_error]
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        NSNotificationCenter.defaultCenter().postNotificationName(
            registrationKey, object: nil, userInfo: userInfo)
    }
    
    // [START ack_message_reception]
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        // Handle the received message
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                                                                  userInfo: userInfo)
        // [END_EXCLUDE]
    }
    
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                   fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        // Handle the received message
        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
                                                                  userInfo: userInfo)
        handler(UIBackgroundFetchResult.NoData);
        // [END_EXCLUDE]
    }
    // [END ack_message_reception]
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }

   
    func application(application: UIApplication,openURL url: NSURL,sourceApplication: String?,annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,openURL: url,sourceApplication:sourceApplication,
                annotation: annotation)
    }
    // [START upstream_callbacks]
    func willSendDataMessageWithID(messageID: String!, error: NSError!) {
        if (error != nil) {
            // Failed to send the message.
        } else {
            // Will send message, you can save the messageID to track the message
        }
    }
    
    func didSendDataMessageWithID(messageID: String!) {
        // Did successfully send message identified by messageID
    }
    // [END upstream_callbacks]
    
    func didDeleteMessagesOnServer() {
        // Some messages sent to this device were deleted on the GCM server before reception, likely
        // because the TTL expired. The client should notify the app server of this, so that the app
        // server can resend those messages.
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }


    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

