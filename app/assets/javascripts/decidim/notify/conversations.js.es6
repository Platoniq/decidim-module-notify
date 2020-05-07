//= require decidim/notify/select2

$(() => {
  const $info = $(".form-conversations-submit .info");
  const $form = $('form#new_note_');
  const originalAction = $form.attr("action");

  const resetForm = () => {
    $("#note_code").html("");
    $("#note_body").val("");
    $form.find('[name="_method"]').val("post");
    $form.attr("action", originalAction);
  };

  // reset button
  $form.find('[type="reset"]').on('click', resetForm);

  // edit button in notes
  $('#notify-notes').on('click', 'a.edit', (e) => {
    e.preventDefault();
    const $a = $(e.currentTarget);
    const code = $a.closest('.notify-note').find('.note-code').text();
    const name = $a.closest('.notify-note').find('.note-name').text();
    const body = $a.closest('.notify-note').find('.note-body').text();

    $("#note_code").append(`<option value="${code}" selected>${name}</option>`);
    $("#note_body").val(body);
    $form.find('[name="_method"]').val("patch");
    $form.attr("action", $(e.currentTarget).attr('href'));
    location = "#new_note";

    console.log("edit",$(e.currentTarget).attr('href'),code,body)
  });

  // Keypress CTRL-Enter sends form
  $("#note_body").keypress(function(e){
    if(e.ctrlKey && (e.which === 10 || e.which === 13 )) {
      Rails.fire($form[0], 'submit');
    }
  });

  const showInfo = (text, speed) => {
    $info.stop(true,true).html(text).show();
    setTimeout(() => {
      $info.fadeOut("slow");
    }, speed);
    return $info;
  };

  // Rails AJAX events
  document.body.addEventListener('ajax:error', (responseText) => {
    showInfo(responseText.detail[0].message || responseText.detail[0], 5000).removeClass('text-success').addClass('text-alert');
  });
  document.body.addEventListener('ajax:success', (responseText) => {
    showInfo("✔", 1000).removeClass('text-alert').addClass('text-success');
    resetForm();
  });
});
