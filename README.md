**Using the cordova plugin**

1. Download cordova plugin helper that will automatically add the correct TwilioVideo SDK in iOS (Other cocoapods can be added if needed)
    - `npm i cordova-plugin-cocoapod-support`

2. Once downloaded use plugins command to save onto cordova CLI
    - `cordova plugin add cordova-plugin-cocoapod-support --save`    

3. Add to the project cordova-plugin-twilio-video to project
    - `ionic cordova plugin add [path/to/plugin]`

2. Implement the source code

    - Declare app name the head of source file where you want to use the plugin (ionic 2/3 only)

    - Get token And Call the API
    `cordova.videoconversation.open( RoomName: string, Token: string);`
