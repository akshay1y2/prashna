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
    const $data = $toast.find('#user-data');
    if(!$data.length){
      return false;
    }
    const filtered_tags = data.json.msg.filter(x => $data.data('topics').includes(x));
    if(!filtered_tags.length){
      return false;
    }
    $.ajax({
      type: "GET",
      url: $data.data('path'),
      data: $.param({ q: $data.data('user') }), 
      success: (response) => {
        $toast.find('.toast-header strong').text(response.head);
        $toast.find('.toast-header small').text(`@ ${data.json.time}`)
        $toast.find('.toast-body').html(`${response.body}<br>topics: ${data.json.msg}`);
        $toast.toast('show');
        console.log(response);
      },
      error: (_, status, error) => console.log(`${status}: ${error}`)
    });
  }
});
