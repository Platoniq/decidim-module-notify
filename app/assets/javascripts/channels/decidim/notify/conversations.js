// = require cable

App.notifyNotesChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::NotesChannel", id: window.Notify && window.Notify.id }, {
  connected: function() {
    console.log("connected", window.Notify.id)
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    console.log("disconnected", window.Notify.id)
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("received",data);

    if(data.create) $("#notify-notes").prepend(data.create);
    if(data.update) $(`#notify-note-${data.id}`).replaceWith(data.update);
    if(data.destroy) $(`#notify-note-${data.destroy}`).remove();
  }
});


App.notifyParticipantsChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::ParticipantsChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("received",data);

    $("#notify-participants").html(data);
  }
});
