$(document).ready(function(){
  $('#school-search').hsearchbox({
    url: '/user_educations',
    param: 'search',
    dom_id: '#result-school-search'
  });

  $('.graduation-datepicker').datepicker({
    format: 'MM yyyy',
    viewMode: 'months',
    minViewMode: 'months'
  });

  $('form.user-education-form').bind('ajax:success', function(event, xhr) {
    if(xhr['errors']) {
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
      var $form = $(this);
      if(xhr['errors']) {
        $.map(xhr['errors'], function(v) {
          var element_id = '#school-search';
          var $divFormGroup = $form.find(element_id).parent();
          $divFormGroup.addClass('has-error');
          $divFormGroup.append('<span class="help-block">' + v + '</span>');
        });
      }
    }else {
      $(this).closest('.modal').modal('hide');
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
    }
  });
});
