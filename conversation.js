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
  },
  handleAction: function(actionName, succ,fail) {
    exec(
      succ || function(){},
      fail || function(){},
      'VideoConversationPlugin',
      'handleAction',
      [actionName]
    );
  }
};

module.exports = conversations;
