//= require decidim/notify/select2

$(() => {
  const $info = $(".form-conversations-submit .info");

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
  });
});
