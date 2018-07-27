# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
switch_view = ->
  if $("#div_crop_schdule").is(":hidden")
      $("#div_crop_schdule").toggle(true)
      $("#btn_views").html("Summary View")
  else
      $("#div_crop_schdule").toggle(false)

  if $("#div_operations").is(":hidden")
      $("#div_operations").toggle(true)
      $("#btn_views").html("Crop View")
  else
      $("#div_operations").toggle(false)

upload_crop = (show) ->
  $("#div_new").toggle(show)
  $("#div_ccr").toggle(false)
  $("#year").val($("#year").val() +"1")

upload_crop1 = (show) ->
  $("#bmp_ccr_crop_id").prop('required',true)
  $("#bmp_ccr_year").prop('required',true)
  $("#bmp_ccr_month").prop('required',true)
  $("#bmp_ccr_day").prop('required',true)
  $("#bmp_ccr_type_id").prop('required',true)
  $("#div_ccr").toggle(show)
  $("#div_new").toggle(false)
  $("#year").val($("#year").val() +"1")

updatePlantPopulation = ->
  if ($("#operation_activity_id").val() == "1")
     url = "/crops/" + $("#operation_crop_id").val() + ".json"
	 $.getJSON url, (crop) ->
        $("#operation_amount").val(crop.plant_population_ft)

updateNutrients = (animal) ->
  if (animal == 1)
    url = "/fertilizers/" + $("#operation_type_id").val() + ".json"
    $.getJSON url, (fertilizer) ->
      $("#operation_no3_n").val(fertilizer.qn)
      $("#operation_po4_p").val(fertilizer.qp)
      $("#operation_org_n").val(fertilizer.yn)
      $("#operation_org_p").val(fertilizer.yp)
      $("#operation_nh3").val(fertilizer.nh3)
      $("#operation_nh3").val("")
      $("#operation_org_c").val("")
      #$("#operation_org_c").val("")
  else
    url = "/fertilizers/" + $("#operation_subtype_id").val() + ".json"
    if ($("#operation_activity_id").val() == "2")
      if ($("#operation_type_id").val() != "1")
        $.getJSON url, (fertilizer) ->
          $("#operation_no3_n").val("")
          $("#operation_po4_p").val("")
          $("#operation_org_n").val("")
          $("#operation_org_p").val("")
          $("#operation_nh3").val("")
          $("#operation_org_c").val(fertilizer.total_n)
          $("#operation_nh4_n").val(fertilizer.total_p)
          $("#div_other_nutrients")[0].children[0].children[1].value = fertilizer.total_n
          $("#div_other_nutrients")[0].children[1].children[1].value = fertilizer.total_p
          $("#operation_moisture").val(100-fertilizer.dry_matter)
          $("#op_total_n_con").val(fertilizer.total_n)
          $("#op_total_p_con").val(fertilizer.total_p)
          $("#op_moisture").val(100-fertilizer.dry_matter)
      else
        $.getJSON url, (fertilizer) ->
          $("#operation_no3_n").val(fertilizer.qn)
          if (fertilizer.qp == 100)
            $("#operation_po4_p").val(fertilizer.qp)
            $("#div_nutrients")[0].children[2].children[0].innerHTML = "P (0-100%)"
            $("#operation_po4_p").attr("readonly", true)
          else
            $("#operation_po4_p").val(Math.round(fertilizer.qp/0.4364))
            $("#div_nutrients")[0].children[2].children[0].innerHTML = "P<sub>2</sub>O<sub>5</sub> (0-100%)"
            $("#operation_po4_p").attr("readonly", false)
          $("#operation_org_n").val(fertilizer.yn)
          $("#operation_org_p").val(fertilizer.yp)
          $("#operation_nh3").val("")
          if ($("#operation_type_id").val() == "2")
            $("#operation_org_c").val("10")
          else
            $("#operation_org_c").val("25")
          $("#operation_nh4_n").val("")
          $("#op_total_n_con").val("")
          $("#op_total_p_con").val("")
          $("#operation_moisture").val("")

getGrazingFields = ->
    url = "/fertilizers.json?id=animal"
    $("#div_fertilizer").hide()
    $("#div_access_to_stream")[0].style.display = 'inline'    
    $("#div_amount").show()
    #$("#div_access_to_stream").show()
    $("#div_depth").show()
    $("#div_tillage").show()
    $("#div_nutrients").hide()
    $("#div_type").show()
    $("#div_date").show()
    $("#year1").prop('required',true)
    $("#month_id1").prop('required',true)
    $("#day1").prop('required',true)
    $("#operation_type_id").prop('required',true)
    $('div[style*="display: none"] *').removeAttr('required')
    $("#operation_amount").prop('required',true)
    $("#operation_depth").prop('required',true)
    $("#operation_amount").prop('min',1)
    $("#operation_depth").prop('min',1)
    if $("#operation_activity_id").val() == "9"
      $("#operation_moisture").prop('required',false)
      $("#operation_nh4_n").prop('required',true)
      $("#operation_moisture").prop('min',1)
      $("#operation_nh4_n").prop('min',1)
    else
      $("#operation_moisture").removeAttr('required')
    #change year for start year
    $("#div_start_date")[0].children[0].innerText = "Start Year"
    $("#div_type")[0].children[0].innerText = "Animal Type"

updateTypes = ->
  $("#operation_nh4_n").hide()
  $("#div_amount").hide()
  $("#div_access_to_stream").hide()
  $("#div_hours_in_stream").hide()
  $("#div_depth").hide()
  $("#div_nutrients").hide()
  $("#div_moisture").hide()
  $("#div_type").hide()
  $("#div_tillage").hide()
  $("#div_date").hide()
  $("#div_grazed").hide()
  $("#div_resttime").hide()
  $("#div_cover_crops").hide()
  $("#div_crops").show()
  $("#operation_month_id").val('')
  $("#operation_day").val('')
  $("#operation_crop_id").prop('required',true)
  $("#operation_subtype_id").prop('required', false)
  $('div[id="div_other_nutrients"] *').prop('required',false)
  $("#div_other_nutrients").hide()
  $('div[style*="display: none"] *').removeAttr('required') #removes required attribute from all hidden elements
  switch $("#operation_activity_id").val()
    when "1","13" # planting and cover crop
      updatePlantPopulation()
      #url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      url = "/activities/1/tillages.json" #hardcoded path for cover crop compatibility
      $("#div_fertilizer").hide()
      if $("#operation_activity_id").val() == "13" #if cover crop
        $("#div_amount").hide()
        $("#div_crops").hide()
        $("#div_cover_crops").show()
        if ($("#cc_year").val() != undefined)
          $("#operation_year").val($("#cc_year").val()-2000)
          $("#operation_month_id").val($("#cc_month").val())
          $("#operation_day").val($("#cc_day").val())
        $("#div_crops").children[0]
        $("#operation_cover_crop_id").prop('required',true)
        $("#operation_crop_id").prop('required',false)
      else
        $("#div_amount").show()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
      $("#div_type")[0].children[0].innerText = "Planting Method"
    when "2"  # fertilizer
      url = "/fertilizer_types.json"
      $("#div_fertilizer").show()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
      $("#operation_subtype_id").prop('disabled',true)
      $("#div_type")[0].children[0].innerText = "Fertilizer Category"
    when "3"   # tillage
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
      $("#div_type")[0].children[0].innerText = "Tillage Method"
    when "6"   # irrigation
      url = "/irrigations.json"
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_depth").show()
      $("#div_tillage").show()
      $("#div_type").show()
      $("#operation_type_id").prop('required',true)
      $("#operation_depth").prop('required',true)
      $("#operation_amount").prop('required',true)
      $("#div_type")[0].children[0].innerText = "Irrigation Method"
    when "7"   # continuous grazing
      url = "/fertilizers.json?id=animal"
      getGrazingFields()
    when "9"   # rotational grazing
      url = "/fertilizers.json?id=animal"
      getGrazingFields()
      $("#div_grazed").show()
      $("#div_resttime").show()
      $("#operation_nh4_n").show()
    when "12"   # liming
      $("#div_fertilizer").hide()
      $("#div_amount").show()
      $("#div_type").hide()
      $("#operation_amount").prop('required',true)
    else
      url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json"
      $("#div_fertilizer").hide()
      $("#div_tillage").hide()
      $("#div_type").hide()

  $.getJSON url, (tillages) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each tillages, (key, tillage) ->
      switch $("#operation_activity_id").val()
        when "2", "6", "7", "9"
          items.push "<option value=\"" + tillage.id + "\">" + tillage.name + "</option>"
        else
          items.push "<option value=\"" + tillage.code + "\">" + tillage.eqp + "</option>"
    $("#operation_type_id").html items.join("")
    $("#operation_type_id").removeAttr("disabled")

  url1 = "/activities/" + $("#operation_activity_id").val() + ".json"
  $.getJSON url1, (labels) ->
	  $("#div_amount")[0].children[0].innerText = labels.amount_label.split(",")[0] + labels.amount_units
	  $("#div_depth")[0].children[0].innerText = labels.depth_label.split(",")[0] + labels.depth_units

take_efficiency = ->
  if ($("#operation_activity_id").val() == "6")
    switch $("#operation_type_id").val()
       when "1" #Sprinkle
           $("#operation_depth").val(70)
           #$("#bmp_ai_irrigation_efficiency_lable").val("70 - 80%")
       when "2" #Furrow/Flood
           $("#operation_depth").val(65)
           #$("#bmp_ai_irrigation_efficiency_lable").val("50 - 70%")
       when "3" #Drip
           $("#operation_depth").val(85)
           #$("#bmp_ai_irrigation_efficiency_lable").val("80 - 95%")
       when "7" #Furow Diken
           $("#operation_depth").val(90)
           #$("#bmp_ai_irrigation_efficiency_lable").val("80 - 95%")
       when "8" #Tailwater
           $("#operation_depth").val(65)
           #$("#bmp_ai_irrigation_efficiency_lable").val("50 - 70%")

updateFerts = ->
  if ($("#operation_activity_id").val() == "2")
    $("#div_nutrients").hide()
    $("#div_other_nutrients").hide()
    $('div[id="div_other_nutrients"] *').prop('required',false)
    $("#operation_subtype_id").prop('required', true)
    $("#operation_amount").prop('required', true)
    $("#operation_depth").prop('required', true)
    if ($("#operation_type_id").val() == "2" || $("#operation_type_id").val() == "3")
      if $("#operation_type_id").val() == "2"
          $("#div_amount")[0].children[0].innerText = "Application rate(t/ac)"
          $("#div_other_nutrients")[0].children[0].children[0].innerText = "Total N concentration (lbs/t)"
          $("#div_other_nutrients")[0].children[1].children[0].innerText = "Total P concentration (lbs/t)"
      else
          $("#div_amount")[0].children[0].innerText = "Application rate(x1000gal/ac)"
          $("#div_other_nutrients")[0].children[0].children[0].innerText = "Total N concentration (lbs/1000 gallons)"
          $("#div_other_nutrients")[0].children[1].children[0].innerText = "Total P concentration (lbs/1000 gallons)"
      $("#div_other_nutrients").show()
      $('div[id="div_other_nutrients"] *').prop('required',true)
    else
      $("#div_nutrients").show()
      $("#div_amount")[0].children[0].innerText = "Application rate(lbs/ac)"
  url = "/fertilizer_types/" + $("#operation_type_id").val() + "/fertilizers.json"
  $.getJSON url, (fertilizers) ->
    items = []
    items.push "<option value>Select One</option>"
    $.each fertilizers, (key, fertilizer) ->
        items.push "<option value=\"" + fertilizer.id + "\">" + fertilizer.name + "</option>"

    $("#operation_subtype_id").html items.join("")
    $("#operation_subtype_id").removeAttr("disabled")
    $("#operation_moisture").val("")
    $("#operation_no3_n").val("")
    $("#operation_po4_p").val("")
    $("#operation_org_n").val("")
    $("#operation_org_p").val("")
    if ($("#operation_activity_id").val() == "7" || $("#operation_activity_id").val() == "9")
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

update_tillages = ->
  $("#till_title").hide()
  $("#till_list").hide()
  if ($("#cropping_system_id").val() > 0)
     $("#till_title").show()
     $("#till_list").show()

upload_days = (select_day, selected_month) ->
  select_day[0].children[select_day[0].length-3].disabled = false
  select_day[0].children[select_day[0].length-2].disabled = false
  select_day[0].children[select_day[0].length-1].disabled = false

  switch selected_month
    when "4", "6", "9", "11"
      select_day[0].children[select_day[0].length-1].disabled = true
    when "2"
      select_day[0].children[select_day[0].length-3].disabled = true
      select_day[0].children[select_day[0].length-2].disabled = true
      select_day[0].children[select_day[0].length-1].disabled = true

display_hours = (access) ->
  if (access.checked)
    $("#div_hours_in_stream")[0].style.display="inline"
  else
    $("#div_hours_in_stream")[0].style.display='none'

$(document).ready ->
   $("#access_to_stream").click ->
        display_hours(this)
   $("#day1").click ->
        upload_days($("#day1"), $("#month_id1").val())

    $("#bmp_ccr_day").click ->
        upload_days($("#bmp_ccr_day"), $("#bmp_ccr_month").val())

    $("#operation_day").click ->
        upload_days($("#operation_day"), $("#operation_month_id").val())

    $("#btnBack").click ->
        upload_crop(false)

    $("#new_crop").click ->
        upload_crop(true)

    $("#new_ccr").click ->
        upload_crop1(true)

    $("#btn_views").click ->
        switch_view()

    if $("#operation_activity_id").val() == "13"
      $("#div_crops").hide()
      $("#div_cover_crops").show()

    $("#operation_activity_id").change ->
      updateTypes()

    $("#operation_type_id").change ->
      updateFerts()
      updatePlantPopulation()
      take_efficiency()

    $("#operation_subtype_id").change ->
      updateNutrients(0)

    $("#operation_crop_id").change ->
      updatePlantPopulation()

    $("#rowIdOdd").click ->
      updateTitles()

    $("#rowIdEven").click ->
      updateTitles()

    $("#cropping_system_id").change ->
      update_tillages()

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
      $('#plant_title').toggle(!@checked)
      document.getElementById('year').disabled = @checked
      if (@checked)
        r = confirm('Are you sure? When you upload, this will delete all your current operations')
        if r == false
          $("#replace").removeAttr('checked');
          $('#year').toggle(true).removeAttr("disabled")
          $('#year_label').toggle(true)
          $('#plant_title').toggle(true)
      return
