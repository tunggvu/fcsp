$(document).ready(function() {

  $('#livesearch_input').hsearchbox({
    url: '/user_works',
    param: 'company',
    dom_id: '#livesearch_dom'
  });

  $('.org-search').on('click', function() {
    $('#livesearch_input').val(this.dataset.name);
  });

  $('.work-date').datepicker({
    dateFormat: 'dd-mm-yy'
  });
});
