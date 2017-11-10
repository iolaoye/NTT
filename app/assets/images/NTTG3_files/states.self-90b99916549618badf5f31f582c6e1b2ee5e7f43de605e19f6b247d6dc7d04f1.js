(function() {
  $(document).ready(function() {
    $('.ddm input, .dropdown-menu label').click(function(event) {
      return event.stopPropagation();
    });
    return $('.ddm input').change(function(event) {
      var id;
      id = "#state_" + $(this).closest(".ddm").find(".ddm input:checked").context.id;
      return $(id).toggle();
    });
  });

}).call(this);
