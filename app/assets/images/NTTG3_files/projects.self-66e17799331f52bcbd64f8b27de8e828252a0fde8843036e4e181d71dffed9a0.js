(function() {
  var create_project;

  create_project = function() {
    return $("#div_new").toggle(true);
  };

  $(document).ready(function() {
    return $("#new_project").click(function() {
      return create_project();
    });
  });

}).call(this);
