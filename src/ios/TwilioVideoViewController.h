//
//  TwilioVideoViewController.h
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

@import UIKit;

@interface TwilioVideoViewController : UIViewController

typedef void (^CloseVideo)();

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, copy) CloseVideo closeVideo;

- (void)connectToRoom:(NSString*)room;

- (void)disconnectButtonPressed;
- (void)flipcameraButtonPressed;
- (void)micButtonPressed;
- (void)videoButtonPressed;

@end
