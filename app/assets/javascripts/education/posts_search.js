$(document).ready(function() {
  $('#posts-search-txt').on('keyup',function() {
    var term = $(this).val();
    var data = {term: term};
    $.get('posts', data, null, 'script');
  });
});
