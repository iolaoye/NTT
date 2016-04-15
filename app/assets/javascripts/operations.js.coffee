# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
updatePlantPopulation = ->
  if ($("#operation_activity_id").val() == "1") 
     url = "/crops/" + $("#operation_crop_id").val() + ".json"
	 $.getJSON url, (crop) ->
        $("#operation_amount").val(crop.plant_population_ft)

updateNutrients = (animal) ->
  if (animal == 0)
     url = "/fertilizers/" + $("#operation_subtype_id").val() + ".json"
  else
     url = "/fertilizers/" + $("#operation_type_id").val() + ".json"

  $.getJSON url, (fertilizer) ->
    $("#operation_no3_n").val(fertilizer.qn)
    $("#operation_po4_p").val(fertilizer.qp)
    $("#operation_org_n").val(fertilizer.yn)
    $("#operation_org_p").val(fertilizer.yp)

updateTypes = ->
  $("#div_amount").hide()
  $("#div_depth").hide()
  $("#div_nutrients").hide()
  $("#div_tillage").hide()
  switch $("#operation_activity_id").val()
    when "1", "10"   # planting
      updatePlantPopulation()
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_tillage").show()
    when "2"  # fertilizer
      url = "/fertilizer_types.json"
      $("#div_fertilizer").show()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_nutrients").show()
      $("#div_tillage").show()
    when "3"   # tillage
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_tillage").show()
    when "6"   # irrigation
      url = "/irrigations.json"
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_tillage").show()
    when "7"   # grazing
      url = "/fertilizers.json?id=animal"
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_tillage").show()
      $("#div_nutrients").show()
    else
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_tillage").hide()

  $.getJSON url, (tillages) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each tillages, (key, tillage) ->
      switch $("#operation_activity_id").val()
        when "2", "6", "7"
          items.push "<option value=\"" + tillage.id + "\">" + tillage.name + "</option>"
        else
          items.push "<option value=\"" + tillage.id + "\">" + tillage.eqp + "</option>"
        
    $("#operation_type_id").html items.join("")
    $("#operation_type_id").removeAttr("disabled")

updateFerts = ->
  url = "/fertilizer_types/" + $("#operation_type_id").val() + "/fertilizers.json"
  $.getJSON url, (fertilizers) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each fertilizers, (key, fertilizer) ->
        items.push "<option value=\"" + fertilizer.id + "\">" + fertilizer.name + "</option>"
        
    $("#operation_subtype_id").html items.join("")
    $("#operation_subtype_id").removeAttr("disabled")
    if ($("#operation_activity_id").val() == "7")
        updateNutrients(1)

updateAnimals = ->
  url = "/fertilizer_types/" + $("#operation_type_id").val() + "/fertilizers.json"
  $.getJSON url, (fertilizers) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each fertilizers, (key, fertilizer) ->
        items.push "<option value=\"" + fertilizer.id + "\">" + fertilizer.name + "</option>"
        
    $("#operation_subtype_id").html items.join("")
    $("#operation_subtype_id").removeAttr("disabled")

$(document).ready ->
    $("#operation_activity_id").change ->
      updateTypes()
	
    $("#operation_type_id").change ->
      updateFerts()

    $("#operation_subtype_id").change ->
      updateNutrients(0)

    $("#operation_crop_id").change ->
      updatePlantPopulation() 

