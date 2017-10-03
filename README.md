**Using the cordova plugin**

1. Add to the project
    - `ionic cordova plugin add [path/to/plugin]`
  
2. Implement the source code
  
    - Declare app name the head of source file where you want to use the plugin (ionic 2/3 only)
  
    - Get token And Call the API
    `cordova.videoconversation.open( RoomName: string, Token: string);`


## iOS Notes
  1. Open Ionic project in Xcode
  3.  Add TwilioVideo.framework to the project
      - Refer IOS/ Manual  Part of [https://www.twilio.com/docs/api/video/download-video-sdks#ios-sdk](https://www.twilio.com/docs/api/video/download-video-sdks#ios-sdk)
