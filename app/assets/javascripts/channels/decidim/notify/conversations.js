// = require cable

App.notifyNotesChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::NotesChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    // console.log("note received",data);

    if(data.create) $(`#notify-chapter-notes-${data.chapterId}`).prepend(data.create);
    if(data.update) {
      $note = $(`#notify-note-${data.id}`);
      $old = $note.closest(".notify-chapter-notes");
      $new = $(`#notify-chapter-notes-${data.chapterId||"unclassified"}`);
      if($old[0] != $new[0]) {
        // TODO: put it in the right place
        $note.detach().prependTo($new);
      }
      $note.replaceWith(data.update);
    }
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

App.notifyChaptersChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::ChaptersChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("chapter received",data);

    if(data.create) {
      $(`#notify-chapters`).prepend(data.create);
      $("#note_chapter").append(`<option value="${data.title}" selected>${data.title}</option>`);
    }
  }
});
