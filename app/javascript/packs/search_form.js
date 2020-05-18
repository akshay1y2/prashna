class SearchForm {
  constructor(data) {
    this.$searchForm = data.$searchForm;
    this.$input = data.$input;
    this.$searchHelp = data.$searchHelp;
    this.$searchError = data.$searchError;
  }

  init() {
    this.$searchForm.on("focusin", 'input', () => {
      this.$input.on('input', () => {
        if (this.$input.val().length) {
          this.showHelp();
        }
        else {
          this.showError();
        }
      });
    }).on("focusout", () => {
      this.$input.off('input');
      this.showHelp();
    });
    this.showHelp();
  }

  showHelp() {
    this.$input.removeClass("is-invalid");
    this.$searchHelp.show();
    this.$searchError.hide();
  }

  showError() {
    this.$input.addClass("is-invalid");
    this.$searchHelp.hide();
    this.$searchError.show();
  }
}

document.addEventListener('turbolinks:load', function () {
  const $searchForm = $("#searchForm");
  const data = {
    $searchForm: $searchForm,
    $input: $searchForm.find("input"),
    $searchHelp: $("#searchHelp"),
    $searchError: $("#searchError")
  }
  new SearchForm(data).init();
});
