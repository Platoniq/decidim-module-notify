// = require cable

App.notifyNotesChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::NotesChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    // console.log("note received",data);

    if(data.create) $("#notify-notes").prepend(data.create);
    if(data.update) $(`#notify-note-${data.id}`).replaceWith(data.update);
    if(data.destroy) $(`#notify-note-${data.destroy}`).remove();
  }
});


App.notifyParticipantsChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::ParticipantsChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    // console.log("participants received",data);

    $("#notify-participants").html(data);
  }
});
