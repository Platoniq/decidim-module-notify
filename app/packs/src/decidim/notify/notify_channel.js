import consumer from "./consumer"

const App = window.App = {
  id: window.Notify && window.Notify.id,
  consumer: consumer
}

jQuery.fn.reverse = [].reverse;

const updateEmptyStatus = (selector) => {
  $(selector).each(function(){
    if($(this).children().length == 0){
      $(this).addClass("empty");
    } else {
      $(this).removeClass("empty");
    }
  });
};

App.notifyNotesChannel = App.consumer.subscriptions.create({ channel: "Decidim::Notify::NotesChannel", id: App.id }, {
  received(data) {
    // console.log("note received",data);

    if(data.create) $(`#notify-chapter-notes-${data.chapterId||"unclassified"}`).prepend(data.create);
    if(data.update) {
      let $note = $(`#notify-note-${data.id}`);
      let $old = $note.closest(".notify-chapter-notes");
      let $new = $(`#notify-chapter-notes-${data.chapterId||"unclassified"}`);
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


App.notifyParticipantsChannel = App.consumer.subscriptions.create({ channel: "Decidim::Notify::ParticipantsChannel", id: App.id }, {
  received(data) {
    // console.log("participants received",data);

    $("#notify-note_takers").html(data.noteTakers);
    $("#notify-participants").html(data.participants);
  }
});

App.notifyChaptersChannel = App.consumer.subscriptions.create({ channel: "Decidim::Notify::ChaptersChannel", id: App.id }, {
  received(data) {
    // console.log("chapter received",data);
    if(data.create) {
      $("#notify-chapters").prepend(data.create);
      $(document).foundation();
      if (!$(`#note_chapter [value="${data.title}"]`).length) {
        let newOption = new Option(data.title, data.title, true, true);
        $("#note_chapter").append(newOption).trigger("change");
      }
    }

    if(data.update) {
      let $chapter = $(`#notify-chapter-${data.id} .chapter-title`);
      if($chapter.length) {
        let old = $chapter.text();
        $chapter.text(data.update);
        if(data.active) {
          $(".notify-chapter h3").removeClass("active");
          $(`.toggle-chapter-active .switch-input:not(#chapter_active-${data.id})`).prop("checked", false);
          $chapter.closest("h3").addClass("active");
        }
        let activate = $('#note_body').val()=="" && data.active;
        let newOption = new Option(data.update, data.update, activate, activate);
        $(`#note_chapter [value="${old}"]`).remove();
        $('#note_chapter').append(newOption).trigger('change');
      } else {
        console.error("Chapter not found", data);
      }
    }

    if(data.destroy) {
      // Move notes to the unclassified
      let $unclassified = $("#notify-chapter-notes-unclassified");
      $(`#notify-chapter-notes-${data.destroy} .notify-note`).reverse().each(function() {
        $(this).detach().prependTo($unclassified);
      });

      $(`#notify-chapter-${data.destroy}`).remove();
    }

    updateEmptyStatus(".notify-chapter-notes");
  }
});
