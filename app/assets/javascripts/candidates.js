$(function() {
  candidate.initialize();
});

var candidate = {
  initialize: function() {
    candidate.apply_job();
    candidate.unapply_job();
  },

  apply_job: function() {

    $('body').on('click', '.apply_job', function() {
      const url_path = window.location.pathname;
      $.ajax({
        url: url_path,
        type: 'GET',
        success: function(data){
          const qualified_profile = data['qualified_profile'];
          if(qualified_profile){
            $('#apply_job_modal').modal('show');
          }else {
            $('#apply_job_failed_modal').modal('show');
          }
        }
      });
    });

    $(document).on('click', '#btn-apply-job-entry', {}, function(){
      const job = $(this).attr('job');
      const self = $('.apply_job');
      $.ajax({
        url: '/candidates/',
        type: 'POST',
        data: {id: job},
        success: function(){
          $('#apply_job_modal').modal('hide');
          $('#apply_job_success_modal').modal('show');
          self.removeClass('apply_job add-apply')
            .addClass('cancel_apply_job rm_apply applied');
        }
      });
    });
  },

  unapply_job: function() {
    $('body').on('click', '.cancel_apply_job', function() {
      const self = $(this);
      const job = $(this).attr('id');
      $.ajax({
        url: '/candidates/' + job,
        type: 'DELETE',
        success: function() {
          self.removeClass('cancel_apply_job rm_apply applied')
            .addClass('apply_job add-apply');
        }
      });
      return false;
    });
  }
}
