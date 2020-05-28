class SubmitAnswer{
  constructor(data){
    this.$container = data.$container;
    this.answerFormId = data.answerFormId;
  }

  init(){
    this.$container
      .on("ajax:success", this.answerFormId, (event) => this.$container.html(event.detail[2].responseText))
      .on("ajax:error", this.answerFormId, (event) => alert(event.detail[1]));
  }
}

document.addEventListener('turbolinks:load', function() {
  const data = {
    $container: $("#answers-container"),
    answerFormId: "#answerInputForm"
  };
  new SubmitAnswer(data).init();
});
