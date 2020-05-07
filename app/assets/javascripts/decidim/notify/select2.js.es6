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
      templateSelection: (item) => `<b>${item.id}</b> - ${item.text}`,
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
      placeholder: placeholder,
      theme: "foundation",
      selectOnClose: true,
      escapeMarkup: (markup) => markup,
      templateSelection: (item) => `<b>${item.id}</b> - ${item.text}`,
      templateResult: function(item) {
        return `<div class="select2-result-repository">
          <div class="select2-result-repository__avatar" style="background-image:url(${item.avatar})">
            <div class="hex1"></div><div class="hex2"></div>
          </div>
          <div class="select2-result-repository__meta">
            <b>${item.id}</b> - ${item.text}
          </div>
        </div>`;
      }
    });

    $(this).on('select2:close', () => $('#note_body').select());
  });
});
