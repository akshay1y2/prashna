class PollNotification{
  constructor(data){
    this.$toast = data.$toast;
    this.$bell = data.$bell;
    this.url = data.url;
  }

  init(){
    this.$toast.find('.toast-header strong').text('header');
    this.$toast.find('.toast-header small').text('time');
    this.$toast.find('.toast-body').html('<br>body<hr/>');
    this.$toast.show('slow');
    $.ajax({
      type: "GET",
      url: this.url,
      success: (response) => this.$bell.text(response.count),
      error: (_, status, error) => console.log(`${status}: ${error}`)
    });
  }
}

document.addEventListener('turbolinks:load', function() {
  console.log('loaded');
  const $toast = $('.toast');
  const data = {
    $toast: $toast,
    $bell: $('#notification-bell-count'),
    url: $toast.data('path')
  };
  new PollNotification(data).init();
});
