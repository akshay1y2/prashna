class MarkSpam {
  constructor(data) {
    this.$modal = data.$modal;
    this.$form = data.$form;
  }

  init() {
    this.$modal.on('show.bs.modal', (event) => {
      this.$target = $(event.relatedTarget);
      this.$form.find('.spam-successful-message').text('');
      this.$form.find('.spam-unsuccessful-message').text('');
      this.$form.find('textarea').show().val('');
      this.$form.find('input[type="submit"]').show();
      this.setTargettedSpammable();
      this.$form
        .on("ajax:success", (event) => this.submitResponseHandler(event.detail[0]))
        .on("ajax:error", (event) => alert(event.detail[1]));
    });
  }

  submitResponseHandler(response) {
    if (response.status) {
      this.$form.find('.spam-successful-message').text(response.message);
      this.$target.addClass('disabled');
      this.$form.find('input[type="submit"]').fadeOut();
      this.$form.find('textarea').fadeOut();
    } else {
      this.$form.find('.spam-unsuccessful-message').text(response.message);
    }
  }

  setTargettedSpammable(){
    this.$form.find('input#targettedSpammable').remove();
    this.$form.append( $('<input/>').attr(
      { type: 'hidden', id: 'targettedSpammable', name: 'spammable', value: this.$target.data('for') }
    ));
  }
}

document.addEventListener('turbolinks:load', function () {
  const data = {
    $modal: $('#spamModal'),
    $form: $('#spamForm')
  }
  new MarkSpam(data).init();
});
