// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


//jQuery Animations
//Animate .flash'
/*
$(document).ready(function() {
  $('.flash').parent().delay(2000).animate({ 
    opacity: 0
  }, 1500, "linear", function() {
      $(this).slideUp(300);
      $('.chapter-editor').css('opacity','0');
      $('.chapter-editor').animate({ 
        opacity: 1
      }, 500, "linear", function() {});
  });
});
*/

$(document).ready(function() {
  $('.flash .close').click(function() {
    $(this).parent().animate({opacity:0}, 700, "linear", function() {
      $(this).slideUp(300);
    });
  });
});
