//a = $("#geo_country_id"); b = $("#user_geographic_location_id");
//$(function(){a.change(function(){b.load("/geo/"+a.val()+"/territory_options");})});

$(function() {
  $("#geo_country_id").change(function() {
    $("#user_geographic_location_id").load("/geo/"+$(this).val()+"/territory_options");
  });
});
