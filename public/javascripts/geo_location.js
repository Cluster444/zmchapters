$(function() {
  $("#geo_country_id").change(function() {
    $("#geo_id").load("/geo/"+$(this).val()+"/territory_options");
  });
});
