class SubmitAnswer{
  constructor(container){
    this.$answersContainer = container;
  }

  init(){
    this.$answersContainer.on("ajax:success", 'form', (event) => {
      this.$answersContainer.html(event.detail[2].responseText);
      }).on("ajax:error", (event) => alert(event.detail[1]));
  }
}

document.addEventListener('turbolinks:load', function() {
  new SubmitAnswer($("#answers-container")).init();
});
