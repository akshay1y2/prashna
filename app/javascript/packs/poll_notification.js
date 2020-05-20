class PollNotification {
  constructor(data) {
    this.$toast = data.$toast;
    this.$bell = data.$bell;
    this.url = data.url;
    this.notifications_path = data.notifications_path;
    this.interval = data.interval;
    this.iteration = data.iteration;
  }

  init() {
    let iteration = 1;
    let time = new Date().toUTCString();
    const interval = setInterval(() => {
      this.sendRequest(time);
      if (iteration < this.iteration) {
        iteration++;
        time = new Date().toUTCString();
      } else {
        clearInterval(interval);
      }
    }, this.interval);
  }

  sendRequest(time){
    $.ajax({
      type: "GET",
      url: this.url,
      data: { time: time },
      success: (response) => this.onSuccess(response),
      error: (_, status, error) => console.log(`${status}: ${error}`)
    });
  }

  onSuccess(response) {
    if (response.count < 1) {
      return
    }
    this.$toast.find('.toast-header strong').text(`You have ${response.count} new notifications.`);
    this.$toast.find('.toast-header small').text(`since ${this.interval/1000}s`);
    this.$toast.find('.toast-body').html(`
      Total: ${response.total} unseen notifications,<br><hr/>
      Click <a href='${this.notifications_path}'>here</a> to check.
    `);
    this.$toast.toast('show');
    this.$bell.text(response.total);
  }
}

document.addEventListener('turbolinks:load', function () {
  const $toast = $('.toast');
  if(!$toast.length){
    return;
  }
  const data = {
    $toast: $toast,
    $bell: $('#notification-bell-count'),
    url: $toast.data('path'),
    notifications_path: $toast.data('notifications_path'),
    interval: 5000,
    iteration: 5
  };
  new PollNotification(data).init();
});
