/********* TwilioVideo.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "TwilioVideoViewController.h"

@interface TwilioVideoPlugin : CDVPlugin

@property (nonatomic, strong, nullable) UIViewController* videoViewController;

@end

@implementation TwilioVideoPlugin

- (void)open:(CDVInvokedUrlCommand*)command {
    NSString* room = command.arguments[0];
    NSString* token = command.arguments[1];

    // This will come from command.arguments[2...5] eventually.
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat width = 414; // Hard coded to my 6+ width for now.
    CGFloat height = 624; // Again kinda just fits my 6+.

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
