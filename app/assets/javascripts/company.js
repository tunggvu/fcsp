$(document).ready(function() {
  $('body').on('click', '.pagination-article .page-link', function(e){
    var company_id = $('#company-id').val();
    var url_request = '/companies/' + company_id;
    var page_number = $(this).html();
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
    return false;
  });
});
