$(document).ready(function() {
  $('.edu-group-tab-1').addClass('edu-group-active active');
  $('#edu-group-tab-1').addClass('edu-group-active active');
  $('.edu-group-tabs .edu-group-tab-links a').on('click', function(e)  {
    var currentAttrValue = $(this).attr('href');
    $('.edu-group-tabs ' + currentAttrValue).show().siblings().hide();
    $(this).parent('li').addClass('edu-group-active').siblings().removeClass('edu-group-active');
    $(currentAttrValue).addClass('active');
    $(currentAttrValue).siblings('.active').removeClass('active');
    e.preventDefault();
  });

  $('.permissions-search').on('keyup', function() {
    search_permission();
  });

  var data = {};
  $('.edu-permission-info').on('change', function(e) {
    var id = this.dataset.id;
    var create = $('#create-' + id).is(':checked');
    var read = $('#read-' + id).is(':checked');
    var update = $('#update-' + id).is(':checked');
    var destroy = $('#destroy-' + id).is(':checked');
    data[id] = {create: create, read: read, update: update, destroy: destroy};
    e.preventDefault();
  });

  $('.edu-update-permission a').on('click', function(e) {
    $.ajax({
      type: 'post',
      url: '/education/management/permissions',
      data: {permissions: JSON.stringify(data)},
      success: function(data) {
        if(data.status === 200) {
          $.growl.notice({message: data.flash});
        }
        else {
          $.growl.error({message: data.flash});
          location.reload();
        }
      },
      error: function(error) {
        $.growl.error({message: error});
        location.reload();
      }
    });
    e.preventDefault();
  });
});

function search_permission() {
  var table = $('.edu-group-tab.active').find('table.permission');
  var filter = $('.edu-group-tab.active').find('.permissions-search').val().toUpperCase();
  var tr = $(table).find('tr');
  for (var i = 0; i < tr.length; i++) {
    var td = $(tr[i]).find('td')[0];
    if (td) {
      if ($(td).html().toUpperCase().indexOf(filter) > -1) {
        $(tr[i]).css('display', '');
      } else {
        $(tr[i]).css('display', 'none');
      }
    }
  }
}
