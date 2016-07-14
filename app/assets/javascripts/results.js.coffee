#	crops = @results1.where("crop_id > 0")
#	crops.each do |crop|
#		description = Description.new
#		description.id = crop.description_id
#		description.description = Crop.find(crop.crop_id).name + " Yield"
#		@descriptions.push(description)
#	end
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

pdf = ->
    $("#pdf_download").click (event) ->
        $("#myForm").submit()


$(document).ready ->
    pdf()
    $("#result1_scenario_id").change ->
        update_crops()

    $("#result2_scenario_id").change ->
        update_crops()

    $("#result3_scenario_id").change ->
        update_crops()
