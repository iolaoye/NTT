# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

change_forage = ->
   switch $("#for_button").val()
       when "1" #% of body weight
           $("#supplement_parameter_for_dmi_cows").prop('min',1.0)
           $("#supplement_parameter_for_dmi_cows").prop('max',3.0)
           $("#supplement_parameter_for_dmi_bulls").prop('min',1.0)
           $("#supplement_parameter_for_dmi_bulls").prop('max',3.5)
           $("#supplement_parameter_for_dmi_heifers").prop('min',1.0)
           $("#supplement_parameter_for_dmi_heifers").prop('max',3.0)
           $("#supplement_parameter_for_dmi_calves").prop('min',1.0)
           $("#supplement_parameter_for_dmi_calves").prop('max',3.0)
           $("#supplement_parameter_for_dmi_rheifers").prop('min',1.0)
           $("#supplement_parameter_for_dmi_rheifers").prop('max',3.0)

       when "2" #absolute quantity
           $("#supplement_parameter_for_dmi_cows").prop('min',15.0)
           $("#supplement_parameter_for_dmi_cows").prop('max',30.0)
           $("#supplement_parameter_for_dmi_bulls").prop('min',15.0)
           $("#supplement_parameter_for_dmi_bulls").prop('max',35.0)
           $("#supplement_parameter_for_dmi_heifers").prop('min',10.0)
           $("#supplement_parameter_for_dmi_heifers").prop('max',25.0)
           $("#supplement_parameter_for_dmi_calves").prop('min',4.0)
           $("#supplement_parameter_for_dmi_calves").prop('max',20.0)
           $("#supplement_parameter_for_dmi_rheifers").prop('min',7.0)
           $("#supplement_parameter_for_dmi_rheifers").prop('max',25.0)

change_supplement = ->
   switch $("#supplement_button").val()
       when "1" #% of body weight
           $("#supplement_parameter_dmi_cows").prop('min',0.1)
           $("#supplement_parameter_dmi_cows").prop('max',1.0)
           $("#supplement_parameter_dmi_bulls").prop('min',0.1)
           $("#supplement_parameter_dmi_bulls").prop('max',1.5)
           $("#supplement_parameter_dmi_heifers").prop('min',0.1)
           $("#supplement_parameter_dmi_heifers").prop('max',1.0)
           $("#supplement_parameter_dmi_calves").prop('min',0.1)
           $("#supplement_parameter_dmi_calves").prop('max',1.0)
           $("#supplement_parameter_dmi_rheifers").prop('min',0.1)
           $("#supplement_parameter_dmi_rheifers").prop('max',1.0)

       when "2" #absolute quantity
           $("#supplement_parameter_dmi_cows").prop('min',0.1)
           $("#supplement_parameter_dmi_cows").prop('max',10.0)
           $("#supplement_parameter_dmi_bulls").prop('min',0.1)
           $("#supplement_parameter_dmi_bulls").prop('max',15.0)
           $("#supplement_parameter_dmi_heifers").prop('min',0.1)
           $("#supplement_parameter_dmi_heifers").prop('max',10.0)
           $("#supplement_parameter_dmi_calves").prop('min',0.1)
           $("#supplement_parameter_dmi_calves").prop('max',5.0)
           $("#supplement_parameter_dmi_rheifers").prop('min',0.1)
           $("#supplement_parameter_dmi_rheifers").prop('max',7.0)


$(document).ready ->
    $("#for_button").change ->
        change_forage()
    $("#supplement_button").change ->
        change_supplement()
