function delete_award(id) {
  $.ajax({
    type: 'DELETE',
    url: '/awards/' + id,
    dataType: 'json',
    success: function(data) {
      if(data['status'] === 200) {
        $('#award-' + id).remove();
        $.growl.notice({title: '', message: data['flash']});
      }
    },
    error: function(error_message) {
      $.growl.error({message: error_message});
      location.reload();
    }
  });
}

$(document).ready(function() {
  $('.datepicker').datepicker({
    format: 'dd-mm-yyyy'
  });

  $('.delete-award').on('click', function() {
    var id = this.dataset.id;
    var status_alert = I18n.t('javascripts.user_award_alert');
    if(confirm(status_alert)) {
      delete_award(id);
    }
  });

  $('form.award-form').bind('ajax:success', function(event, xhr) {
    if(xhr['errors']) {
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
      var $form = $(this);
      if(xhr['errors']) {
        $.map(xhr['errors'], function(v, k) {
          var element_id = '#award_' + k;
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
