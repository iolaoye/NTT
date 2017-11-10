(function() {
  var change_selection, create_watershed, loading_screen, select_scenarios;

  create_watershed = function() {
    return $("#div_new").toggle(true);
  };

  select_scenarios = function(num) {
    var field, items, scenario, url;
    field = "#field" + num + "_id";
    scenario = "#scenario" + num + "_id";
    url = "/projects/" + $("#project_id").val() + "/fields/" + $(field).val() + "/scenarios.json";
    if ($(field).val() > 0) {
      return $.getJSON(url, function(scenarios) {
        var items;
        items = [];
        items.push("<option value>Select Scenarios</option>");
        $.each(scenarios, function(key, scenario) {
          return items.push("<option value=\"" + scenario.id + "\">" + scenario.name + "</option>");
        });
        $(scenario).html(items.join(""));
        return $(scenario).removeAttr("disabled");
      });
    } else {
      items = [];
      items.push("<option value>Select Scenarios</option>");
      $(scenario).html(items.join(""));
      return $(scenario).removeAttr("disabled");
    }
  };

  change_selection = function() {
    var i, tbl_watersheds, _i, _ref, _results;
    tbl_watersheds = $("#tbl_watersheds");
    _results = [];
    for (i = _i = 1, _ref = tbl_watersheds[0].rows.length; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
      _results.push(tbl_watersheds[0].rows[i].cells[0].children[0].checked = tbl_watersheds[0].rows[0].cells[0].children[0].checked);
    }
    return _results;
  };

  loading_screen = function() {
    return $(".overlay").toggle(true);
  };

  $(document).ready(function() {
    $("#select_todo").click(function() {
      return change_selection();
    });
    $("#new_watershed").click(function() {
      return create_watershed();
    });
    $("#field1_id").change(function() {
      return select_scenarios(1);
    });
    $("#field2_id").change(function() {
      return select_scenarios(2);
    });
    $("#field3_id").change(function() {
      return select_scenarios(3);
    });
    $("#field4_id").change(function() {
      return select_scenarios(4);
    });
    $("#field5_id").change(function() {
      return select_scenarios(5);
    });
    $("#field6_id").change(function() {
      return select6_scenarios(6);
    });
    $("#field7_id").change(function() {
      return select_scenarios(7);
    });
    $("#field8_id").change(function() {
      return select_scenarios(8);
    });
    $("#field9_id").change(function() {
      return select_scenarios(9);
    });
    $("#field10_id").change(function() {
      return select_scenarios(10);
    });
    $("#field11_id").change(function() {
      return select_scenarios(11);
    });
    $("#field12_id").change(function() {
      return select_scenarios(12);
    });
    $("#field13_id").change(function() {
      return select_scenarios(13);
    });
    $("#field14_id").change(function() {
      return select_scenarios(14);
    });
    $("#field15_id").change(function() {
      return select_scenarios(15);
    });
    $("#field16_id").change(function() {
      return select_scenarios(16);
    });
    $("#field17_id").change(function() {
      return select_scenarios(17);
    });
    $("#field18_id").change(function() {
      return select_scenarios(18);
    });
    $("#field19_id").change(function() {
      return select_scenarios(19);
    });
    $("#field20_id").change(function() {
      return select_scenarios(20);
    });
    return $("#simulate_watershed").click(function() {
      return loading_screen();
    });
  });

}).call(this);
