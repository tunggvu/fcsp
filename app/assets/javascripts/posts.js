$(document).ready(function(){
  $('input#image-user-post').on('change', function(){
    $('.form-user-post').find('img').remove();
  });

  $('#post_search').on('keyup', function() {
    var post_search = $(this).val();
    var data = {post_search: post_search};
    $.get('/user_posts', data, null, 'script');
  });
});
