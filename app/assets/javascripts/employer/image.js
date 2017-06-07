$(document).ready(function(){
  //var team_introduction.view_image('.upload-image');
  $('.change-image').on('change', function() {
    read_url(this);
  });
});

function read_url(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $('.img-upload').attr('src', e.target.result);
    };
    reader.readAsDataURL(input.files[0]);
  }
}
