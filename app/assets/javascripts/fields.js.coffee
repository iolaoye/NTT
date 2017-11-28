check_soil_test = ->
   if $("#field_soil_test").val() == "1"
      $("#field_soilp").attr("disabled", true)
   else
      $("#field_soilp").attr("disabled", false)


$(document).ready ->
  $("#field_soil_test").change ->
    check_soil_test()