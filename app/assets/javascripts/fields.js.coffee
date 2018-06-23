check_soil_test = ->
   $("#div_soil_al").toggle(false)
   if $("#field_soil_test").val() == "1"
      $("#field_soilp").attr("disabled", true)
      $("#field_soilp").val('')
   else
      $("#field_soilp").attr("disabled", false)
   if $("#field_soil_test").val() == "7"
      $("#div_soil_al").toggle(true)

change_select = ->
    tbl_fields = $("#tbl_fields")
    for i in [1..tbl_fields[0].rows.length]
        tbl_fields[0].rows[i].cells[0].children[0].checked = tbl_fields[0].rows[0].cells[0].children[0].checked      

$(document).ready ->
  if $("#field_soil_test").val() == "1" #disable input on load if 'none'
  	 $("#field_soilp").attr("disabled", true)
  	 $("#field_soilp").val('')
  if $("#field_soil_test").val() == "7" #display aluminum on load 
      $("#div_soil_al").toggle(true)
  $("#field_soil_test").change ->
      check_soil_test()
  $("#select_all").click ->
      change_select()