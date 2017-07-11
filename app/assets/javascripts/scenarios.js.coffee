create_scenario = ->
    $("#div_new").toggle(true)

change_select = ->
    tbl_scenarios = $("#tbl_scenarios")
    for i in [1..tbl_scenarios[0].rows.length]
        tbl_scenarios[0].rows[i].cells[0].children[0].checked = tbl_scenarios[0].rows[0].cells[0].children[0].checked

loading_screen = ->
    $(".overlay").toggle(true)

$(document).ready ->
    $("#new_scenario").click ->
        create_scenario()
    $("#select_all").click ->
        change_select()
    $("#simulate_scenario").click ->
        loading_screen()
