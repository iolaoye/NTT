check_soil_test = ->
   $("#div_soil_al").toggle(false)
   if $("#field_soil_test").val() == "1"
      $("#field_soilp").attr("disabled", true)
   else
      $("#field_soilp").attr("disabled", false)
   if $("#field_soil_test").val() == "7"
      $("#div_soil_al").attr("display", "")

$(document).ready ->
  $("#field_soil_test").change ->
    check_soil_test()