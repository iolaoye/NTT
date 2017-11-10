(function() {
  var create_soil;

  create_soil = function() {
    return $("#div_new").toggle(true);
  };

  $(document).ready(function() {
    return $("#new_soil").click(function() {
      return create_soil();
    });
  });

}).call(this);
