create_scenario = ->
    $("#div_new").toggle(true)
    $("#div_copy_other").toggle(false)

change_select_scenarios = ->
    tbl_scenarios = $("#tbl_scenarios")
    for i in [1..tbl_scenarios[0].rows.length]
        tbl_scenarios[0].rows[i].cells[0].children[0].checked = tbl_scenarios[0].rows[0].cells[0].children[0].checked

copy_from_other_field = -> 
    $("#div_copy_other").toggle(true)
    $("#div_new").toggle(false)

loading_screen = ->
    $(".overlay").toggle(true)

select_scenarios = ->
  query = window.location.pathname
  project_id = query.split('/')[query.indexOf("projects")+1]
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

$(document).ready ->
    $("#new_scenario").click ->
        create_scenario()
    $("#select_all").click ->
        change_select_scenarios()
    $("#simulate_scenario").click ->
        loading_screen()
    $("#other_field_scenario").click ->
        copy_from_other_field()
    $("#field_id").change ->
        select_scenarios()