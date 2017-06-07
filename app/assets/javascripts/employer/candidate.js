$(document).ready(function() {
  $('.select-job').on('change', function() {
    var job_id = $(this).val(),
      company_id = $('#company-id').val();
    $.ajax({
      dataType: 'json',
      url: '/employer/companies/' + company_id + '/candidates',
      method: 'get',
      data: {select: job_id},
      success: function(data) {
        $('#list-candidates').html(data.html_job);
      },
      error: function() {
        alert(I18n.t('employer.candidates.not_found'));
      }
    });
  });

  $('body').on('change', '#checkbox-check-all', function() {
    var checkboxes = $(this).parents('table')
      .find('tbody input[type = "checkbox"]');
    if($(this).is(':checked')) {
      checkboxes.prop('checked', true);
    } else {
      checkboxes.prop('checked', false);
    }
  });

  $('.button-direct .btn-cancel').click(function(){
    if ($('.btn-filter').hasClass('open')) {
      $('.btn-filter').removeClass('open');
    }
  });

  $('.btn-filter').each(function(){
    if ($(this).parent().position().left > 600) {
      $(this).children().eq(1).css('left','-232px');
    }
  });

  $('.filter .checkall').click(function() {
    var checkboxes = $(this).parent().siblings('.list-item-value').children().children('input[type = "checkbox"]');
    checkboxes.prop('checked', true);
  });

  $('.filter .delete').click(function() {
    var checkboxes = $(this).parent().siblings('.list-item-value').children().children('input[type = "checkbox"]');
    checkboxes.prop('checked', false);
  });

  $('body').on('click', '.dropdown-toggle', function(){
    $('.dropdown-toggle').dropdown();
  });

  $('.main_container').on('click', '.sortAlpha, .btn-ok', function(e){
    e.preventDefault();
    var typefilter = $(this).parents().eq(2).attr('data-filter');
    var sort_by = $(this).attr('data-sort-by');
    var listcheckbox = $(this).parents('ul').children().find('.checkboxitem');
    var arrchecked = [];
    var company_id = $('#company-id').val();
    var filter_mode = $(this).parents().eq(2).attr('data-model');

    listcheckbox.each(function(){
      if ($(this).is(':checked')) {
        arrchecked.push($(this).attr('data-list-id'));
      }
    });

    var params = {type: typefilter, sort: sort_by, array_id: arrchecked};
    var tbody = '';
    var url_request = '';

    switch (filter_mode) {
    case 'candidate':
      url_request = '/employer/companies/' + company_id + '/candidates';
      tbody = $('#list-candidates');
      break;

    case 'job':
      url_request = '/employer/companies/' + company_id + '/jobs';
      tbody = $('.jobs-list');
      break;

    case 'team':
      url_request = '/employer/companies/' + company_id + '/teams';
      tbody = $('.jobs-list');
      break;

    case 'job-team':
      url_request = '/employer/companies/' + company_id + '/job_team';
      tbody = $('.teams-list');
      break;  
    }

    $.ajax({
      dataType: 'json',
      url: url_request,
      method: 'GET',
      data: params,
      success: function(data) {
        tbody.html(data.html_job);
        switch (filter_mode) {
        case 'candidate':
          $('.pagination-bar').html(data.pagination_candidate);
          break;

        case 'job':
          $('.pagination-job').html(data.pagination_job);
          break;
        }

        if (filter_mode === 'job-team') {
          $('.pagination-job').html(data.pagination_job);
        }

        if ($('.btn-filter').hasClass('open')) {
          $('.btn-filter').removeClass('open');
        }
      },
      error: function() {
        swal({
          type: 'danger',
          title: I18n.t('employer.team_introductions.danger'),
          text: I18n.t('employer.team_introductions.danger')
        });
      }
    });

  });

  $('.search-user-filter').keyup(function(){
    var value = $(this).val(),
      object_checkbox = $(this).parents('.value-sort')
        .children('.list-item-value').find('.checkbox');
    if (value == '') {
      object_checkbox.show();
    }
    else {
      object_checkbox.each(function(){
        if ($(this).children('label').html().toLowerCase().search(value.toLowerCase()) >= 0) {
          $(this).show();
        }else {
          $(this).hide();
          $(this).children('input').attr('checked', false);
        }
      });
    }
  });
  $('.table-candidates').on('mouseover', '.col-process .process', function(){
    $(this).find('.popup-change-status').show();
  });
  $('.table-candidates').on('mouseout', '.col-process .process', function(){
    $(this).find('.popup-change-status').hide();
  });

  $('.table-candidates').on('click', '.btn-change-process', function(){
    var type_change = $(this).attr('data-change'),
      candidate_id = $(this).parent().attr('data-candidate-id'),
      company_id = $('#company-id').val(),
      url_request = '/employer/companies/' + company_id + '/candidates/'
        + candidate_id,
      button_process = $(this).closest('.process').find('b'),
      box_process = $(this).closest('.popup-change-status'),
      candidate_name = $(this).closest('tr')
        .find('.col-username .title b').text(),
      type_to = $(this).text(),
      type_from = button_process.text(),
      message = '<p> ' + I18n.t('employer.candidates.from') + ' <b>'
        + type_from + ' </b> ' + I18n.t('employer.candidates.to') + ' <b>'
        + type_to + ' </b></p><b>'
        + candidate_name + '</b>';

    swal({
      title: I18n.t('employer.candidates.are_you_sure'),
      html: message,
      showCloseButton: true,
      showCancelButton: true
    }).then(
      function() {
        $.ajax({
          url: url_request,
          method: 'PUT',
          dataType: 'json',
          data: {type: type_change},
        })
        .done(function(data) {
          swal({
            type: 'success',
            title: I18n.t('employer.candidates.changed'),
            html: I18n.t('employer.candidates.process_has_been'),
            timer: 2000
          }).catch(swal.noop);

          button_process.html(data.type);
          button_process.attr('class', data.class_button);
          box_process.html(data.box_process);
        });
      },
      function () {
      });
  });

  $('.table-candidates').on('click', '.pagination-bar .page-link', function(e){
    e.preventDefault();
    var url_request = $(this).attr('href');
    var tbody = $('#list-candidates');

    $.ajax({
      dataType: 'json',
      url: url_request,
      method: 'GET',
      success: function(data) {
        tbody.html(data.html_job);
        $('.pagination-bar').html(data.pagination_candidate);
      }
    });
  });
});

$(document).on('click.my', '.filter', function(e) {
  e.stopPropagation();
});
