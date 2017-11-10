(function() {
  var check_for_errors, display_button, generate_excel, generate_pdf, set_buttons, show_crops, turn_on_off_s, turn_on_off_t, update_crops;

  turn_on_off_s = function(row) {
    var i, row1, _results;
    if (row === 1 || row === 0) {
      if (row === 1) {
        $("#tbl_total").toggle(true);
        $("#tbl_detailed").toggle(false);
      } else {
        $("#tbl_total").toggle(false);
        $("#tbl_detailed").toggle(true);
      }
    }
    i = 1;
    _results = [];
    while (i <= 9) {
      row1 = row + i;
      i += 1;
      if ($("#srow" + row1).is(":hidden")) {
        _results.push($("#srow" + row1).toggle(true));
      } else {
        _results.push($("#srow" + row1).toggle(false));
      }
    }
    return _results;
  };

  turn_on_off_t = function(row) {
    var i, row1, _results;
    i = 1;
    _results = [];
    while (i <= 9) {
      row1 = row + i;
      i += 1;
      if ($("#trow" + row1).is(":hidden")) {
        _results.push($("#trow" + row1).toggle(true));
      } else {
        _results.push($("#trow" + row1).toggle(false));
      }
    }
    return _results;
  };

  show_crops = function() {
    var items, url;
    $("#td_crops").toggle(false);
    if ($("#result5_description_id").val() === "70") {
      $("#td_crops").toggle(true);
      items = [];
      items.push("<option value>Select Crop</option>");
      url = "/results/" + $("#result1_scenario_id").val() + ".json" + "?id2=" + $("#result2_scenario_id").val() + "&id3=" + $("#result3_scenario_id").val();
      return $.getJSON(url, function(crops_list) {
        $.each(crops_list, function(key, crop) {
          return items.push("<option value=\"" + crop.crop_id + "\">" + crop.name + "</option>");
        });
        return $("#result7_crop_id").html(items.join(""));
      });
    }
  };

  update_crops = function() {
    var i, items, url;
    items = [];
    items.push("<option value>Select Kind of Chart</option>");
    if ($("#result1_scenario_id").val() !== "") {
      url = "/descriptions.json";
      $.getJSON(url, function(description_list) {
        return $.each(description_list, function(key, description) {
          if (description.id < 70 || description.id > 79) {
            return items.push("<option value=\"" + description.id + "\">" + description.description + "</option>");
          }
        });
      });
      i = 70;
      url = "/results/" + $("#field_id").val() + "/sel.json?scenario1=" + $("#result1_scenario_id").val() + "&scenario2=" + $("#result2_scenario_id").val() + "&scenario3=" + $("#result2_scenario_id").val();
      return $.getJSON(url, function(result_list) {
        return $.each(result_list, function(key, result) {
          i = i + 1;
          url = "/crops/" + result.crop_id + ".json";
          return $.getJSON(url, function(crop) {
            items.push("<option value=\"" + i + "\">" + crop.name + " Yield </option>");
            return $("#result5_description_id").html(items.join(""));
          });
        });
      });
    } else {
      return $("#result5_description_id").html(items.join(""));
    }
  };

  generate_pdf = function() {
    return $("#pdf_download").click(function(event) {
      return $("#myForm").submit();
    });
  };

  generate_excel = function() {
    return $("#csv_download").click(function(event) {
      return $("#myForm").submit();
    });
  };

  display_button = function() {
    var string, substring;
    string = window.location.href;
    substring = 'results?button';
    if (string.indexOf(substring) > -1) {
      return set_buttons(false);
    } else {
      return set_buttons(true);
    }
  };

  set_buttons = function(view) {
    $("#pdf_download").toggle(view);
    return $("#excel_download").toggle(view);
  };

  check_for_errors = function() {
    var errors, size;
    errors = $("#errors").val() + "";
    size = errors.length;
    if (size > 0) {
      return set_buttons(false);
    }
  };

  $(document).ready(function() {
    show_crops();
    set_buttons(false);
    display_button();
    generate_pdf();
    check_for_errors();
    $("#result1_scenario_id").change(function() {
      return set_buttons(false);
    });
    $("#result2_scenario_id").change(function() {
      return set_buttons(false);
    });
    $("#result5_description_id").change(function() {
      return show_crops();
    });
    $("#result3_scenario_id").change(function() {
      return set_buttons(false);
    });
    $("#summary").click(function(event) {
      return set_buttons(true);
    });
    $("#srow10").click(function() {
      return turn_on_off_s(10);
    });
    $("#srow20").click(function() {
      return turn_on_off_s(20);
    });
    $("#srow30").click(function() {
      return turn_on_off_s(30);
    });
    $("#srow40").click(function() {
      return turn_on_off_s(40);
    });
    $("#srow50").click(function() {
      return turn_on_off_s(50);
    });
    $("#srow60").click(function() {
      return turn_on_off_s(60);
    });
    $("#srow70").click(function() {
      return turn_on_off_s(70);
    });
    $("#srow90").click(function() {
      return turn_on_off_s(90);
    });
    $("#srow200").click(function() {
      return turn_on_off_s(200);
    });
    $("#srow210").click(function() {
      return turn_on_off_s(210);
    });
    $("#srow220").click(function() {
      return turn_on_off_s(220);
    });
    $("#srow230").click(function() {
      return turn_on_off_s(230);
    });
    $("#trow10").click(function() {
      return turn_on_off_t(10);
    });
    $("#trow20").click(function() {
      return turn_on_off_t(20);
    });
    $("#trow30").click(function() {
      return turn_on_off_t(30);
    });
    $("#trow40").click(function() {
      return turn_on_off_t(40);
    });
    $("#trow50").click(function() {
      return turn_on_off_t(50);
    });
    $("#trow60").click(function() {
      return turn_on_off_t(60);
    });
    $("#trow70").click(function() {
      return turn_on_off_t(70);
    });
    $("#trow90").click(function() {
      return turn_on_off_t(90);
    });
    $("#trow200").click(function() {
      return turn_on_off_t(200);
    });
    $("#trow210").click(function() {
      return turn_on_off_t(210);
    });
    $("#trow220").click(function() {
      return turn_on_off_t(220);
    });
    $("#trow230").click(function() {
      return turn_on_off_t(230);
    });
    $("#result_type_acre").click(function() {
      return turn_on_off_s(0);
    });
    return $("#result_type_total").click(function() {
      return turn_on_off_s(1);
    });
  });

}).call(this);
