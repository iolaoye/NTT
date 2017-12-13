check_soil_test = ->
   $("#div_soil_al").toggle(false)
   if $("#layer_soil_test_id").val() == "1"
      $("#layer_soil_p_initial").attr("disabled", true)
   else
      $("#layer_soil_p_initial").attr("disabled", false)
   if $("#layer_soil_test_id").val() == "7"
      $("#div_soil_al").toggle(true)

$(document).ready ->
  $("#layer_soil_test_id").change ->
    check_soil_test()