$(function() {
  friend_ship.initialize();
});

var friend_ship = {
  initialize: function() {
    friend_ship.add_friend_ship();
    friend_ship.remove_friend_ship();
    friend_ship.unfriend();
  },

  add_friend_ship: function() {
    $('body').on('click', '.request-friend', function() {
      var self = $(this);
      var user_id = $('#user_id').val();
      $.ajax({
        url: '/friend_ships/',
        data: {id: user_id},
        type: 'POST',
        success: function(data) {
          if(data.status === 200) {
            $.growl.notice({title: I18n.t('users.friend_ship_form.request_friend')
              ,message: data.flash});
            self.removeClass('request-friend')
              .addClass('remove-request');
            self.empty();
            self.append('<span class="glyphicon glyphicon-remove"></span>'
              + I18n.t('users.friend_ship_form.remove_request'));
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

  remove_friend_ship: function() {
    $('body').on('click', '.remove-request', function() {
      var self = $(this);
      var user_id = $('#user_id').val();
      $.ajax({
        url: '/friend_ships/' + user_id,
        type: 'DELETE',
        success: function(data) {
          if(data.status === 200) {
            $.growl.warning({title: I18n.t('users.friend_ship_form.remove_request')
              ,message: data.flash});
            self.removeClass('remove-request')
              .addClass('request-friend');
            self.empty();
            self.append('<span class="glyphicon glyphicon-plus"></span>'
              + I18n.t('users.friend_ship_form.request_friend'));
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

  unfriend: function() {
    $('body').on('click', '.unfriend', function() {
      var self = $(this);
      var user_id = $('#user_id').val();
      $.ajax({
        url: '/friend_ships/' + user_id,
        data: {is_unfriend: true},
        type: 'DELETE',
        success: function(data) {
          if(data.status === 200) {
            $.growl.error({title: I18n.t('users.friend_ship_form.unfriend')
              ,message: data.flash});
            self.removeClass('unfriend')
              .addClass('request-friend');
            self.empty();
            self.append('<span class="glyphicon glyphicon-plus"></span>'
              + I18n.t('users.friend_ship_form.request_friend'));
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
