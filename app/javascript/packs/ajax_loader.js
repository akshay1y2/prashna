document.addEventListener('turbolinks:load', function () {
  const $spinner =  $('#spinnerNotifier');

  $('.container')
      .on("ajax:beforeSend", () => {
        $spinner.fadeIn();
        $spinner.delay(1000).fadeOut();
      }).on("ajax:complete", () => $spinner.fadeOut()
      // ).on("ajax:error", () => $spinner.fadeOut()
      );
});
