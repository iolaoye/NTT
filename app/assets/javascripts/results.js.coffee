#	crops = @results1.where("crop_id > 0")
#	crops.each do |crop|
#		description = Description.new
#		description.id = crop.description_id
#		description.description = Crop.find(crop.crop_id).name + " Yield"
#		@descriptions.push(description)
#	end

turn_on_off_s = (row) ->
    if row == 1 || row == 0
       if row == 1
          $("#tbl_total").toggle(true)
          $("#tbl_detailed").toggle(false)
       else
          $("#tbl_total").toggle(false)
          $("#tbl_detailed").toggle(true)
    i=1
    while i<=9
        row1 = row + i
        i+=1
        if ($("#srow" + row1).is(":hidden"))
            $("#srow" + row1).toggle(true)
        else
            $("#srow" + row1).toggle(false)

turn_on_off_t = (row) ->
    i=1
    while i<=9
        row1 = row + i
        i+=1
        if ($("#trow" + row1).is(":hidden"))
            $("#trow" + row1).toggle(true)
        else
            $("#trow" + row1).toggle(false)

show_crops = ->
   $("#td_crops").toggle(false)
   if ($("#result5_description_id").val() == "70")
      $("#td_crops").toggle(true)
      items = []
      items.push "<option value>Select Crop</option>"
      url = "/results/" + $("#result1_scenario_id").val() + ".json" + "?id2=" + $("#result2_scenario_id").val() + "&id3=" + $("#result3_scenario_id").val()
      $.getJSON url, (crops_list) ->
         $.each crops_list, (key, crop) ->
            items.push "<option value=\"" + crop.crop_id + "\">" + crop.name + "</option>"
         $("#result7_crop_id").html items.join("")


update_crops = ->
# take the descriptions and populate the items with period = 2 Annual
  items = []
  items.push "<option value>Select Kind of Chart</option>"
  if ($("#result1_scenario_id").val() != "")
    url = "/descriptions.json"
    $.getJSON url, (description_list) ->
      $.each description_list, (key, description) ->
        if (description.id < 70 or description.id > 79)
          items.push "<option value=\"" + description.id + "\">" + description.description + "</option>"
    i = 70
    url = "/results/" + $("#field_id").val() + "/sel.json?scenario1=" + $("#result1_scenario_id").val() + "&scenario2=" + $("#result2_scenario_id").val() + "&scenario3=" + $("#result2_scenario_id").val()
    $.getJSON url, (result_list) ->
      $.each result_list, (key, result) ->
        i = i + 1
        url = "/crops/" + result.crop_id + ".json"
        $.getJSON url, (crop) ->
          items.push "<option value=\"" + i + "\">" + crop.name + " Yield </option>"
          $("#result5_description_id").html items.join("")
  else
    $("#result5_description_id").html items.join("")

generate_pdf = ->
  $("#pdf_download").click (event) ->
    $("#myForm").submit()

generate_excel = ->
  $("#csv_download").click (event) ->
    $("#myForm").submit()

display_button = ->
  string = window.location.href
  substring = 'results?button'
  if string.indexOf(substring) > -1
    set_buttons(false)
  else
    set_buttons(true)

set_buttons = (view) ->
  $("#pdf_download").toggle(view)
  $("#excel_download").toggle(view)

check_for_errors = ->
  errors = $("#errors").val() + ""
  size = errors.length
  if size > 0
    set_buttons(false)

$(document).ready ->
  show_crops()
  set_buttons(false)
  display_button()
  generate_pdf()
  check_for_errors()
  $("#result1_scenario_id").change ->
    #update_crops()
    set_buttons(false)

  $("#result2_scenario_id").change ->
    #update_crops()
    set_buttons(false)

  $("#result5_description_id").change ->
    show_crops()

  $("#result3_scenario_id").change ->
    #update_crops()
    set_buttons(false)

  $("#summary").click (event) ->
    set_buttons(true)

  $("#srow10").click () ->
    turn_on_off_s(10)
  $("#srow20").click () ->
    turn_on_off_s(20)
  $("#srow30").click () ->
    turn_on_off_s(30)
  $("#srow40").click () ->
    turn_on_off_s(40)
  $("#srow50").click () ->
    turn_on_off_s(50)
  $("#srow60").click () ->
    turn_on_off_s(60)
  $("#srow70").click () ->
    turn_on_off_s(70)
  $("#srow90").click () ->
    turn_on_off_s(90)
  $("#srow200").click () ->
    turn_on_off_s(200)
  $("#srow210").click () ->
    turn_on_off_s(210)
  $("#srow220").click () ->
    turn_on_off_s(220)
  $("#srow230").click () ->
    turn_on_off_s(230)

  $("#trow10").click () ->
    turn_on_off_t(10)
  $("#trow20").click () ->
    turn_on_off_t(20)
  $("#trow30").click () ->
    turn_on_off_t(30)
  $("#trow40").click () ->
    turn_on_off_t(40)
  $("#trow50").click () ->
    turn_on_off_t(50)
  $("#trow60").click () ->
    turn_on_off_t(60)
  $("#trow70").click () ->
    turn_on_off_t(70)
  $("#trow90").click () ->
    turn_on_off_t(90)
  $("#trow200").click () ->
    turn_on_off_t(200)
  $("#trow210").click () ->
    turn_on_off_t(210)
  $("#trow220").click () ->
    turn_on_off_t(220)
  $("#trow230").click () ->
    turn_on_off_t(230)

  $("#result_type_acre").click ->
    turn_on_off_s(0)
  $("#result_type_total").click ->
    turn_on_off_s(1)
