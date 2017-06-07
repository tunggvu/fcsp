$(document).ready(function() {
  var picture = $('#background').val();
  $('.intro-header').css('background-image', 'url(' + picture + ')');

  $('body').on('click', '.pagination-article .page-link', function(e){
    var company_id = $('#company-id').val();
    var url_request = '/companies/' + company_id;
    var url = $(this).attr('href');
    var match = url.match(/page=(\d+)/);
    var page_number;
    if (match){
      page_number = match[1];
    }
    else
      page_number = 1;
    var tbody = $('.show-article');
    e.preventDefault();
    $.ajax({
      url: url_request,
      dataType: 'json',
      data: {page: page_number}
    })
    .done(function(data) {
      $('.show-article').html(data.company_articles);
      $('.pagination-article').html(data.pagination_company_articles);
    })
  });
});
