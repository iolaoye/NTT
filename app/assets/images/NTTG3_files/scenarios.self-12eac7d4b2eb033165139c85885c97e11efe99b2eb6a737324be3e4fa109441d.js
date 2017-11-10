(function() {
  var change_select, copy_from_other_field, create_scenario, loading_screen, select_scenarios;

  create_scenario = function() {
    $("#div_new").toggle(true);
    return $("#div_copy_other").toggle(false);
  };

  change_select = function() {
    var i, tbl_scenarios, _i, _ref, _results;
    tbl_scenarios = $("#tbl_scenarios");
    _results = [];
    for (i = _i = 1, _ref = tbl_scenarios[0].rows.length; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
      _results.push(tbl_scenarios[0].rows[i].cells[0].children[0].checked = tbl_scenarios[0].rows[0].cells[0].children[0].checked);
    }
    return _results;
  };

  copy_from_other_field = function() {
    $("#div_copy_other").toggle(true);
    return $("#div_new").toggle(false);
  };

  loading_screen = function() {
    return $(".overlay").toggle(true);
  };

  select_scenarios = function() {
    var field, items, project_id, query, scenario, url;
    query = window.location.pathname;
    project_id = query.split('/')[query.indexOf("projects") + 1];
    field = $("#field_id").val();
    scenario = "#scenario_id";
    url = "/projects/" + project_id + "/fields/" + field + "/scenarios.json";
    if (field > 0) {
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

  $(document).ready(function() {
    $("#new_scenario").click(function() {
      return create_scenario();
    });
    $("#select_all").click(function() {
      return change_select();
    });
    $("#simulate_scenario").click(function() {
      return loading_screen();
    });
    $("#other_field_scenario").click(function() {
      return copy_from_other_field();
    });
    return $("#field_id").change(function() {
      return select_scenarios();
    });
  });

}).call(this);
