change_select = ->
    tbl_scenarios = $("#tbl_scenarios")
    for i in [1..tbl_scenarios[0].rows.length]
        tbl_scenarios[0].rows[i].cells[0].children[0].checked = tbl_scenarios[0].rows[0].cells[0].children[0].checked

$(document).ready ->
    $("#select_all").click ->
        change_select()
