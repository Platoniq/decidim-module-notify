// = require cable

jQuery.fn.reverse = [].reverse;

var updateEmptyStatus = function(selector) {
  $(selector).each(function(){
    if($(this).children().length == 0){
      $(this).addClass("empty");
    } else {
      $(this).removeClass("empty");
    }
  });
};

App.notifyNotesChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::NotesChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // console.log("note received",data);

    if(data.create) $(`#notify-chapter-notes-${data.chapterId||"unclassified"}`).prepend(data.create);
    if(data.update) {
      $note = $(`#notify-note-${data.id}`);
      $old = $note.closest(".notify-chapter-notes");
      $new = $(`#notify-chapter-notes-${data.chapterId||"unclassified"}`);
      if($old[0] != $new[0]) {
        // TODO: put it in the right place by time of creation
        $note.detach().prependTo($new);
      }
      $note.replaceWith(data.update);
    }
    if(data.destroy) $(`#notify-note-${data.destroy}`).remove();

    updateEmptyStatus(".notify-chapter-notes");
  }
});


App.notifyParticipantsChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::ParticipantsChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // console.log("participants received",data);

    $("#notify-note_takers").html(data.noteTakers);
    $("#notify-participants").html(data.participants);
  }
});

App.notifyChaptersChannel = App.cable.subscriptions.create({ channel: "Decidim::Notify::ChaptersChannel", id: window.Notify && window.Notify.id }, {
  received: function(data) {
    // console.log("chapter received",data);

    if(data.create) {
      $("#notify-chapters").prepend(data.create);
      $(document).foundation();
      if (!$(`#note_chapter [value="${data.title}"]`).length) {
        var newOption = new Option(data.title, data.title, true, true);
        $("#note_chapter").append(newOption).trigger("change");
      }
    }

    if(data.update) {
      var $chapter = $(`#notify-chapter-${data.id} .chapter-title`);
      if($chapter.length) {
        var old = $chapter.text();
        $chapter.text(data.update);
        if(data.active) {
          $(".notify-chapter h3").removeClass("active");
          $(`.toggle-chapter-active .switch-input:not(#chapter_active-${data.id})`).prop("checked", false);
          $chapter.closest("h3").addClass("active");
        }
        var activate = $('#note_body').val()=="" && data.active;
        var newOption = new Option(data.update, data.update, activate, activate);
        $(`#note_chapter [value="${old}"]`).remove();
        $('#note_chapter').append(newOption).trigger('change');
      } else {
        console.error("Chapter not found", data);
      }
    }

    if(data.destroy) {
      // Move notes to the unclassified
      $unclassified = $("#notify-chapter-notes-unclassified");
      $(`#notify-chapter-notes-${data.destroy} .notify-note`).reverse().each(function() {
        $(this).detach().prependTo($unclassified);
      });

      $(`#notify-chapter-${data.destroy}`).remove();
    }

    updateEmptyStatus(".notify-chapter-notes");
  }
});
