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
    const filtered_tags = data.json.msg.filter(x => $data.data('topics').includes(x));
    if(!filtered_tags.length){
      return false;
    }
    // FIXME_AB: Lets do two things.
    // FIXME_AB: 1. in the toast display the question title and topic
    // FIXME_AB: 2. add a bell icon in the top header(like facebook) which will show the count returned by this ajax request.
    // FIXME_AB: 3. clicking on this bell icon: should take user to /users/notifications (notifications controller index action, should be nested resource), where we should display all notifications(paginated) with read and unread status
    $.ajax({
      type: "GET",
      url: $data.data('path'),
      data: $.param({ q: $data.data('user') }),
      success: (response) => {
        $toast.find('.toast-header strong').text(response.head);
        $toast.find('.toast-header small').text(`@${data.json.time}`)
        $toast.find('.toast-body').html(`${response.body}<br>topics: ${data.json.msg}`);
        $toast.toast('show');
      },
      error: (_, status, error) => console.log(`${status}: ${error}`)
    });
  }
});
