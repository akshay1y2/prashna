class StripePayment {
  constructor(data) {
    this.$form = data.$form;
    this.stripe = Stripe(data.token);
    this.elements = this.stripe.elements();
    this.$errorsContainer = this.$form.find(data.errorsContainer);
    this.elementsContainer = data.elementsContainer;
    this.card = this.elements.create('card', {
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

  init() {
    // Add an instance of the card Element into the `card-element` <div>.
    this.card.mount(this.elementsContainer);

    this.card.on('change', (event) => this.$errorsContainer.text(event.error ? event.error.message : ''));

    this.$form.one('submit', (event) => {
      event.preventDefault();

      this.stripe.createToken(this.card).then((result) => {
        if (result.error) {
          this.$errorsContainer.text(result.error.message);
        } else {
          this.stripeTokenHandler(result.token);
        }
      });
    });
  }

  // Submit the form with the token ID.
  stripeTokenHandler(token) {
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripeToken');
    hiddenInput.setAttribute('value', token.id);
    this.$form[0].appendChild(hiddenInput);
    this.$form.submit();
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