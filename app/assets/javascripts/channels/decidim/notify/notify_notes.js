// = require cable

App.notifyNotesChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::NotesChannel", id: window.Notify && window.Notify.id }, {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("received",data);

    $("#notify-notes").prepend(data);
  }
});
