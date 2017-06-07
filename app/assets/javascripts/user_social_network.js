$(document).ready(function(){
  var data = {};

  $('.create-social-network-btn').on('click', function() {
    get_data_input();
    send_request('post');
  });

  $('.update-social-network-btn').on('click', function() {
    get_data_input();
    send_request('patch');
  });

  var get_data_input = function() {
    data['facebook'] = $('#facebook').val();
    data['google'] = $('#google').val();
    data['twitter'] = $('#twitter').val();
    data['linkedin'] = $('#linkedin').val();
    data['skype'] = $('#skype').val();
    data['youtube'] = $('#youtube').val();
    data['instagram'] = $('#instagram').val();
  };

  var send_request = function(method) {
    $.ajax({
      type: method,
      url: '/user_social_networks',
      data: {social_network: JSON.stringify(data)},
      success: function(data){
        if(data.status === 200) {
          $.growl.notice({message: data.flash});
          $('#edit-social-network-modal').modal('hide');
          $('.list-social-network').replaceWith(list_social_network(data.link.facebook,
            data.link.google, data.link.twitter, data.link.linkedin,
            data.link.skype, data.link.youtube, data.link.instagram));
          if($('.create-social-network-btn')[0]){
            $('.create-social-network-btn').addClass('update-social-network-btn');
            $('.update-social-network-btn').removeClass('create-social-network-btn');
          }
        }
        else {
          $.growl.error({message: data.flash});
        }
      },
      error: function(){
        $.growl.error({message: data.flash});
        location.reload();
      }
    });
  };

  var list_social_network = function(facebook, google, twitter,
    linkedin, youtube, skype, instagram) {
    return '<a href="' + facebook + '" target="_blank"' +
      'class="social-icon si-facebook si-small si-rounded si-light"' +
      'title="Facebook">' +
      '<i class="icon-facebook"></i>' +
      '<i class="icon-facebook"></i>' +
      '</a>' +
      '<a href="' + google + '" target="_blank"' +
        'class="social-icon si-gplus si-small si-rounded si-light"' +
        'title="Google +">' +
        '<i class="icon-gplus"></i>' +
        '<i class="icon-gplus"></i>' +
      '</a>' +
      '<a href="' + twitter + '" target="_blank"' +
        'class="social-icon si-twitter si-small si-rounded si-light"' +
        'title="Twitter">' +
        '<i class="icon-twitter"></i>' +
        '<i class="icon-twitter"></i>' +
      '</a>' +
      '<a href="' + linkedin + '" target="_blank"' +
        'class="social-icon si-linkedin si-small si-rounded si-light"' +
        'title="LinkedIn">' +
        '<i class="icon-linkedin"></i>' +
        '<i class="icon-linkedin"></i>' +
      '</a>' +
      '<a href="' + skype + '" target="_blank"' +
        'class="social-icon si-skype si-small si-rounded si-light"' +
        'title="Skype">' +
        '<i class="icon-skype"></i>' +
        '<i class="icon-skype"></i>' +
      '</a>' +
      '<a href="' + youtube + '" target="_blank"' +
        'class="social-icon si-youtube si-small si-rounded si-light"' +
        'title="Youtube">' +
        '<i class="icon-youtube"></i>' +
        '<i class="icon-youtube"></i>' +
      '</a>' +
      '<a href="' + instagram + '" target="_blank"' +
        'class="social-icon si-instagram si-small si-rounded si-light"' +
        'title="Instagram">' +
        '<i class="icon-instagram"></i>' +
        '<i class="icon-instagram"></i>' +
      '</a>';
  };
});
