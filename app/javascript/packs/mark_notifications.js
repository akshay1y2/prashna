class MarkNotifications{
  constructor(data){
    this.$items = data.$items;
    this.path = data.path;
    this.$bellCount = data.$bellCount;
  }

  init(){
    this.$items.one('click', 'a.badge', event => {
        $.ajax({
          type: "GET",
          url: this.path,
          data: $.param({ q: event.target.dataset.id }),
          success: (response) => this.onSuccess($(event.target), response),
          error: (_, status, error) => console.log(`${status}: ${error}`)
      });
    });
  }

  onSuccess($item, response){
    if(!response.status){
      alert('something went wrong');
      return;
    }
    $item.closest('li').removeClass('list-group-item-primary').addClass('list-group-item-dark');
    $item.parent('div.ok-btn').remove();
    this.$bellCount.text(response.bellCount);
  }
}

document.addEventListener('turbolinks:load', function() {
  const $list = $('ul.list-group');
  const data = {
    $items: $list.find('li.list-group-item-primary'),
    path: $list.data('path'),
    $bellCount: $('#notification-bell-count')
  };
  new MarkNotifications(data).init();
});