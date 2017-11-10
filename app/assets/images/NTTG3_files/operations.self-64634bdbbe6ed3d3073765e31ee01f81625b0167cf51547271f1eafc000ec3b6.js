(function() {
  var getGrazingFields, switch_view, updateAnimals, updateFerts, updateNutrients, updatePlantPopulation, updateTitles, updateTypes, upload_crop, upload_crop1;

  switch_view = function() {
    if ($("#div_crop_schdule").is(":hidden")) {
      $("#div_crop_schdule").toggle(true);
      $("#btn_views").html("Summary View");
    } else {
      $("#div_crop_schdule").toggle(false);
    }
    if ($("#div_operations").is(":hidden")) {
      $("#div_operations").toggle(true);
      return $("#btn_views").html("Crop View");
    } else {
      return $("#div_operations").toggle(false);
    }
  };

  upload_crop = function(show) {
    $("#div_new").toggle(show);
    $("#div_ccr").toggle(false);
    return $("#year").val($("#year").val()(+"1"));
  };

  upload_crop1 = function(show) {
    $("#div_ccr").toggle(show);
    $("#div_new").toggle(false);
    return $("#year").val($("#year").val()(+"1"));
  };

  updatePlantPopulation = function() {
    var url;
    if ($("#operation_activity_id").val() === "1") {
      url = "/crops/" + $("#operation_crop_id").val() + ".json";
    }
    return $.getJSON(url, function(crop) {
      return $("#operation_amount").val(crop.plant_population_ft);
    });
  };

  updateNutrients = function(animal) {
    var url;
    if ($("#operation_activity_id").val() === "2") {
      if ($("#operation_type_id").val() === "2") {
        $("#div_amount")[0].children[0].innerText = "Application rate(T/ac)";
        if ($("#operation_subtype_id").val() === "57") {
          $("#div_amount")[0].children[0].innerText = "Application rate(x1000gal/ac)";
          $("#operation_org_c").val(10);
        } else {
          $("#div_amount")[0].children[0].innerText = "Application rate(T/ac)";
          $("#operation_org_c").val(25);
        }
      } else {
        $("#div_amount")[0].children[0].innerText = "Application rate(lbs/ac)";
        $("#operation_org_c").val(0);
      }
    }
    if (animal === 0) {
      url = "/fertilizers/" + $("#operation_subtype_id").val() + ".json";
    } else {
      url = "/fertilizers/" + $("#operation_type_id").val() + ".json";
    }
    return $.getJSON(url, function(fertilizer) {
      $("#operation_moisture").val(100.0 - fertilizer.dry_matter);
      $("#operation_no3_n").val(fertilizer.qn);
      $("#operation_po4_p").val(fertilizer.qp);
      $("#operation_org_n").val(fertilizer.yn);
      $("#operation_org_p").val(fertilizer.yp);
      return $("#operation_nh3").val(fertilizer.nh3);
    });
  };

  getGrazingFields = function() {
    var url;
    url = "/fertilizers.json?id=animal";
    $("#div_fertilizer").hide();
    $("#div_amount").show();
    $("#div_depth").show();
    $("#div_tillage").show();
    $("#div_nutrients").show();
    $("#div_type").show();
    $("#div_date").show();
    $("#year1").prop('required', true);
    $("#month_id1").prop('required', true);
    $("#day1").prop('required', true);
    $("#operation_type_id").prop('required', true);
    $("#operation_moisture").removeAttr('required');
    $('div[style*="display: none"] *').removeAttr('required');
    $("#div_start_date")[0].children[0].innerText = "Start Year";
    return $("#div_type")[0].children[0].innerText = "Animal Type";
  };

  updateTypes = function() {
    var url, url1;
    $("#div_amount").hide();
    $("#div_depth").hide();
    $("#div_nutrients").hide();
    $("#div_moisture").hide();
    $("#div_type").hide();
    $("#div_tillage").hide();
    $("#div_date").hide();
    $("#div_grazed").hide();
    $("#div_resttime").hide();
    $("#div_cover_crops").hide();
    $("#div_crops").show();
    $("#operation_year").val('');
    $("#operation_month_id").val('');
    $("#operation_day").val('');
    $("#operation_crop_id").prop('required', true);
    $('div[id="div_other_nutrients"] *').prop('required', false);
    $("#div_other_nutrients").hide();
    switch ($("#operation_activity_id").val()) {
      case "1":
      case "13":
        updatePlantPopulation();
        url = "/activities/1/tillages.json";
        $("#div_fertilizer").hide();
        if ($("#operation_activity_id").val() === "13") {
          $("#div_amount").hide();
          $("#div_crops").hide();
          $("#div_cover_crops").show();
          if ($("#cc_year").val() !== void 0) {
            $("#operation_year").val($("#cc_year").val() - 2000);
            $("#operation_month_id").val($("#cc_month").val());
            $("#operation_day").val($("#cc_day").val());
          }
          $("#div_crops").children[0];
          $("#operation_cover_crop_id").prop('required', true);
          $("#operation_crop_id").prop('required', false);
        } else {
          $("#div_amount").show();
        }
        $("#div_tillage").show();
        $("#div_type").show();
        $("#operation_type_id").prop('required', true);
        $("#div_type")[0].children[0].innerText = "Planting Method";
        break;
      case "2":
        url = "/fertilizer_types.json";
        $("#div_fertilizer").show();
        $("#div_amount").show();
        $("#div_depth").show();
        $("#div_tillage").show();
        $("#div_type").show();
        $("#operation_type_id").prop('required', true);
        $("#operation_subtype_id").prop('disabled', true);
        $("#div_type")[0].children[0].innerText = "Fertilizer Type";
        break;
      case "3":
        url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json";
        $("#div_fertilizer").hide();
        $("#div_tillage").show();
        $("#div_type").show();
        $("#operation_type_id").prop('required', true);
        $("#div_type")[0].children[0].innerText = "Tillage Method";
        break;
      case "6":
        url = "/irrigations.json";
        $("#div_fertilizer").hide();
        $("#div_amount").show();
        $("#div_depth").show();
        $("#div_tillage").show();
        $("#div_type").show();
        $("#operation_type_id").prop('required', true);
        $("#div_type")[0].children[0].innerText = "Irrigation Method";
        break;
      case "7":
        url = "/fertilizers.json?id=animal";
        getGrazingFields();
        break;
      case "9":
        url = "/fertilizers.json?id=animal";
        getGrazingFields();
        $("#div_grazed").show();
        $("#div_resttime").show();
        break;
      case "12":
        $("#div_fertilizer").hide();
        $("#div_amount").show();
        $("#div_type").hide();
        break;
      default:
        url = "/activities/" + $("#operation_activity_id").val() + "/tillages.json";
        $('div[style*="display: none"] *').removeAttr('required');
        $("#div_fertilizer").hide();
        $("#div_tillage").hide();
        $("#div_type").hide();
    }
    $.getJSON(url, function(tillages) {
      var items;
      items = [];
      items.push("<option value>Select One</option>");
      $.each(tillages, function(key, tillage) {
        switch ($("#operation_activity_id").val()) {
          case "2":
          case "6":
          case "7":
          case "9":
            return items.push("<option value=\"" + tillage.id + "\">" + tillage.name + "</option>");
          default:
            return items.push("<option value=\"" + tillage.code + "\">" + tillage.eqp + "</option>");
        }
      });
      $("#operation_type_id").html(items.join(""));
      return $("#operation_type_id").removeAttr("disabled");
    });
    url1 = "/activities/" + $("#operation_activity_id").val() + ".json";
    return $.getJSON(url1, function(labels) {
      $("#div_amount")[0].children[0].innerText = labels.amount_label.split(",")[0] + labels.amount_units;
      return $("#div_depth")[0].children[0].innerText = labels.depth_label.split(",")[0] + labels.depth_units;
    });
  };

  updateFerts = function() {
    var url;
    $("#div_nutrients").hide();
    $("#div_other_nutrients").hide();
    $('div[id="div_other_nutrients"] *').prop('required', false);
    if ($("#operation_activity_id").val() === "2") {
      if ($("#operation_type_id").val() === "2" || $("#operation_type_id").val() === "3") {
        $("#div_amount")[0].children[0].innerText = "Application rate(T/ac)";
        $("#div_other_nutrients").show();
        $('div[id="div_other_nutrients"] *').prop('required', true);
      } else {
        $("#div_nutrients").show();
        $("#div_amount")[0].children[0].innerText = "Application rate(lbs/ac)";
      }
    }
    url = "/fertilizer_types/" + $("#operation_type_id").val() + "/fertilizers.json";
    return $.getJSON(url, function(fertilizers) {
      var items;
      items = [];
      items.push("<option value>Select One</option>");
      $.each(fertilizers, function(key, fertilizer) {
        return items.push("<option value=\"" + fertilizer.id + "\">" + fertilizer.name + "</option>");
      });
      $("#operation_subtype_id").html(items.join(""));
      $("#operation_subtype_id").removeAttr("disabled");
      $("#operation_moisture").val("");
      $("#operation_no3_n").val("");
      $("#operation_po4_p").val("");
      $("#operation_org_n").val("");
      $("#operation_org_p").val("");
      if ($("#operation_activity_id").val() === "7" || $("#operation_activity_id").val() === "9") {
        return updateNutrients(1);
      }
    });
  };

  updateAnimals = function() {
    var url;
    url = "/fertilizer_types/" + $("#operation_type_id").val() + "/fertilizers.json";
    return $.getJSON(url, function(fertilizers) {
      var items;
      items = [];
      items.push("<option value>Select One</option>");
      $.each(fertilizers, function(key, fertilizer) {
        return items.push("<option value=\"" + fertilizer.id + "\">" + fertilizer.name + "</option>");
      });
      $("#operation_subtype_id").html(items.join(""));
      return $("#operation_subtype_id").removeAttr("disabled");
    });
  };

  updateTitles = function() {
    var title;
    title = t('operations.fertilizer');
    return $("#typeTitle").text(title);
  };

  $(document).ready(function() {
    $("#btnBack").click(function() {
      return upload_crop(false);
    });
    $("#new_crop").click(function() {
      return upload_crop(true);
    });
    $("#new_ccr").click(function() {
      return upload_crop1(true);
    });
    $("#btn_views").click(function() {
      return switch_view();
    });
    if ($("#operation_activity_id").val() === "13") {
      $("#div_crops").hide();
      $("#div_cover_crops").show();
    }
    $("#operation_activity_id").change(function() {
      return updateTypes();
    });
    $("#operation_type_id").change(function() {
      return updateFerts();
    });
    $("#operation_subtype_id").change(function() {
      return updateNutrients(0);
    });
    $("#operation_crop_id").change(function() {
      return updatePlantPopulation();
    });
    $("#rowIdOdd").click(function() {
      return updateTitles();
    });
    $("#rowIdEven").click(function() {
      return updateTitles();
    });
    $("#add").click(function() {
      var a, button, cell, crop_schedule, tbl, year;
      crop_schedule = document.getElementById('cropping_system_id');
      $('#tblCrops').append($("<tr>"));
      $('#tblCrops tr').append($("<td>"));
      tbl = $('#tblCrops');
      tbl[0].rows[tbl[0].rows.length - 1].cells[0].innerText = crop_schedule[crop_schedule.selectedIndex].text;
      year = +$('#year').val();
      $('#tblCrops tr').append($("<td>"));
      tbl = $('#tblCrops');
      tbl[0].rows[tbl[0].rows.length - 1].cells[1].innerText = $('#year').val();
      year = year + 1;
      $('#year').val(year);
      $('#tblCrops tr').append($("<td>"));
      tbl = $('#tblCrops');
      button = document.createElement("button_tag");
      button.innerHTML = "Remove";
      cell = tbl[0].rows[tbl[0].rows.length - 1].cells[2];
      return a = 1;
    });
    return $('#replace').click(function() {
      var r;
      $('#year').toggle(!this.checked);
      $('#year_label').toggle(!this.checked);
      document.getElementById('year').disabled = this.checked;
      if (this.checked) {
        r = confirm('Are you sure? When you upload, this will delete all your current operations');
        if (r === false) {
          $("#replace").removeAttr('checked');
          $('#year').toggle(true);
          $('#year_label').toggle(true);
        }
      }
    });
  });

}).call(this);
