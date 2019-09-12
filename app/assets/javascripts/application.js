// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
// ...
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require chartkick

$('.dropdown-toggle').dropdown()

function rbtnStation_onclick(way) {
    document.getElementById("fsetUploadWeatherFile").style.display = "none";
    document.getElementById("fsetCoordinates").style.display = "none";
    //var indexOf = document.getElementById("lblStation").innerHTML.indexOf("PRISM");
    switch (way) {
        case "Station":
            break;
        case "Prism":
            break;
        case "Own":
            document.getElementById("fsetUploadWeatherFile").style.display = "";
            break;
        case "Coordinates":
            document.getElementById("fsetCoordinates").style.display = "";
            break;
    }
}

function toggle_visibility(id){
    var e = document.getElementById(id);
    if(e.style.display == 'block')
        e.style.display = 'none';
    else
        e.style.display = 'block';

}
