/* PJAX bindings */
$(document).pjax('a.load-fond', '#fonds-wrapper');
$(document).pjax('a.load-units', '#units-tree');
$(document).pjax('a.load-unit', '#units-wrapper');

$(document).ready(function() {
  $('form').on("click", "#search-button, #global-button", function(event){
    if ($('input[name="q"]').val() === "") {
      event.preventDefault();
      $("#empty-query").modal('show');
    }
  });

	$('.carousel').carousel({
		 interval: 3000
	});

});