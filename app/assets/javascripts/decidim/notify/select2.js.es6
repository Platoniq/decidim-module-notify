// = require select2

$(() => {
  $('select.multiusers-select').each(function() {
    const url = $(this).attr("data-url");
    $(this).select2({
      ajax: {
        url: url,
        delay: 100,
        dataType: "json",
        processResults: (data) => {
          return {
            results: data
          }
        }
      },
      escapeMarkup: (markup) => markup,
      templateSelection: (item) => '<b>' + item.id + '</b> ' + (item.name || item.text),
      minimumInputLength: 1,
      theme: "foundation"
    });
  });

  $('select.user-select').each(function() {
    const url = $(this).attr("data-url");
    const placeholder = $(this).attr("placeholder");

    $(this).select2({
      ajax: {
        url: url,
        delay: 100,
        dataType: "json",
        processResults: (data) => {
          return {
            results: data
          }
        }
      },
      minimumInputLength: 1,
      escapeMarkup: (markup) => markup,
      templateSelection: (item) => '<b>' + item.id + '</b> ' + (item.name || item.text),
      placeholder: placeholder,
      theme: "foundation",
      selectOnClose: true
    });

    $(this).on('select2:close', () => $('#note_body').select());
  });
});
