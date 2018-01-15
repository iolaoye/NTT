# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('[id^=faq_').click (event) ->
	    elementIDNum = (this.id).replace(/[^0-9]+/g, "")
	    console.log(elementIDNum)
	    clicked = $('#'+elementIDNum)
	    $.each clicked, (i, elem) ->
	      $(".toggable").not(elem).hide()
	      $(elem).toggle($(elem).css('display') == 'none')
	    $.each $(".icon").not($("#open"+elementIDNum)), (i, elem) ->
	      elem.src = '/assets/expand.png'
	    if (clicked.is(":hidden"))
	      $("#open"+elementIDNum).attr('src', '/assets/expand.png')
	    else
	      $("#open"+elementIDNum).attr('src', '/assets/shrink.png')