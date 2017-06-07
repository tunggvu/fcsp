$(function() {
  follow.initialize();
});

var follow = {
  initialize: function() {
    follow.add_follow();
    follow.unfollow();
  },

  add_follow: function() {
    $('body').on('click', '.follow-company', function() {
      var self = $(this);
      var company_id = $('#company_id').val();
      $.ajax({
        url: '/follow_companies/',
        data: {company_id: company_id},
        type: 'POST',
        success: function(data) {
          if(data.status === 200) {
            $.growl.notice({message: data.flash});
            self.removeClass('follow-company btn-warning')
              .addClass('unfollow-company btn-danger');
            self.text(I18n.t('companies.follow_form.unfollow'));
          }
          else {
            $.growl.error({message: data.flash});
          }
        },
        error: function(error) {
          $.growl.error({message: error});
        }
      });
      return false;
    });
  },

  unfollow: function() {
    $('body').on('click', '.unfollow-company', function() {
      var self = $(this);
      var company_id = $('#company_id').val();
      $.ajax({
        url: '/follow_companies/' + company_id,
        data: {company_id: company_id},
        type: 'DELETE',
        success: function(data) {
          if(data.status === 200) {
            $.growl.warning({message: data.flash});
            self.removeClass('unfollow-company btn-danger')
              .addClass('follow-company btn-warning');
            self.text(I18n.t('companies.follow_form.follow'));
          }
          else {
            $.growl.error({message: data.flash});
          }
        },
        error: function(error) {
          $.growl.error({message: error});
        }
      });
      return false;
    });
  }
};
