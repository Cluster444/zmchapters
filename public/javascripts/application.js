// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


//jQuery Animations
//Animate .flash'
$(document).ready(function() {
  $('.flash').animate({ 
    opacity: 0
  }, 3000, "linear", function() {
      $(this).remove();
  });
});