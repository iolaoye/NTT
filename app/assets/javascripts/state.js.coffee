$(document).ready ->
  $('.ddm input, .dropdown-menu label').click (event) ->
    event.stopPropagation()

  $('.ddm input').change (event) ->
    id = "#state_" + $(this).closest(".ddm").find(".ddm input:checked").context.id
    $(id).toggle()
   
