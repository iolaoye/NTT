(function() {
  var updateCounties;

  updateCounties = function() {
    return $.getJSON("/states/" + $("#location_state_id").val() + "/counties.json", function(counties) {
      var items;
      items = [];
      items.push("<option value>Select County</option>");
      $.each(counties, function(key, county) {
        return items.push("<option value=\"" + county.id + "\">" + county.county_name + "</option>");
      });
      $("#location_county_id").html(items.join(""));
      return $("#location_county_id").removeAttr("disabled");
    });
  };

  $(document).ready(function() {
    return $("#location_state_id").change(function() {
      return updateCounties();
    });
  });

}).call(this);
