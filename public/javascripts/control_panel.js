$(function() {
  $('#control-panel .tab').each(function() {
    $(this).click(function(event) {
      cpanel = $(event.target).attr('ref');
      $("#control-panel .cpanel").hide();
      $(cpanel).show();
    });
  });

  $('#control-panel .cpanel .close').each(function() {
    $(this).click(function(event) {
      cpanel = $(this).parent();
      cpanel.hide();
    });
  });
});
