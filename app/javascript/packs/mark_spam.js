class MarkSpam {
  constructor(data) {
    this.$modal = data.$modal;
    this.$form = data.$form;
  }

  init() {
    this.$modal.on('show.bs.modal', (event) => {
      this.$form.find('.spam-successful-message').text('');
      this.$form.find('.spam-unsuccessful-message').text('');
      this.$form.find('textarea').val('');
      this.setTargettedSpammable(event.relatedTarget);
      this.$form
        .on("ajax:success", (event) => this.submitResponseHandler(event.detail[0]))
        .on("ajax:error", (event) => alert(event.detail[1]));
    });
  }

  submitResponseHandler(response) {
    if (response.status) {
      this.$form.find('.spam-successful-message').text(response.message);
    } else {
      this.$form.find('.spam-unsuccessful-message').text(response.message);
    }
  }

  setTargettedSpammable(target){
    this.$form.find('input#targettedSpammable').remove();
    this.$form.append( $('<input/>').attr(
      { type: 'hidden', id: 'targettedSpammable', name: 'spammable', value: $(target).data('for') }
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
