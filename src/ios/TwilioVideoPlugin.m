/********* TwilioVideo.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "TwilioVideoViewController.h"

@interface TwilioVideoPlugin : CDVPlugin

@property (nonatomic, strong, nullable) TwilioVideoViewController* videoViewController;
@property (nonatomic, strong, nullable) UIPanGestureRecognizer* drag;

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
        [self minimize];
    } else if ([action isEqualToString:@"maximize"]) {
        [self maximize];
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
        TwilioVideoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"TwilioVideoViewController"];

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

- (void)maximize {
    [_videoViewController maximize];
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat width = 414; // Hard coded to my 6+ width for now.
    CGFloat height = 600; // Again kinda just fits my 6+.
    _videoViewController.view.frame = CGRectMake(x, y, width, height);
    [_videoViewController.view removeGestureRecognizer:_drag];
    _videoViewController.view.layer.cornerRadius = 0;
    _videoViewController.view.layer.masksToBounds = NO;
}

- (void)minimize {
    [_videoViewController minimize];
    CGFloat x = 0;
    CGFloat y = 64;
    // Hard coded 4:3 values.
    CGFloat width = 300;
    CGFloat height = 225;
    _videoViewController.view.frame = CGRectMake(x, y, width, height);
    _drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [_videoViewController.view addGestureRecognizer:_drag];
    _videoViewController.view.layer.cornerRadius = 25;
    _videoViewController.view.layer.masksToBounds = YES;
}

- (void)handleDrag:(UIPanGestureRecognizer*)pan {
    CGPoint translation = [pan translationInView:self.viewController.view];
    UIView* view = pan.view;
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.viewController.view];
}

- (void)dismissTwilioVideoController {
    // Could add some animation here if you'd prefer.
    [_videoViewController willMoveToParentViewController:nil];
    [_videoViewController.view removeFromSuperview];
    [_videoViewController removeFromParentViewController];
    _videoViewController = nil;
}

@end
