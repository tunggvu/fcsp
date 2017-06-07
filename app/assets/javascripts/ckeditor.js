$(document).ready(function(){
  if ($('textarea').length === 0) return;
  var data = $('.ckeditor');
  $.each(data, function(i) {
    CKEDITOR.replace(data[i].id);
    i.enterMode = CKEDITOR.ENTER_BR;
    i.autoParagraph = false;
    i.fillEmptyBlocks = false;
  });
});

