$(document).ready(function(){
  $('.add-team').on('click', function(){
    $('.form-job-team').submit();
  });
  $('.new .form_ajax form').on('submit', function(e){
    e.preventDefault();
    var form = $('form')[0];
    var formData = new FormData(form);
    $.ajax({
      url: $('form').attr('action'),
      cache: false,
      type: 'POST',
      dataType: 'json',
      contentType: false,
      processData: false,
      data: formData,
      success: function(data, textStatus, xhr){
        if (xhr.status === 200) {
          $('.new .step-2-content').append(data.html_job);
          $('#step-1').hide();
          $('#step-2').slideDown();
          $('#a_step1').removeClass('selected').addClass('done');
          $('#a_step2').removeClass('disabled').addClass('selected');
          swal({
            type: 'success',
            title: I18n.t('employer.jobs.create.created'),
            text: I18n.t('employer.jobs.create.created_job')
          });
        } else {
          $(':submit').removeAttr('disabled');
          swal({
            type: 'error',
            title: I18n.t('employer.jobs.create.failed'),
            text: I18n.t('employer.jobs.create.create_job_fail')
          });
        }
      },
      error: function(){
        $(':submit').removeAttr('disabled');
        swal({
          type: 'error',
          title: I18n.t('employer.jobs.create.failed'),
          text: I18n.t('employer.jobs.create.create_job_fail')
        });
      }
    });
  });

  $('.new .buttonPrevious').click(function(){
    $('#step-1').show();
    $('#step-2').hide();
    $('#a_step1').removeClass('done').addClass('selected');
    $('#a_step2').removeClass('selected').addClass('done');
    $(':submit').removeAttr('disabled');
  });
});

function add_fields(link, association, content) {  
  var new_id = new Date().getTime();  
  var regexp = new RegExp('new_' + association, 'g');  
  $(link).parent().before(content.replace(regexp, new_id));  
}
