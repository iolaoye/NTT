create_scenario = ->
    $("#div_new").toggle(true)
    $("#div_copy_other").toggle(false)
    $("#div_upload").toggle(false)

change_select_scenarios = ->
    tbl_scenarios = $("#tbl_scenarios")
    for i in [1..tbl_scenarios[0].rows.length]
        tbl_scenarios[0].rows[i].cells[0].children[0].checked = tbl_scenarios[0].rows[0].cells[0].children[0].checked

copy_from_other_field = ->
    $("#div_copy_other").toggle(true)
    $("#div_new").toggle(false)
    $("#div_upload").toggle(false)

upload_user_scenarios = ->
    $("#div_upload").toggle(true)
    $("#div_copy_other").toggle(false)
    $("#div_new").toggle(false)

loading_screen = ->
    $(".overlay").toggle(true)

select_scenarios = ->
  query = window.location.pathname
  #project_id = query.split('/')[query.indexOf("projects")+1]
  project_id = $("#project_id").val()
  field = $("#field_id").val()
  scenario = "#scenario_id"
  url = "/projects/" + project_id + "/fields/" + field + "/scenarios.json"
  if field > 0
    $.getJSON url, (scenarios) ->
      items = []
      items.push "<option value>Select Scenarios</option>"
      $.each scenarios, (key, scenario) ->
        items.push "<option value=\"" + scenario.id + "\">" + scenario.name + "</option>"
      $(scenario).html items.join("")
      $(scenario).removeAttr("disabled")
  else
    items = []
    items.push "<option value>Select Scenarios</option>"
    $(scenario).html items.join("")
    $(scenario).removeAttr("disabled")

select_fields = ->
  query = window.location.pathname
  project = $("#project_id").val()
  field = "#field_id"
  url = "/projects/" + project + "/fields.json"
  if project > 0
    $.getJSON url, (fields) ->
      items = []
      items.push "<option value>Select Fields</option>"
      $.each fields, (key, field) ->
        items.push "<option value=\"" + field.id + "\">" + field.field_name + "</option>"
      $(field).html items.join("")
      $(field).removeAttr("disabled")
  else
    items = []
    items.push "<option value>Select Fields</option>"
    $(field).html items.join("")
    $(field).removeAttr("disabled")

$(document).ready ->
    $("#new_scenario").click ->
        create_scenario()
    $("#select_all").click ->
        change_select_scenarios()
    $("#simulate_scenario").click ->
        loading_screen()
        $("#simulate_fem").toggle(false)
        $("#simulate_aplcat").toggle(false)
    $("#simulate_aplcat").click ->
        loading_screen()
        $("#simulate_fem").toggle(false)
        $("#simulate_scenario").toggle(false)
    $("#simulate_fem").click ->
        loading_screen()
        $("#simulate_scenario").toggle(false)
        $("#simulate_aplcat").toggle(false)
    $("#other_field_scenario").click ->
        copy_from_other_field()
    $("#upload_scenarios").click ->
        upload_user_scenarios()
    $("#field_id").change ->
        select_scenarios()
    $("#project_id").change ->
        select_fields()
