// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Respond to the flash close button
$(document).ready(function() {
  $('.flash .close').click(function() {
    $(this).parent().animate({opacity:0}, 700, "linear", function() {
      $(this).slideUp(300);
    });
  });
});

// Ajax search / sort / paginate
$(document).ready(function() {
  $("#chapters th a, #chapters .pagination a").live('click', function() {
    $.getScript(this.href);
    return false;
  });
  $("#chapters_search input").keyup(function() {
    $.get($("#chapters_search").attr("action"), $("#chapters_search").serialize(), null, "script");
    return false;
  });
  $("#users th a, #users .pagination a").live('click', function() {
    $.getScript(this.href);
    return false;
  });
  $("#users_search input").keyup(function() {
    $.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
    return false;
  });
});

/* Navigation Control Animations */
$(document).ready( function() {
  $("#control-nav .user").click(function(){
    $('#control-nav .user').toggleClass('on');
    $('#user-container').slideToggle('fast');
  });
  $("#control-nav .admin").click(function(){
    $('#control-nav .admin').toggleClass('on');
    $('#admin-container').slideToggle('fast');
  });
});

// Turn on wymeditor
$(document).ready(function() {
  $('.wymeditor').wymeditor();
});
