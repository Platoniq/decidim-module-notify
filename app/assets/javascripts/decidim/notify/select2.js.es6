// = require select2

$(() => {
  $('.multiusers-select').each(function() {
    const action = $(this).closest("form").attr("action")
    const url =  action.substr(0, action.indexOf("?")).replace("/conversations", "/users");
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
});
