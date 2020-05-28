import {loadStripe} from '@stripe/stripe-js';
class StripePayment {
  constructor(data) {
    this.data = data;
  }

  async setup(){
    var data = this.data;
    this.$form = data.$form;
    this.stripe = await loadStripe(data.token);
    this.elements = this.stripe.elements();
    this.$errorsContainer = this.$form.find(data.errorsContainer);
    this.elementsContainer = data.elementsContainer;
    this.card = this.elements.create('card', {
      hidePostalCode: true,
      style: {
        base: {
          color: '#32325d',
          fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          '::placeholder': { color: '#aab7c4' }
        },
        invalid: { color: '#fa755a', iconColor: '#fa755a' }
      }
    });
  }

  async init() {

    await this.setup();

    this.card.mount(this.elementsContainer);
    this.card.on('change', (event) => this.showError(event.error));

    this.$form.on('submit', (event) => {
      event.preventDefault();
      this.stripe.createToken(this.card).then((result) => {
        if (result.error) {
          this.showError(result.error);
        } else {
          this.stripeTokenHandler(result.token);
        }
      });
    });
  }

  stripeTokenHandler(token) {
    this.$form.append(
      $('<input/>').attr({ type: 'hidden', name: 'stripeToken', value: token.id })
    );
    this.$form.off('submit').submit();
  }

  showError(error){
    this.$errorsContainer.text(error ? error.message : '');
  }
}

document.addEventListener('turbolinks:load', function () {
  const $form = $('#payment-form');
  if (!$form.length) {
    return;
  }
  const data = {
    $form: $form,
    token: $form.data('token'),
    errorsContainer: '#card-errors',
    elementsContainer: '#card-element'
  }

  new StripePayment(data).init();
});
