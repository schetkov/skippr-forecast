// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require spin.js

//= require cloudinary
//= require bootstrap
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js

//= require select2
//= require underscore.min
//= require stickUp
//= require moment.min
//= require accounting.min
//= require react
//= require react_ujs
//= require flux
//= require eventemitter
//= require highcharts
//= require radar/components
//= require react-loader
//

jQuery(function($) {
  $(document).ready( function() {
    $('.radar-graph-itself').stickUp();
  });

  $(window).scroll(function(){
    if($('.radar-graph-itself').hasClass('isStuck')){
      $('#scenarios').addClass('scroll')
    }else{
      $('#scenarios').removeClass('scroll')
    }
  })
});