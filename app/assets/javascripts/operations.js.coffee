# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
updateTypes = ->
  switch $("#operation_operation_id").val()
    when "2"
      url = "/fertilizer_types.json"
    else
      url = "/activities/" + $("#operation_operation_id").val() + "/tillages.json"

  $.getJSON url, (tillages) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each tillages, (key, tillage) ->
      switch $("#operation_operation_id").val()
        when "2"
          items.push "<option value=\"" + tillage.id + "\">" + tillage.name + "</option>"
        else
          items.push "<option value=\"" + tillage.id + "\">" + tillage.eqp + "</option>"
        
    $("#operation_type_id").html items.join("")
    $("#operation_type_id").removeAttr("disabled")

$(document).ready ->
    $("#operation_operation_id").change ->
      updateTypes()
	
