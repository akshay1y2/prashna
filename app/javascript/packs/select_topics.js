class TopicSelector{
  constructor($input){
    this.$input = $input;
  }

  init(data){
    $( () => {
      function split( val ) {
        return val.split( /,\s*/ );
      }
      function extractLast( term ) {
        return split( term ).pop();
      }

      this.$input
        // don't navigate away from the field on tab when selecting an item
        .on( "keydown", function( event ) {
          if ( event.keyCode === $.ui.keyCode.TAB &&
              $( this ).autocomplete( "instance" ).menu.active ) {
            event.preventDefault();
          }
        })
        .autocomplete({
          source: function( request, response ) {
            $.getJSON( data.url, {
              q: extractLast( request.term )
            }, response );
          },
          search: function() {
            var term = extractLast( this.value );
            if ( term.length < data.min_length ) {
              return false;
            }
          },
          focus: function() {
            // prevent value inserted on focus
            return false;
          },
          select: function( event, ui ) {
            var terms = split( this.value );
            // remove the current input
            terms.pop();
            // add the selected item
            terms.push( ui.item.value );
            // add placeholder to get the comma-and-space at the end
            terms.push( "" );
            this.value = terms.join( ", " );
            return false;
          }
        });
    } );
  }
}

document.addEventListener('turbolinks:load', function() {
  let selector = $('#user_topics');
  if(!selector.length){
    selector = $('#question_topics');
  }
  const $input = selector;
  new TopicSelector($input).init({min_length: 2, url: $input.data('url')});
});
