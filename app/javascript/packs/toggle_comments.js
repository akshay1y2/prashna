class ToggleComments{
  constructor($buttons){
    this.$buttons = $buttons;
  }

  init(){
    this.$buttons.each((_, button)=> {
      let $button = $(button);
      $(`#${$button.data('for')}`).hide();
      $button.on('click', event => $(`#${event.target.dataset.for}`).toggle('slow'));
    });
  }
}

document.addEventListener('turbolinks:load', function() {
  new ToggleComments($('a.toggle-comments_btn')).init();
});