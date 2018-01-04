check_soil_test = ->
   $("#div_soil_al").toggle(false)
   if $("#layer_soil_test_id").val() == "1"
      $("#layer_soil_p_initial").attr("disabled", true)
      $("#layer_soil_p_initial").val('')
   else
      $("#layer_soil_p_initial").attr("disabled", false)
   if $("#layer_soil_test_id").val() == "5"
      $("#div_soil_al").prop('required',true)
      $("#div_soil_al").toggle(true)
   else
      $("#div_soil_al").prop('required',false)

$(document).ready ->
  if $("#layer_soil_test_id").val() == "1" #disable input on load if 'none'
    $("#layer_soil_p_initial").attr("disabled", true)
    $("#layer_soil_p_initial").val('')
  if $("#layer_soil_test_id").val() == "5" #display alumninum on load 
    $("#div_soil_al").toggle(true)
    $("#div_soil_al").prop('required',true)
  else
    $("#div_soil_al").prop('required',false)
  $("#layer_soil_test_id").change ->
    check_soil_test()