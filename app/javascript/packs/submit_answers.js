class SubmitAnswer{
  constructor(data){
    this.$container = data.$container;
    this.answerFormId = data.answerFormId;
    this.$spinner = data.$spinner;
  }

  init(){
    this.$container
      .on("ajax:beforeSend", this.answerFormId, (event) => this.$spinner.fadeIn()
      ).on("ajax:success", this.answerFormId, (event) => {
        this.$container.html(event.detail[2].responseText);
        this.$spinner.fadeOut();
      }).on("ajax:error", this.answerFormId, (event) => {
        alert(event.detail[1])
        this.$spinner.fadeOut();
      });
  }
}

document.addEventListener('turbolinks:load', function() {
  const data = {
    $container: $("#answers-container"),
    answerFormId: "#answerInputForm",
    $spinner: $('#spinnerNotifier')
  };
  new SubmitAnswer(data).init();
});
