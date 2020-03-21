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
      [self shareToFacebookWithResult:result andUrl:url];
  } else if ([@"shareTwitter" isEqualToString:call.method]) {
       NSString *url = call.arguments[@"url"];
       [self shareToTwitterWithResult:result andUrl:url];
  } else if ([@"shareLine" isEqualToString:call.method]) {
    NSString *url = call.arguments[@"url"];
    [self shareToLineWithResult:result andUrl:url];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)shareToFacebookWithResult:(FlutterResult)flutterResult andUrl:(NSString *)url {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:url];
    [FBSDKShareDialog showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                  withContent:content
                                     delegate:nil];
    

    flutterResult(@"success");
    //    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
}

- (void)shareToTwitterWithResult:(FlutterResult)flutterResult andUrl:(NSString *)url {
    NSString * encodedString = [NSString stringWithFormat:@"twitter://post?message=%@\n%@",
                                @"",
                                url];
    encodedString = [encodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"转码url:%@", encodedString);
    
    NSURL *twitterUrl = [NSURL URLWithString:encodedString];
//
    
    if ([[UIApplication sharedApplication] canOpenURL:twitterUrl]) {
           [[UIApplication sharedApplication] openURL:twitterUrl];
       } else {
           NSString *lineSocialUrlString = [NSString
                                  stringWithFormat:@"https://twitter.com/intent/tweet?url=%@&text=%@",
                                            [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @""];
           NSURL *url = [NSURL URLWithString:lineSocialUrlString];
           [[UIApplication sharedApplication] openURL:url];
       }
    
    
    
    
    
//    TWTRComposer *composer = [[TWTRComposer alloc] init];
//
//    [composer setText:@"just setting up my Twitter Kit"];
//    [composer setURL:[NSURL URLWithString:url]];
////    [composer setImage:[UIImage imageNamed:@"twitterkit"]];
//
//    // Called from a UIViewController
//    [composer showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController
//                          completion:^(TWTRComposerResult result) {
//        if (result == TWTRComposerResultCancelled) {
//            NSLog(@"Tweet composition cancelled");
//            flutterResult(@"failed");
//        }
//        else {
//            NSLog(@"Sending Tweet!");
//            flutterResult(@"success");
//        }
//    }];
    
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//    if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
//        TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:url image:nil videoURL:nil];
//
////            [composer setText:@"just setting up my Twitter Kit"];
////            [composer setURL:[NSURL URLWithString:url]];
//        [rootViewController presentViewController:composer animated:YES completion:nil];
//    } else {
//        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
//            if (session) {
//                TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:url image:nil videoURL:nil];
//                [rootViewController presentViewController:composer animated:YES completion:nil];
//            } else {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Twitter Accounts Available" message:@"You must log in before presenting a composer." preferredStyle:UIAlertControllerStyleAlert];
//                [rootViewController presentViewController:alert animated:YES completion:nil];
//            }
//        }];
//    }

}

//- (void)shareWithLine:(NSString *)urlStr

- (void)shareToLineWithResult:(FlutterResult)flutterResult andUrl:(NSString *)urlStr {
    //分享文字
    NSString *contentType = @"text";
    NSString *lineUrlString = [NSString
                           stringWithFormat:@"line://msg/%@/%@",
                           contentType, [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    /******分享图片
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:UIImageJPEGRepresentation([UIImage imageNamed:@"account_icon_friend.png"] , 1.0) forPasteboardType:@"public.jpeg"];
    
    NSString *contentType = @"image";
    NSString *urlString = [NSString
                           stringWithFormat:@"line://msg/%@/%@",
                           contentType, pasteboard.name]; //从剪切板中获取图片，文字亦可以如此
     */
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
