$(document).ready(function() {
  $('#language-search-box').hsearchbox({
    url: '/user_languages',
    param: 'company',
    dom_id: '#livesearch_dom'
  });

  $('.org-search').on('click', function() {
    $('#language-search-box').val(this.dataset.name);
  });

  $('form#new_user_language, form.edit_user_language')
    .bind('ajax:success', function(event, xhr) {
      if(xhr['errors']) {
        $('.form-group').removeClass('has-error');
        $('span').remove('.help-block');
        var $form = $(this);
        if(xhr['errors']) {
          $.map(xhr['errors'], function(v, k) {
            if(k === 'language_id') {
              var element_id = '#language-search-box';
              var $divFormGroup = $form.find(element_id).parent();
              $divFormGroup.addClass('has-error');
              $divFormGroup.append('<span class="help-block">' + v + '</span>');
            }
          });
        }
      }else {
        $(this).closest('.modal').modal('hide');
        $('.form-group').removeClass('has-error');
        $('span').remove('.help-block');
      }
    });
});
