(function() {
  var activate_bmp_controls, buffers, pads_and_pipes, rb_td, switch_all_labels_off, switch_all_to_off, take_efficiency, update_animal_options, update_bmpsublist, update_fertigation_options, update_irrigation_options, update_manure_control_options, update_max_row, update_min_row, update_pcp_row;

  take_efficiency = function() {
    switch ($("#bmp_ai_irrigation_id").val()) {
      case "1":
        $("#bmp_ai_irrigation_efficiency").val(70);
        return $("#bmp_ai_irrigation_efficiency_lable").val("70 - 80%");
      case "2":
        $("#bmp_ai_irrigation_efficiency").val(65);
        return $("#bmp_ai_irrigation_efficiency_lable").val("50 - 70%");
      case "3":
        $("#bmp_ai_irrigation_efficiency").val(85);
        return $("#bmp_ai_irrigation_efficiency_lable").val("80 - 95%");
      case "7":
        $("#bmp_ai_irrigation_efficiency").val(90);
        return $("#bmp_ai_irrigation_efficiency_lable").val("80 - 95%");
      case "8":
        $("#bmp_ai_irrigation_efficiency").val(65);
        return $("#bmp_ai_irrigation_efficiency_lable").val("50 - 70%");
    }
  };

  update_max_row = function() {
    var top;
    top = $("#climate_max_1").val();
    return $(".max").val(top);
  };

  update_min_row = function() {
    var top;
    top = $("#climate_min_1").val();
    return $(".min").val(top);
  };

  update_pcp_row = function() {
    var top;
    top = $("#climate_pcp_1").val();
    return $(".pcp").val(top);
  };

  update_animal_options = function() {
    var url;
    url = "/fertilizers/" + $("#bmp_sf_animal_id").val() + ".json";
    return $.getJSON(url, function(fertilizer) {
      $("#bmp_sf_dry_manure").val(fertilizer.dry_matter);
      $("#bmp_sf_no3_n").val(fertilizer.qn);
      $("#bmp_sf_po4_p").val(fertilizer.qp);
      $("#bmp_sf_org_n").val(fertilizer.yn);
      return $("#bmp_sf_org_p").val(fertilizer.yp);
    });
  };

  update_manure_control_options = function() {
    var url;
    url = "/manure_controls/" + $("#bmp_mc_animal_id").val() + ".json";
    return $.getJSON(url, function(control) {
      $("#bmp_mc_no3_n").val(control.no3n);
      $("#bmp_mc_po4_p").val(control.po4p);
      $("#bmp_mc_org_n").val(control.orgn);
      return $("#bmp_mc_org_p").val(control.orgp);
    });
  };

  update_bmpsublist = function() {
    var items, url;
    url = "/bmplists/" + $("#bmp_bmp_id").val() + "/bmpsublists.json";
    if ($("#bmp_bmp_id").val() > 0) {
      return $.getJSON(url, function(bmpsublists) {
        var items, language, n;
        url = window.location.href;
        n = url.indexOf('locale=');
        language = url.substring(n, n + 9);
        if (language === "locale=en") {
          items = [];
          items.push("<option value>Select One</option>");
          $.each(bmpsublists, function(key, bmpsublist) {
            return items.push("<option value=\"" + bmpsublist.id + "\">" + bmpsublist.name + "</option>");
          });
          $("#bmp_bmpsublist_id").html(items.join(""));
          return $("#bmp_bmpsublist_id").removeAttr("disabled");
        } else if (language === "locale=es") {
          items = [];
          items.push("<option value>Select One</option>");
          $.each(bmpsublists, function(key, bmpsublist) {
            return items.push("<option value=\"" + bmpsublist.id + "\">" + bmpsublist.spanish_name + "</option>");
          });
          $("#bmp_bmpsublist_id").html(items.join(""));
          return $("#bmp_bmpsublist_id").removeAttr("disabled");
        } else {
          window.alert('WTF Language error. Default English will be set for list Click [OK] to continue.');
          items = [];
          items.push("<option value>Select One</option>");
          $.each(bmpsublists, function(key, bmpsublist) {
            return items.push("<option value=\"" + bmpsublist.id + "\">" + bmpsublist.name + "</option>");
          });
          $("#bmp_bmpsublist_id").html(items.join(""));
          return $("#bmp_bmpsublist_id").removeAttr("disabled");
        }
      });
    } else {
      items = [];
      items.push("<option value>Select One</option>");
      $("#bmp_bmpsublist_id").html(items.join(""));
      return $("#bmp_bmpsublist_id").removeAttr("disabled");
    }
  };

  switch_all_to_off = function() {
    $("#irrigation").toggle(false);
    $("#irrigation1").toggle(false);
    $("#water_stress_factor").toggle(false);
    $("#irrigation_efficiency").toggle(false);
    $("#maximum_single_application").toggle(false);
    $("#safety_factor").toggle(false);
    $('#bmp_crop_id').prop('required', false);
    $('#bmp_animal_id').prop('required', false);
    $('#bmp_irrigation_id').prop('required', false);
    $("#depth").toggle(false);
    $("#width").toggle(false);
    $("#sides").toggle(false);
    $("#area").toggle(false);
    $("#number_of_animals").toggle(false);
    $("#animals").toggle(false);
    $("#days").toggle(false);
    $("#hours").toggle(false);
    $("#dry_manure").toggle(false);
    $("#no3_n").toggle(false);
    $("#po4_p").toggle(false);
    $("#org_n").toggle(false);
    $("#org_p").toggle(false);
    $("#grass_field_portion").toggle(false);
    $("#buffer_slope_upland").toggle(false);
    $("#crop").toggle(false);
    $("#no_input").toggle(false);
    $("#crop_width").toggle(false);
    $("#slow_warning").toggle(false);
    $("#climate_table").toggle(false);
    $("#slope_reduction").toggle(false);
    $("#tr_bmp_pp_area").toggle(false);
    return switch_all_labels_off();
  };

  switch_all_labels_off = function() {
    $("#irrigation_efficiency_label").toggle(false);
    $("#area_control_label").toggle(false);
    $("#depth_ft_label").toggle(false);
    $("#waterways_label").toggle(false);
    $("#width_label").toggle(false);
    $("#contour_buffer_label").toggle(false);
    $("#stream_fencing_label").toggle(false);
    return $("#irrigation_frequency_label").toggle(false);
  };

  activate_bmp_controls = function() {
    switch_all_to_off();
    switch ($("#bmp_bmpsublist_id").val()) {
      case "1":
        $("#irrigation_efficiency_label").toggle(true);
        $('#irrigation').toggle(true);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
      case "2":
        $("#irrigation_efficiency_label").toggle(true);
        $('#irrigation').toggle(true);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
      case "3":
        $("#depth").toggle(true);
        return $("#depth_ft_label").toggle(true);
      case "4":
      case "5":
        $("#width").toggle(true);
        $("#width_label").toggle(true);
        return $("#sides").toggle(true);
      case "6":
      case "7":
        $("#width").toggle(true);
        $("#width_label").toggle(true);
        $("#sides").toggle(true);
        return $("#area").toggle(true);
      case "8":
        return $("#area").toggle(true);
      case "9":
        $("#area_control_label").toggle(true);
        return $("#irrigation_efficiency").toggle(true);
      case "10":
        $("#animals").toggle(true);
        $("#number_of_animals").toggle(true);
        $("#days").toggle(true);
        $("#stream_fencing_label").toggle(true);
        $("#hours").toggle(true);
        $("#dry_manure").toggle(true);
        $("#no3_n").toggle(true);
        $("#po4_p").toggle(true);
        $("#org_n").toggle(true);
        return $("#org_p").toggle(true);
      case "11":
        return $("#no_input").toggle(true);
      case "12":
        $("#area").toggle(true);
        $("#width").toggle(true);
        $("#width_label").toggle(true);
        $("#grass_field_portion").toggle(true);
        return $("#buffer_slope_upland").toggle(true);
      case "13":
        $("#area").toggle(true);
        $("#width").toggle(true);
        $("#width_label").toggle(true);
        $("#crop").toggle(true);
        $("#buffer_slope_upland").toggle(true);
        return $('#bmp_crop_id').prop('required', true);
      case "14":
        $("#width").toggle(true);
        $("#waterways_label").toggle(true);
        return $("#crop").toggle(true);
      case "15":
        $("#width").toggle(true);
        $("#contour_buffer_label").toggle(true);
        $("#crop").toggle(true);
        return $("#crop_width").toggle(true);
      case "16":
        return $("#slope_reduction").toggle(true);
      case "17":
        return $("#no_input").toggle(true);
      case "19":
        $("#climate_table").toggle(true);
        return $("#slow_warning").toggle(true);
      case "20":
        return $("#no_input").toggle(true);
      case "21":
        return $("#no_input").toggle(true);
      case "22":
        return $("#no_input").toggle(true);
      case "23":
        $("#area").toggle(true);
        $("#width").toggle(true);
        $("#width_label").toggle(true);
        $("#crop").toggle(true);
        $("#buffer_slope_upland").toggle(true);
        return $("#bmp_crop_id").prop('required', true);
    }
  };

  update_irrigation_options = function() {
    switch ($("#bmp_irrigation_id").val()) {
      case "7":
        $("#safety_factor").toggle(true);
        $("#area").toggle(false);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
      case "8":
        $("#safety_factor").toggle(false);
        $("#area").toggle(true);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
      default:
        $("#safety_factor").toggle(false);
        $("#area").toggle(false);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
    }
  };

  update_fertigation_options = function() {
    switch ($("#autofertigation").val()) {
      case "7":
        $("#safety_factor").toggle(true);
        $("#area").toggle(false);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
      default:
        $("#safety_factor").toggle(false);
        $("#area").toggle(false);
        $("#water_stress_factor").toggle(true);
        $("#irrigation_efficiency").toggle(true);
        $("#maximum_single_application").toggle(true);
        $("#days").toggle(true);
        return $("#irrigation_frequency_label").toggle(true);
    }
  };

  rb_td = function(opt) {
    $("#div_td_opt1").toggle(false);
    $("#div_td_opt2").toggle(false);
    $("#div_td_opt3").toggle(false);
    $("#div_td_opt4").toggle(false);
    $("#div_td_opt5").toggle(false);
    switch (opt) {
      case 3:
        return $("#div_td_opt1").toggle(true);
      case 4:
        $("#div_td_opt2").toggle(true);
        $("#div_td_opt3").toggle(true);
        $("#div_td_opt4").toggle(true);
        return $("#div_td_opt5").toggle(true);
    }
  };

  pads_and_pipes = function(opt) {
    $("#tr_bmp_pp_area").toggle(false);
    switch (opt) {
      case 6:
        return $("#tr_bmp_pp_area").toggle(true);
      case 7:
        return $("#tr_bmp_pp_area").toggle(true);
    }
  };

  buffers = function(opt) {
    $("#tr_fs_vegetation").toggle(false);
    $("#tr_grass_field_portion").toggle(false);
    switch (opt) {
      case 12:
        return $("#tr_grass_field_portion").toggle(true);
      case 13:
        return $("#tr_fs_vegetation").toggle(true);
    }
  };

  $(document).ready(function() {
    $("#bmp_ai_irrigation_id").change(function() {
      return take_efficiency();
    });
    $("#bmp_bmp_id").change(function() {
      return update_bmpsublist();
    });
    $("#bmp_bmpsublist_id").change(function() {
      return activate_bmp_controls();
    });
    $("#bmp_sf_animal_id").change(function() {
      return update_animal_options();
    });
    $("#bmp_irrigation_id").change(function() {
      return update_irrigation_options();
    });
    $("#autofertigation").change(function() {
      return update_fertigation_options();
    });
    $("#bmp_mc_animal_id").change(function() {
      return update_manure_control_options();
    });
    $("#bmp_td_3").click(function() {
      return rb_td(3);
    });
    $("#bmp_td_4").click(function() {
      return rb_td(4);
    });
    $("#fill_max").click(function() {
      return update_max_row();
    });
    $("#fill_pcp").click(function() {
      return update_pcp_row();
    });
    $("#fill_min").click(function() {
      return update_min_row();
    });
    $("#bmp_cb2_4").click(function() {
      return pads_and_pipes(4);
    });
    $("#bmp_cb2_5").click(function() {
      return pads_and_pipes(5);
    });
    $("#bmp_cb2_6").click(function() {
      return pads_and_pipes(6);
    });
    $("#bmp_cb2_7").click(function() {
      return pads_and_pipes(7);
    });
    $("#bmp_cb3_12").click(function() {
      return buffers(12);
    });
    return $("#bmp_cb3_13").click(function() {
      return buffers(13);
    });
  });

}).call(this);
