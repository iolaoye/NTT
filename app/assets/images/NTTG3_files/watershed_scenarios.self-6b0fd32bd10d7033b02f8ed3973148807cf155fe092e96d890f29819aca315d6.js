(function() {
  var select_scenarios;

  select_scenarios = function() {
    var field, items, scenario, url;
    field = "#field_id";
    scenario = "#scenario_id";
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

  $(document).ready(function() {
    return $("#field_id").change(function() {
      return select_scenarios();
    });
  });

}).call(this);
