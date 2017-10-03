exec = require('cordova/exec');
var conversations = {
  open: function(callTo,token,succ,fail) {
    exec(
      succ || function(){},
      fail || function(){},
      'VideoConversationPlugin',
      'open',
      [callTo,token]
    );
  }
};

module.exports = conversations;