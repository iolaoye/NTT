check_soil_test = ->
   $("#div_soil_al").toggle(false)
   if $("#layer_soil_test_id").val() == "1"
      $("#layer_soil_p_initial").attr("disabled", true)
      $("#layer_soil_p_initial").val('')
   else
      $("#layer_soil_p_initial").attr("disabled", false)
   if $("#layer_soil_test_id").val() == "7"
      $("#div_soil_al").toggle(true)

$(document).ready ->
  if $("#layer_soil_test_id").val() == "1" #disable input on load if 'none'
  	$("#layer_soil_p_initial").attr("disabled", true)
  	$("#layer_soil_p_initial").val('')
  if $("#layer_soil_test_id").val() == "7" #display alumninum on load 
    $("#div_soil_al").toggle(true)
  $("#layer_soil_test_id").change ->
    check_soil_test()