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
      theme: "foundation"
    });
  });

  $('select.user-select').each(function() {
    const url = $(this).attr("data-url");
    const placeholder = $(this).attr("placeholder");

    console.log("url",url)
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
      placeholder: placeholder,
      theme: "foundation"
    });
  });
});
