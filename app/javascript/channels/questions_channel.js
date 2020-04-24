import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const $toast = $('.toast');
    const $data = $('#user-data');
    if(!$data.length){
      return false;
    }
    const filtered_tags = data.json.topics.filter(x => $data.data('topics').includes(x));
    if(!filtered_tags.length){
      return false;
    }
    $toast.find('.toast-header strong').text(data.json.head);
    $toast.find('.toast-header small').text(`@${data.json.time}`)
    $toast.find('.toast-body').html(`${data.json.body}<br>topics: ${data.json.topics}`);
    $toast.toast('show');
    $.ajax({
      type: "GET",
      url: $data.data('path'),
      data: $.param({ q: $data.data('user') }),
      success: (response) => $('#notificaion-bell-count').text(response.count),
      error: (_, status, error) => console.log(`${status}: ${error}`)
    });
  }
});
