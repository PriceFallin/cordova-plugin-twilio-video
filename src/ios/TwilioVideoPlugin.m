/********* TwilioVideo.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "TwilioVideoViewController.h"

@interface TwilioVideoPlugin : CDVPlugin

@property (nonatomic, strong, nullable) TwilioVideoViewController* videoViewController;

@end

@implementation TwilioVideoPlugin

- (void)open:(CDVInvokedUrlCommand*)command {
    NSString* room = command.arguments[0];
    NSString* token = command.arguments[1];
    [self openCallWithRoom:room andToken:token andCommand:command];
}

- (void)handleAction:(CDVInvokedUrlCommand*)command {
    // Actions are:
    // disconnect
    // flip
    // toggle_mute
    // toggle_camera
    // minimize (show the cart)
    // maximize (hide cart and show local + remote video)

    NSString* action = command.arguments[0];
    if ([action isEqualToString:@"disconnect"]) {
        [_videoViewController disconnectButtonPressed];
    } else if ([action isEqualToString:@"flip"]) {
        [_videoViewController flipcameraButtonPressed];
    } else if ([action isEqualToString:@"toggle_mute"]) {
        [_videoViewController micButtonPressed];
    } else if ([action isEqualToString:@"toggle_camera"]) {
        [_videoViewController videoButtonPressed];
    } else if ([action isEqualToString:@"minimize"]) {
        [_videoViewController minimize];
    } else if ([action isEqualToString:@"maximize"]) {
        [_videoViewController maximize];
    } else {
        NSLog(@"Bad action sent to TwilioVideoPlugin: %@", action);
        NSLog(@"Available actions are: disconnect, flip, toggle_mute, toggle_camera, minimize, maximize.");
    }
}

- (void)openCallWithRoom:(NSString*)room andToken:(NSString*)token andCommand:
(CDVInvokedUrlCommand*)command {
    // This will come from command.arguments[2...5] eventually.
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat width = 414; // Hard coded to my 6+ width for now.
    CGFloat height = 600; // Again kinda just fits my 6+.

    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"TwilioVideo" bundle:nil];
        TwilioVideoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TwilioVideoViewController"];

        vc.accessToken = token;
        UIViewController* mainVC = self.viewController;

        [mainVC addChildViewController:vc];
        vc.view.frame = CGRectMake(x, y, width, height);
        [mainVC.view addSubview:vc.view];
        [vc didMoveToParentViewController:mainVC];

        TwilioVideoPlugin* __weak weakSelf = self;
        vc.closeVideo = ^() {
            TwilioVideoPlugin* __strong strongSelf = weakSelf;
            [strongSelf dismissTwilioVideoController];
        };

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
        [vc connectToRoom:room];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        _videoViewController = vc;
    });
}

- (void)dismissTwilioVideoController {
    // Could add some animation here if you'd prefer.
    [_videoViewController willMoveToParentViewController:nil];
    [_videoViewController.view removeFromSuperview];
    [_videoViewController removeFromParentViewController];
    _videoViewController = nil;
}

@end
