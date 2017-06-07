
$(document).ready(function(){
  $('.next-step-2').on('click', function(){
    var caption_img = $('.caption-image').val();
    var title_job = $('.title-job').val();
    var text_job = $('.text-job').val();
    if (caption_img && title_job && text_job){ 
      $('#step-1').hide();
      $('#step-2').slideDown();
      $('#a_step1').removeClass('selected').addClass('done');
      $('#a_step2').removeClass('disabled').addClass('selected');
      swal({
        type: 'success',
        title: I18n.t('employer.jobs.new.step_1_sussess'),
        text: I18n.t('employer.jobs.new.step_1_sussess')
      });
    } else {
      swal({
        type: 'error',
        title: I18n.t('employer.jobs.new.step_1_danger'),
        text: I18n.t('employer.jobs.new.step_1_danger')
      });
    }
  });
  
  $('.edit .buttonPrevious').click(function(){
    $('#step-1').show();
    $('#step-2').hide();
    $('#a_step1').removeClass('done').addClass('selected');
    $('#a_step2').removeClass('selected').addClass('done');
    $(':submit').removeAttr('disabled');
  });
});
