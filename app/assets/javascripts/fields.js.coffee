check_soil_test = ->
   $("#div_soil_al").toggle(false)
   if $("#field_soil_test").val() == "1"
      $("#field_soilp").attr("disabled", true)
      $("#field_soilp").val('')
   else
      $("#field_soilp").attr("disabled", false)
   if $("#field_soil_test").val() == "7"
      $("#div_soil_al").toggle(true)

$(document).ready ->
  if $("#field_soil_test").val() == "1" #disable input on load if 'none'
  	$("#field_soilp").attr("disabled", true)
  	$("#field_soilp").val('')
  if $("#field_soil_test").val() == "7" #display aluminum on load 
      $("#div_soil_al").toggle(true)
  $("#field_soil_test").change ->
    check_soil_test()