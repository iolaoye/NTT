    $(document).ready(function(){
      //declare validation variables for each BMP
      var validateBmpAi = new Validator("bmpsForm");
      var validateBmpAf = new Validator("bmpsForm");
      var validateBmpTd = new Validator("bmpsForm");
      var validateBmpPpnd = new Validator("bmpsForm");
      var validateBmpPpds = new Validator("bmpsForm");
      var validateBmpPpde = new Validator("bmpsForm");
      var validateBmpPptw = new Validator("bmpsForm");
      var validateBmpWl = new Validator("bmpsForm");
      var validateBmpPnd = new Validator("bmpsForm");
      var validateBmpSf = new Validator("bmpsForm");
      var validateBmpSbs = new Validator("bmpsForm");
      var validateBmpRf = new Validator("bmpsForm");
      var validateBmpFs = new Validator("bmpsForm");
      var validateBmpWw = new Validator("bmpsForm");
      var validateBmpCb = new Validator("bmpsForm");
      var validateBmpLl = new Validator("bmpsForm");
      var validateBmpTs = new Validator("bmpsForm");
      var validateBmpMc = new Validator("bmpsForm");
      var validateBmpCc = new Validator("bmpsForm");
      var validateBmpAc = new Validator("bmpsForm");
      var validateBmpGc = new Validator("bmpsForm");
      var validateBmpSa = new Validator("bmpsForm");
      var validateBmpSdg = new Validator("bmpsForm");
      //show/hide bmps on click-'let' makes 'i' local to loop instead of global
      for(let i = 1; i < 24; i++) {
        //hides all Bmps on page load
        $('#'+i).hide();
        //reveal bmp if checkbox checked
        if ($('#select_'+i).is(':checked')){
          $('#'+i).toggle();
        }
        //gives all BMPs toggle(show/hide) functionality
        $("#bmp"+i).click(function(){
          //$("#"+i).toggle(); //all bmps can be shown
          //shows clicked bmp and hides the others
          var $this = $("#"+i);
          $(".toggable").not($this).hide();
          $this.toggle();
        });
        //checking box will open/show BMP, unchecking hides & clears BMP info.
        $('#select_'+i).change(function () {
          if (!this.checked) { //unchecked
            $("tbody#"+i).hide();
            $("tbody#"+i + " input").each(function() {
              this.value="";
              $("tbody#"+i + " input").not(this).attr('checked', false);
              $("tbody#"+i + " select").val([]);
            });
            //removes validations when checkbox unchecked
            if (i == 1) {
              validateBmpAi.clearAllValidations();
            } else if (i == 2) {
                validateBmpAf.clearAllValidations();
            } else if (i == 3) {
                validateBmpTd.clearAllValidations();
            } else if (i == 4) {
                validateBmpPpnd.clearAllValidations();
            } else if (i == 5) {
                validateBmpPpds.clearAllValidations();
            } else if (i == 6) {
                validateBmpPpde.clearAllValidations();
            } else if (i == 7) {
                validateBmpPptw.clearAllValidations();
            } else if (i == 8) {
                validateBmpWl.clearAllValidations();
            } else if (i == 9) {
                validateBmpPnd.clearAllValidations();
            } else if (i == 10) {
                validateBmpSf.clearAllValidations();
            } else if (i == 11) {
                validateBmpSbs.clearAllValidations();
            } else if (i == 12) {
                validateBmpRf.clearAllValidations();
            } else if (i == 13) {
                validateBmpFs.clearAllValidations();
            } else if (i == 14) {
                validateBmpWw.clearAllValidations();
            } else if (i == 15) {
                validateBmpCb.clearAllValidations();
                validationsBmpCb();
            } else if (i == 16) {
                validateBmpLl.clearAllValidations();
            } else if (i == 17) {
                validateBmpTs.clearAllValidations();
            } else if (i == 18) {
                validateBmpMc.clearAllValidations();
            } else if (i == 19) {
                validateBmpCc.clearAllValidations();
            } else if (i == 20) {
                validateBmpAc.clearAllValidations();
            } else if (i == 21) {
                validateBmpGc.clearAllValidations();
            } else if (i == 22) {
                validateBmpSa.clearAllValidations();
            } else if (i == 23) {
                validateBmpSdg.clearAllValidations();
            }
          } else { //checkbox checked
            $("tbody#"+i).show();
            //add validations for inputs when checkbox checked
            if (i == 1) {
              validationsBmpAi();
            } else if (i == 2) {
                validationsBmpAf();
            } else if (i == 3) {
                validationsBmpTd();
            } else if (i == 4) {
                validationsBmpPpnd();
            } else if (i == 5) {
                validationsBmpPpds();
            } else if (i == 6) {
                validationsBmpPpde();
            } else if (i == 7) {
                validationsBmpPptw();
            } else if (i == 8) {
                validationsBmpWl();
            } else if (i == 9) {
                validationsBmpPnd();
            } else if (i == 10) {
                validationsBmpSf();
            } else if (i == 11) {
                validationsBmpSbs();
            } else if (i == 12) {
                validationsBmpRf();
            } else if (i == 13) {
                validationsBmpFs();
            } else if (i == 14) {
                validationsBmpWw();
            } else if (i == 15) {
                validationsBmpCb();
            } else if (i == 16) {
                validationsBmpLl();
            } else if (i == 17) {
                validationsBmpTs();
            } else if (i == 18) {
                validationsBmpMc();
            } else if (i == 19) {
                validationsBmpCc();
            } else if (i == 20) {
                validationsBmpAc();
            } else if (i == 21) {
                validationsBmpGc();
            } else if (i == 22) {
                validationsBmpSa();
            } else if (i == 23) {
                validationsBmpSdg();
            }
            if (i == 1 && $('#select_2').is(':checked')) {
              if (prompt_user()) {
                validationsBmpAi(0);
              } else { confirm_check(i); }
            } else if (i == 2 && $('#select_1').is(':checked')) { //unused functionality as checkbox 2 does not appear
                if (prompt_user()) {
                  validationsBmpAf(0);
                } else { confirm_check(i); }
            } else if (i > 3 && i < 8) {
                if (i == 4 && ($('#select_5').is(':checked') || $('#select_6').is(':checked') || $('#select_7').is(':checked'))) {
                  if (prompt_user()) {
                    validationsBmpPpnd(0);
                  } else { confirm_check(i); }
                } else if (i == 5 && ($('#select_4').is(':checked') || $('#select_6').is(':checked') || $('#select_7').is(':checked'))) {
                    if (prompt_user()) {
                      validationsBmpPpds(0);
                    } else { confirm_check(i); }
                } else if (i == 6 && ($('#select_4').is(':checked') || $('#select_5').is(':checked') || $('#select_7').is(':checked'))) {
                    if (prompt_user()) {
                      validationsBmpPpde(0);
                    } else { confirm_check(i); }
                } else if (i == 7 && ($('#select_4').is(':checked') || $('#select_5').is(':checked') || $('#select_6').is(':checked'))) {
                    if (prompt_user()) {
                      validationsBmpPptw(0);
                    } else { confirm_check(i); }
                }
            } else if (i > 11 && i < 16) {
                if (i == 12 && ($('#select_13').is(':checked') || $('#select_14').is(':checked') || $('#select_15').is(':checked'))) {
                  if (prompt_user()) {
                    validationsBmpRf(0);
                  } else { confirm_check(i); }
                } else if (i == 13 && ($('#select_12').is(':checked') || $('#select_14').is(':checked') || $('#select_15').is(':checked'))) {
                    if (prompt_user()) {
                      validationsBmpFs(0);
                  } else { confirm_check(i); }
                } else if (i == 14 && ($('#select_12').is(':checked') || $('#select_13').is(':checked') || $('#select_15').is(':checked'))) {
                    if (prompt_user()) {
                      validationsBmpWw(0);
                    } else { confirm_check(i); }
                } else if (i == 15 && ($('#select_12').is(':checked') || $('#select_13').is(':checked') || $('#select_14').is(':checked'))) {
                    if (prompt_user()) {
                      validationsBmpCb(0);
                    } else { confirm_check(i); }
                }
            }
          }
        });
      }
      function prompt_user() {
        var r = confirm("It appears you have a similar BMP already checked. Continuing will clear any input you may have had for the other BMP.");
        if (r == true) {
          return true;
        } else {
            return false;
        }
      }
      function confirm_check(i) {
        $('#select_'+i).prop('checked', false);
        $('#'+i).hide();
      }
      //hide reservoir field if irrigation != pads & pipes
      $('#bmp_ai_irrigation_id').change(function(){
        var tableValue = $('#bmp_ai_irrigation_id').val();
        if (tableValue == 8)
          $('#reservoir_area').show();
        else
          $('#reservoir_area').hide();
      });
      function validationsBmpAi(i) {
        var ai_inputs = $('[name^=bmp_ai]').valueOf();
        if(i == 0) {
          validateBmpAf.clearAllValidations();
          $("#select_2").prop('checked', false);
          $("tbody#2 input").val("");
          $("tbody#2 select").val([]);
        }
        $('#bmp_ai_irrigation_id').change(function(){
          if ($('#bmp_ai_irrigation_id').val() == 8) {
            validateBmpAi.addValidation(ai_inputs[5].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.auto.header") %>');
          }
        });
        for(n = 0; n < ai_inputs.length - 1; n++) {
            validateBmpAi.addValidation(ai_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.auto.header") %>');
        }
        validateBmpAi.addValidation("bmp_cb1", "selone", "A selection is required.");
        validateBmpAi.addValidation(ai_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.irrigation_frequency") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAi.addValidation(ai_inputs[1].name, "lte=365", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.irrigation_frequency") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 365");
        validateBmpAi.addValidation(ai_inputs[2].name, "gt=0", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.water_stress_factor") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAi.addValidation(ai_inputs[2].name, "lte=100", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.water_stress_factor") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
        validateBmpAi.addValidation(ai_inputs[3].name, "gt=0", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.irrigation_efficiency") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAi.addValidation(ai_inputs[3].name, "lte=100", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.irrigation_efficiency") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
        validateBmpAi.addValidation(ai_inputs[4].name, "gt=0", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.max_single_application") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAi.addValidation(ai_inputs[4].name, "lte=99999.00", '<%= t("managepage.bmpdesc.auto.header") %>' + " " + '<%= t("pdf.max_single_application") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
      }
      function validationsBmpAf(i) { //unused/unreferenced function - remove?
        if (($('#select_7').is(':checked'))) {
          if(promptMsg("Tailwater Irrigation is currently checked and requires Autoirrigation to be checked. " +
                       "Continuing will clear any data you may have for Tailwater Irrigation and Autoirrigation.")){
            validateBmpAi.clearAllValidations();
            validateBmpPptw.clearAllValidations();
            $("#select_1").prop('checked', false);
            $("#select_7").prop('checked', false);
            $("tbody#1 input").val("");
            $("tbody#1 select").val([]);
            $("tbody#7 input").val("");
          } else {
            confirm_check(2);
          }
        }
        var af_inputs = $('[name^=bmp_af]').valueOf();
        if(i == 0) {
          validateBmpAi.clearAllValidations();
          $("#select_1").prop('checked', false);
          $("tbody#1 input").val("");
          $("tbody#1 select").val([]);
        }
        for(n = 0; n < af_inputs.length; n++) {
          validateBmpAf.addValidation(af_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.auto.header") %>');
        }
        validateBmpAf.addValidation(af_inputs[1].name, "gt=0", '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAf.addValidation(af_inputs[1].name, "lte=1.00", '<%= t("validate.input_lssequal") %>' + " 1.00");
        validateBmpAf.addValidation(af_inputs[2].name, "gt=0", '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAf.addValidation(af_inputs[2].name, "lte=1.00", '<%= t("validate.input_lessequal") %>' + " 1.00");
        validateBmpAf.addValidation(af_inputs[3].name, "gt=0", '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAf.addValidation(af_inputs[3].name, "lte=365", '<%= t("validate.input_lessequal") %>' + " 365");
        validateBmpAf.addValidation(af_inputs[4].name, "gt=0", '<%= t("validate.input_greater") %>' + " 0");
        validateBmpAf.addValidation(af_inputs[4].name, "lte=99999.00", '<%= t("validate.input_lessequal") %>' + " 99999.00");
      }
      function validationsBmpTd() {
        var td_inputs = $('[name^=bmp_td]').valueOf();
        validateBmpTd.addValidation(td_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.tile.header") %>');
        validateBmpTd.addValidation(td_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.tile.header") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpTd.addValidation(td_inputs[0].name, "lte=99999.00", '<%= t("managepage.bmpdesc.drainsystem.tile.header") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
      }
      function validationsBmpPpnd(i) {
        var ppnd_inputs = $('[name^=bmp_ppnd]').valueOf();
        $('input[type=radio][name=bmp_cb2]').change(function() {
          validateBmpPpnd.clearAllValidations();
          if (this.value == '7') {
            if (promptMsg("This BMP requires the addition of Autoirrigation. Continuing will add Autoirrigation.")) {
              validationsBmpAi(0);
              $('#select_1').prop('checked', true);
              $('input[type=radio][id=bmp_cb1_1]').prop("checked", true);
              $('#1').show();
              validateBmpPpnd.addValidation(ppnd_inputs[2].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>');
              validateBmpPpnd.addValidation(ppnd_inputs[2].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
              validateBmpPpnd.addValidation(ppnd_inputs[2].name, "lte=99999", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
            } else {
              $('input[type=radio][id=bmp_cb2_7]').prop("checked", false);
            }
          } else if (this.value == '6') {
              validateBmpPpnd.addValidation(ppnd_inputs[2].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>');
              validateBmpPpnd.addValidation(ppnd_inputs[2].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
              validateBmpPpnd.addValidation(ppnd_inputs[2].name, "lte=99999", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
          }
        });
        validateBmpPpnd.addValidation("bmp_cb2", "selone", "A selection is required.");
        validateBmpPpnd.addValidation(ppnd_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.ppnoditch.header") %>');
        validateBmpPpnd.addValidation(ppnd_inputs[1].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.ppnoditch.header") %>');
        validateBmpPpnd.addValidation(ppnd_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.ppnoditch.header") %>' +  " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpnd.addValidation(ppnd_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.ppnoditch.header") %>' +  " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpnd.addValidation(ppnd_inputs[1].name, "lte=4", '<%= t("managepage.bmpdesc.drainsystem.ppnoditch.header") %>' +  " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 4");
        if(i == 0) {
          validateBmpPpds.clearAllValidations();
          validateBmpPpde.clearAllValidations();
          validateBmpPptw.clearAllValidations();
          $("#select_5, #select_6, #select_7").prop('checked', false);
          $("tbody#5 input, tbody#6 input, tbody#7 input").val("");
        }
      }
      function validationsBmpPpds(i) {
        var ppds_inputs = $('[name^=bmp_ppds]').valueOf();
        if (i == 0) {
          validateBmpPpnd.clearAllValidations();
          validateBmpPpde.clearAllValidations();
          validateBmpPptw.clearAllValidations();
          $("#select_4, #select_6, #select_7").prop('checked', false);
          $("tbody#4 input, tbody#6 input, tbody#7 input").val("");
        }
        validateBmpPpds.addValidation(ppds_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.pp2stage.header") %>');
        validateBmpPpds.addValidation(ppds_inputs[1].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.pp2stage.header") %>');
        validateBmpPpds.addValidation(ppds_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.pp2stage.header") %>' + " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpds.addValidation(ppds_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.pp2stage.header") %>' + " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpds.addValidation(ppds_inputs[1].name, "lte=4.00", '<%= t("managepage.bmpdesc.drainsystem.pp2stage.header") %>' + " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 4");
      }
      function validationsBmpPpde(i) {
        var ppde_inputs = $('[name^=bmp_ppde]').valueOf();
        if (i == 0) {
          validateBmpPpnd.clearAllValidations();
          validateBmpPpds.clearAllValidations();
          validateBmpPptw.clearAllValidations();
          $("#select_4, #select_5, #select_7").prop('checked', false);
          $("tbody#4 input, tbody#5 input, tbody#7 input").val("");
        }
        validateBmpPpde.addValidation(ppde_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>');
        validateBmpPpde.addValidation(ppde_inputs[1].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>');
        validateBmpPpde.addValidation(ppde_inputs[2].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>');
        validateBmpPpde.addValidation(ppde_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpde.addValidation(ppde_inputs[2].name, "lte=99999", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
        validateBmpPpde.addValidation(ppde_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpde.addValidation(ppde_inputs[2].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPpde.addValidation(ppde_inputs[2].name, "lte=4", '<%= t("managepage.bmpdesc.drainsystem.ppreservoir.header") %>' + " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 4");
      }
      function validationsBmpPptw(i) {
        var pptw_inputs = $('[name^=bmp_pptw]').valueOf();
        if (i == 0) {
          validateBmpPpnd.clearAllValidations();
          validateBmpPpds.clearAllValidations();
          validateBmpPpde.clearAllValidations();
          $("#select_4, #select_5, #select_6").prop('checked', false);
          $("tbody#4 input, tbody#5 input, tbody#6 input").val("");
        }
        if (promptMsg("This BMP requires Autoirrigation. Continuing will clear any data you may have entered in Autofertigation.")) {
          validationsBmpAi(0);
          $('#select_1').prop('checked', true);
          $('#1').show();
          validateBmpPptw.addValidation(pptw_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>');
          validateBmpPptw.addValidation(pptw_inputs[1].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>');
          validateBmpPptw.addValidation(pptw_inputs[2].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>');
          validateBmpPptw.addValidation(pptw_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpPptw.addValidation(pptw_inputs[0].name, "lte=99999", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.reservoir_area") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
          validateBmpPptw.addValidation(pptw_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpPptw.addValidation(pptw_inputs[2].name, "gt=0", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpPptw.addValidation(pptw_inputs[2].name, "lte=4.00", '<%= t("managepage.bmpdesc.drainsystem.pptailwater.header") %>' + " " + '<%= t("bmp.sides") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 4.00");
        } else {
          confirm_check(7);
        }
      }
      function validationsBmpWl() {
        var wl_inputs = $('[name^=bmp_wl]').valueOf();
        validateBmpWl.addValidation(wl_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.wetponds.wetlands.header") %>');
        validateBmpWl.addValidation(wl_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.wetponds.wetlands.header") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpWl.addValidation(wl_inputs[0].name, "lte=99999.00", '<%= t("managepage.bmpdesc.wetponds.wetlands.header") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
      }
      function validationsBmpPnd() {
        var pnd_inputs = $('[name^=bmp_pnd]').valueOf();
        validateBmpPnd.addValidation(pnd_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.wetponds.ponds.header") %>');
        validateBmpPnd.addValidation(pnd_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.wetponds.ponds.header") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpPnd.addValidation(pnd_inputs[0].name, "lte=1.0", '<%= t("managepage.bmpdesc.wetponds.ponds.header") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1.00");
      }
      function validationsBmpSf() {
        var sf_inputs = $('[name^=bmp_sf]').valueOf();
        if (promptMsg("This BMP requires a Filter Strip. Continuing will clear any data you may have entered for any BMP belonging to the same group as Filter Strip.")) {//check with Oscar for best prompt msg for user
          validationsBmpFs(0);
          $('#select_13').prop('checked', true);
          $('#13').show();
          $('input[type=radio][id=bmp_cb3_13]').prop("checked", true);
          $("#tr_grass_field_portion").hide();
          for(n = 0; n < sf_inputs.length; n++) {
            validateBmpSf.addValidation(sf_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.stream.fencing.header") %>');
          }
          validateBmpSf.addValidation(sf_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.animals") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[0].name, "lte=99999.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.animals") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
          validateBmpSf.addValidation(sf_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.stream_fencing_frequency") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[1].name, "lte=365", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.stream_fencing_frequency") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 365");
          validateBmpSf.addValidation(sf_inputs[2].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.hours") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[2].name, "lte=24.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.hours") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 24");
          validateBmpSf.addValidation(sf_inputs[4].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.dry_manure") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[4].name, "lte=99999.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.dry_manure") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 99999.00");
          validateBmpSf.addValidation(sf_inputs[5].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.no3_n") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[5].name, "lte=1.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.no3_n") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1.0");
          validateBmpSf.addValidation(sf_inputs[6].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.po4_p") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[6].name, "lte=1.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.po4_p") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1.0");
          validateBmpSf.addValidation(sf_inputs[7].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.org_n") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[7].name, "lte=1.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.org_n") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1.0");
          validateBmpSf.addValidation(sf_inputs[8].name, "gt=0", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.org_p") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpSf.addValidation(sf_inputs[8].name, "lte=1.00", '<%= t("managepage.bmpdesc.stream.fencing.header") %>' + " " + '<%= t("bmp.org_p") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1.0");
        } else {
          confirm_check(10);
        }
      }
      function validationsBmpSbs() {
        var sbs_inputs = $('[name^=bmp_sbs]').valueOf();
        validateBmpSbs.addValidation(sbs_inputs[0].name, "selone", '<%= t("pdf.streambank_stabilization") %>' + " " + '<%= t("validate.checkbox") %>');
      }
      function validationsBmpRf(i) {
        var rf_inputs = $('[name^=bmp_rf]').valueOf();
        if (i == 0) {
          validateBmpCb.clearAllValidations();
          validateBmpWw.clearAllValidations();
          validateBmpFs.clearAllValidations();
          $("#select_13, #select_14, #select_15").prop('checked', false);
          $("tbody#13 input, tbody#14 input, tbody#15 input").val("");
          $("tbody#13 select, tbody#14 select, tbody#15 select").val([]);
        }
        for(n = 0; n < rf_inputs.length; n++){
          //validateBmpRf.addValidation(rf_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>');
        }
        validateBmpRf.addValidation(rf_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + '<%= t("pdf.area")%>' + " " + '<%= t("bmp.acres") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpRf.addValidation(rf_inputs[0].name, "lte=100000", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + '<%= t("pdf.area")%>' + " " + '<%= t("bmp.acres") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100000");
        validateBmpRf.addValidation(rf_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpRf.addValidation(rf_inputs[2].name, "gte=0.25", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + " " + '<%= t("pdf.area") %>' + " " + '<%= t("bmp.grass_field_portion") %>' + ": " + '<%= t("validate.input_greaterequal") %>' + " 0.25");
        validateBmpRf.addValidation(rf_inputs[2].name, "lte=0.75", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + " " + '<%= t("pdf.area") %>' + " " + '<%= t("bmp.grass_field_portion") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 0.75");
        validateBmpRf.addValidation(rf_inputs[3].name, "gte=0.25", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + " " + '<%= t("bmp.slope_ratio_label") %>' + ": " + '<%= t("validate.input_greaterequal") %>' + " 0.25");
        validateBmpRf.addValidation(rf_inputs[3].name, "lte=1.00", '<%= t("managepage.bmpdesc.stream.forestbuffer.header") %>' + " " + '<%= t("bmp.slope_ration_label") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1.0");
      }
      function validationsBmpFs(i) {
        var fs_inputs = $('[name^=bmp_fs]').valueOf();
        if (i == 0) {
          validateBmpCb.clearAllValidations();
          validateBmpWw.clearAllValidations();
          //validateBmpRf.clearAllValidations();
          $("#select_12, #select_14, #select_15").prop('checked', false);
          $("tbody#12 input, tbody#14 input, tbody#15 input").val("");
          $("tbody#14 select, tbody#15 select").val([]);
        }

        validateBmpFs.addValidation("bmp_cb3", "selone", "A selection is required.");
        $('input[type=radio][name=bmp_cb3]').change(function() {
          validateBmpFs.clearAllValidations();
            if (this.value == '12') {
              for(n = 0; n < fs_inputs.length; n++){
                if (n != 0)
                  validateBmpFs.addValidation(fs_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpnav.mutualbmp.item4") %>');
              }
              validateBmpFs.addValidation(fs_inputs[3].name, "lte=0.75", '<%= t("managepage.bmpdesc.stream.filterstrip.header") %>' + ' <%= t("bmp.grass_field_portion") %>: ' + '<%= t("validate.input_lessequal") %>' + " 0.75");
              validateBmpFs.addValidation(fs_inputs[3].name, "gte=0.25", '<%= t("managepage.bmpdesc.stream.filterstrip.header") %>' + ' <%= t("bmp.grass_field_portion") %>: ' + '<%= t("validate.input_greaterequal") %>' + " 0.25");
            }
            else if (this.value == '13') {
              for(n = 0; n < fs_inputs.length; n++){
                if (n != 3)
                  validateBmpFs.addValidation(fs_inputs[n].name, "req", '<%= t("validate.required") %> ' + '<%= t("managepage.bmpnav.mutualbmp.item4") %>');
              }
            }
        });
        validateBmpFs.addValidation(fs_inputs[1].name, "gt=0", '<%= t("managepage.bmpnav.mutualbmp.item4") %>' + ' <%= t("pdf.area")%> ' + '<%= t("bmp.acres") %>: ' + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpFs.addValidation(fs_inputs[1].name, "lte=100000", '<%= t("managepage.bmpnav.mutualbmp.item4") %>' + ' <%= t("pdf.area")%> ' + '<%= t("bmp.acres") %>: ' + '<%= t("validate.input_lessequal") %>' + " 100000");
        validateBmpFs.addValidation(fs_inputs[2].name, "gt=0", '<%= t("managepage.bmpnav.mutualbmp.item4") %>' + ' <%= t("bmp.width") %>: ' + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpFs.addValidation(fs_inputs[4].name, "lte=1.00", '<%= t("managepage.bmpnav.mutualbmp.item4") %>' + ' <%= t("bmp.slope_ratio_label") %>: ' + '<%= t("validate.input_lessequal") %>' + " 1.00");
        validateBmpFs.addValidation(fs_inputs[4].name, "gte=0.25", '<%= t("managepage.bmpnav.mutualbmp.item4") %>' + ' <%= t("bmp.slope_ratio_label") %>: ' + '<%= t("validate.input_greaterequal") %>' + " 0.25");
      }
      function validationsBmpWw(i) {
        var ww_inputs = $('[name^=bmp_ww]').valueOf();
        if (i == 0) {
          validateBmpCb.clearAllValidations();
          validateBmpFs.clearAllValidations();
          validateBmpRf.clearAllValidations();
          $("#select_12, #select_13, #select_15").prop('checked', false);
          $("tbody#12 input, tbody#13 input, tbody#15 input").val("");
          $("tbody#13 select, tbody#15 select").val([]);
        }
        for(n = 0; n < ww_inputs.length; n++){
            validateBmpWw.addValidation(ww_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.stream.waterway.header") %>');
        }
        validateBmpWw.addValidation(ww_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.stream.waterway.header") %>' + " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
      }
      function validationsBmpCb(i) {
        var cb_inputs = $('[name^=bmp_cb]').valueOf();
        if (i == 0) {
          validateBmpRf.clearAllValidations();
          validateBmpFs.clearAllValidations();
          validateBmpWw.clearAllValidations();
          $("#select_12, #select_13, #select_14").prop('checked', false);
          $("tbody#12 input, tbody#13 input, tbody#14 input").val("");
          $("tbody#13 select, tbody#14 select").val([]);
        }
        for(n = 0; n < cb_inputs.length; n++){
            validateBmpCb.addValidation(cb_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("managepage.bmpdesc.contour.header") %>');
        }
        validateBmpCb.addValidation(cb_inputs[0].name, "gt=0", '<%= t("managepage.bmpdesc.contour.header") %>' + " " + '<%= t("bmp.buffer_width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpCb.addValidation(cb_inputs[1].name, "gt=0", '<%= t("managepage.bmpdesc.contour.header") %>' + " " + '<%= t("bmp.crop_width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
      }
      function validationsBmpLl() {
        var ll_inputs = $('[name^=bmp_ll]').valueOf();
        validateBmpLl.addValidation(ll_inputs[0].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("pdf.land_leveling") %>');
        validateBmpLl.addValidation(ll_inputs[0].name, "gt=0", '<%= t("pdf.land_leveling") %>' + " " + '<%= t("bmp.slope_reduction") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpLl.addValidation(ll_inputs[0].name, "lte=100.00", '<%= t("pdf.land_leveling") %>' + " " + '<%= t("bmp.slope_reduction") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100.00");
      }
      function validationsBmpTs() {
        var ts_inputs = $('[name^=bmp_ts]').valueOf();
        validateBmpTs.addValidation(ts_inputs[0].name, "selone", '<%= t("managepage.bmpdesc.landgrading.terrace.header")%>' + ": " + '<%= t("validate.checkbox") %>');
      }
      function validationsBmpMc() {
        var mc_inputs = $('[name^=bmp_mc]').valueOf();
        for (n = 0; n < mc_inputs.length; n++) {
          validateBmpMc.addValidation(mc_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("bmp.manure_control") %>');
        }
        validateBmpMc.addValidation(mc_inputs[1].name, "gt=0", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpMc.addValidation(mc_inputs[2].name, "gt=0", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpMc.addValidation(mc_inputs[3].name, "gt=0", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpMc.addValidation(mc_inputs[4].name, "gt=0", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpMc.addValidation(mc_inputs[1].name, "lte=100", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
        validateBmpMc.addValidation(mc_inputs[2].name, "lte=100", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
        validateBmpMc.addValidation(mc_inputs[3].name, "lte=100", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
        validateBmpMc.addValidation(mc_inputs[4].name, "lte=100", '<%= t("bmp.manure_control") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
      }
      function validationsBmpCc() {
        var cc_inputs = $('[name^=bmp_cc]').valueOf();
        for (n = 0; n < cc_inputs.length; n++) {
          validateBmpCc.addValidation(cc_inputs[n].name, "gt=0", '<%= t("pdf.climate") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
          validateBmpCc.addValidation(cc_inputs[n].name, "lte=100", '<%= t("pdf.climate") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100");
        }
      }
      function validationsBmpAc() {
        var ac_inputs = $('[name^=bmp_ac]').valueOf();
        validateBmpAc.addValidation(ac_inputs[0].name, "selone", '<%= t("pdf.asphalt_concrete") %>' + ": " + '<%= t("validate.checkbox") %>');
      }
      function validationsBmpGc() {
        var gc_inputs = $('[name^=bmp_gc]').valueOf();
        validateBmpGc.addValidation(gc_inputs[0].name, "selone", '<%= t("pdf.grass_cover") %>' + ": " + '<%= t("validate.checkbox") %>');
      }
      function validationsBmpSa() {
        var sa_inputs = $('[name^=bmp_sa]').valueOf();
        validateBmpSa.addValidation(sa_inputs[0].name, "selone", '<%= t("pdf.slope_adjustment") %>' +  ": " + '<%= t("validate.checkbox") %>');
      }
      function validationsBmpSdg() {
        var sdg_inputs = $('[name^=bmp_sdg]').valueOf();
        for(n = 0; n < sdg_inputs.length; n++) {
          validateBmpSdg.addValidation(sdg_inputs[n].name, "req", '<%= t("validate.required") %>' + " " + '<%= t("pdf.shading") %>');
        }
        validateBmpSdg.addValidation(sdg_inputs[1].name, "gt=0", '<%= t("pdf.shading") %>' + " " + '<%= t("pdf.area")%>' + " " + '<%= t("bmp.acres") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpSdg.addValidation(sdg_inputs[1].name, "lte=100000", '<%= t("pdf.shading") %>' + " " + '<%= t("pdf.area")%>' + " " + '<%= t("bmp.acres") %>' + ": " + '<%= t("validate.input_lessequal") %>' + " 100000.");
        validateBmpSdg.addValidation(sdg_inputs[2].name, "gt=0", '<%= t("pdf.shading") %>' + " " + '<%= t("bmp.width") %>' + ": " + '<%= t("validate.input_greater") %>' + " 0");
        validateBmpSdg.addValidation(sdg_inputs[3].name, "gte=0.25", '<%= t("pdf.shading") %>' + " " + '<%= t("bmp.slope_ratio_label")%>' + ": " + '<%= t("validate.input_greaterequal") %>' + " 0.25");
        validateBmpSdg.addValidation(sdg_inputs[3].name, "lte=1", '<%= t("pdf.shading") %>' + " " + '<%= t("bmp.slope_ratio_label")%>' + ": " + '<%= t("validate.input_lessequal") %>' + " 1");
      }
      function promptMsg(msg) {
        var r = confirm(msg);
        if (r == true) {
          return true;
        } else {
            return false;
        }
      }
