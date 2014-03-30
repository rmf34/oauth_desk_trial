(function($, desk) {
  $.extend(desk.ensure_namespace(['authentications', 'desk_show']), {
    init: function(){
      $('.data_table').dataTable({
        'sPaginationType': 'bootstrap'
      });
    }
  });
})(jQuery, window.desk);
