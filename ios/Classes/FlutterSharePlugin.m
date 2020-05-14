#import "FlutterSharePlugin.h"
#import "FBSDKShareKit.h"
#import <TwitterKit/TWTRKit.h>

@implementation FlutterSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_share_plugin"
            binaryMessenger:[registrar messenger]];
  FlutterSharePlugin* instance = [[FlutterSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"shareFacebook" isEqualToString:call.method]) {
    NSString *url = call.arguments[@"url"];
      [self shareToFacebookWithResult:result andUrl:url andQuote: call.arguments[@"msg"]];
  } else if ([@"shareTwitter" isEqualToString:call.method]) {
    [self shareToTwitterWithResult:call.arguments[@"msg"] andUrl:call.arguments[@"url"]];
      //  NSString *url = call.arguments[@"url"];
      //  [self shareToTwitterWithResult:result andUrl:url];
  } else if ([@"shareLine" isEqualToString:call.method]) {
    NSString *url = call.arguments[@"url"];
    [self shareToLineWithResult:result andUrl:url];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)shareToFacebookWithResult:(FlutterResult)flutterResult andUrl:(NSString *)url andQuote:(NSString*)quote {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:url];
    content.quote = quote;
    [FBSDKShareDialog showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                  withContent:content
                                     delegate:nil];
    

    flutterResult(@"success");
}

- (void)shareToTwitterWithResult:(NSString*)text
                          andUrl:(NSString*)url {
    NSString* encodedString = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@&url=%@", text, url];
    encodedString = [encodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    NSURL *twitterUrl = [NSURL URLWithString:encodedString];
    
    if ([[UIApplication sharedApplication] canOpenURL:twitterUrl]) {
           [[UIApplication sharedApplication] openURL:twitterUrl];
       } else {
           NSString *lineSocialUrlString = [NSString
                                  stringWithFormat:@"https://twitter.com/intent/tweet?url=%@&text=%@",
                                            [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @""];
           NSURL *url = [NSURL URLWithString:lineSocialUrlString];
           [[UIApplication sharedApplication] openURL:url];
       }

}


- (void)shareToLineWithResult:(FlutterResult)flutterResult andUrl:(NSString *)urlStr {
    NSString *contentType = @"text";
    NSString *lineUrlString = [NSString
                           stringWithFormat:@"line://msg/%@/%@",
                           contentType, [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:lineUrlString];
    NSLog(@"%@",url);
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
          NSString *lineSocialUrlString = [NSString
                                 stringWithFormat:@"https://social-plugins.line.me/lineit/share?url=%@",
                                           [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
          NSURL *url = [NSURL URLWithString:lineSocialUrlString];
          [[UIApplication sharedApplication] openURL:url];
    }
}

@end
