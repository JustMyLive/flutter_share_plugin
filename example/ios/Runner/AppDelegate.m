#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TwitterKit/TWTRKit.h>
//#import "FBSDKCoreKit"

//#import "FBSDKCoreKit/FBSDKCoreKit.h"

@implementation AppDelegate

//- (BOOL)application:(UIApplication *)application
//    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  [GeneratedPluginRegistrant registerWithRegistry:self];
//  // Override point for customization after application launch.
//  return [super application:application didFinishLaunchingWithOptions:launchOptions];
//}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // You can skip this line if you have the latest version of the SDK installed
  [[FBSDKApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];
    
    [[Twitter sharedInstance] startWithConsumerKey:@"hTpkPVU4pThkM0" consumerSecret:@"ovEqziMzLpUOF163Qg2mj"];

//    [[TWTRTwitter sharedInstance] startWithConsumerKey:@"yQTTgWboLnud9DnzyAzZssJHE" consumerSecret:@"PDjmQge7oEMfG9vWxgcm8xHkV6ZQAEl0aLqYXbZnxXBSOzD8RH"];
//    [[TWTRTwitter sharedInstance] start];
//    TWTRTwitter.sharedInstance().start(withConsumerKey:consumerSecret:)
  // Add any custom logic here.
  return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[Twitter sharedInstance] application:application openURL:url options:options];

//  BOOL handled =  [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
//  // Add any custom logic here.
//  return handled;
}

@end
