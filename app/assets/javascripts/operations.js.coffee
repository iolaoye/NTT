# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
switch_view = ->
  if $("#div_crop_schdule").is(":hidden")
      $("#div_crop_schdule").toggle(true)
  else
      $("#div_crop_schdule").toggle(false)

  if $("#div_operations").is(":hidden")
      $("#div_operations").toggle(true)
  else
      $("#div_operations").toggle(false)
	  
upload_crop = (show) ->
  $("#div_new").toggle(show)
  
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
    $("#operation_moisture").val(100-fertilizer.dry_matter)
    $("#operation_no3_n").val(fertilizer.qn)
    $("#operation_po4_p").val(fertilizer.qp)
    $("#operation_org_n").val(fertilizer.yn)
    $("#operation_org_p").val(fertilizer.yp)

updateTypes = ->
  $("#div_amount").hide()
  $("#div_depth").hide()
  $("#div_nutrients").hide()
  $("#div_moisture").hide()
  $("#div_type").hide()
  $("#div_tillage").hide()
  switch $("#operation_activity_id").val()
    when "1" # planting
      updatePlantPopulation()
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_type").hide()
      $("#div_amount").show()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
    when "2"  # fertilizer
      url = "/fertilizer_types.json"
      $("#div_fertilizer").show()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_moisture").hide;
      $("#div_nutrients").show()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
    when "3"   # tillage
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
    when "6"   # irrigation
      url = "/irrigations.json"
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
    when "7"   # grazing
      url = "/fertilizers.json?id=animal"
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_tillage").show()
      $("#div_nutrients").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
    when "10"   # liming
      $("#div_fertilizer").hide()
      $("#div_amount").show()
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
          items.push "<option value=\"" + tillage.code + "\">" + tillage.eqp + "</option>"
        
    $("#operation_type_id").html items.join("")
    $("#operation_type_id").removeAttr("disabled")

updateFerts = ->
  if ($("#operation_type_id").val() == "2")
    $("#div_moisture").show();
  else
    $("#div_moisture").hide();
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
	
updateTitles = ->
  title = t 'operations.fertilizer'
  $("#typeTitle").text(title)
	
$(document).ready ->
    $("#btnBack").click ->
        upload_crop(false)

    $("#new_crop").click ->
        upload_crop(true)

    $("#btn_views").click ->
        switch_view()

	#updateTypes()
    #updateFerts()

    $("#operation_activity_id").change ->
      updateTypes()
	
    $("#operation_type_id").change ->
      updateFerts()

    $("#operation_subtype_id").change ->
      updateNutrients(0)

    $("#operation_crop_id").change ->
      updatePlantPopulation() 

    $("#rowIdOdd").click ->
      updateTitles()

    $("#rowIdEven").click ->
      updateTitles()

    $("#add").click ->
       crop_schedule = document.getElementById('cropping_system_id');
       $('#tblCrops').append($("<tr>"));
       $('#tblCrops tr').append($("<td>"));
       tbl = $('#tblCrops')
       tbl[0].rows[tbl[0].rows.length-1].cells[0].innerText = crop_schedule[crop_schedule.selectedIndex].text
       year = +$('#year').val();
       $('#tblCrops tr').append($("<td>"));
       tbl = $('#tblCrops')
       tbl[0].rows[tbl[0].rows.length-1].cells[1].innerText = $('#year').val();
       year = year + 1;
       $('#year').val(year);
       $('#tblCrops tr').append($("<td>"));
       tbl = $('#tblCrops');
       button= document.createElement("button_tag");
       button.innerHTML = "Remove";
       cell = tbl[0].rows[tbl[0].rows.length-1].cells[2];
       a = 1;

    $('#replace').click ->
      $('#year').toggle(!@checked)
      $('#year_label').toggle(!@checked)
      document.getElementById('year').disabled = @checked
      if (@checked)
        r = confirm('Are you sure? When you upload, this will delete all your current operations')
        if r == false
          $("#replace").removeAttr('checked');
          $('#year').toggle(true)
          $('#year_label').toggle(true)
      return