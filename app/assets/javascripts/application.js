// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require jquery_ujs
//= require parsley
//= require bootstrap
//= require jparticle.jquery
//= require Chart.bundle
//= require chartkick
//= require custom
//= require wow
//= require slick.min
//= require activestorage
//= require recorder
//= require home
//= require counter
//= require jscolor
//= require clipboard

    

$(document).ready(function(){

  $('.clipboard-btn').tooltip({
    trigger: 'click',
    placement: 'top'
  });

  function setTooltip(btn, message) {
    $(btn).tooltip('show')
      .attr('data-original-title', message)
      .tooltip('show');
  }

  function hideTooltip(btn) {
    setTimeout(function() {
      $(btn).tooltip('hide');
    }, 1000);
  }

  // Clipboard

  var clipboard = new Clipboard('.clipboard-btn');

  clipboard.on('success', function(e) {
    setTooltip(e.trigger, 'Copied!');
    hideTooltip(e.trigger);
  });

  clipboard.on('error', function(e) {
    setTooltip(e.trigger, 'Failed!');
    hideTooltip(e.trigger);
  });

  $('.single-item').slick({
    autoplay: true,
    dots: true,
    vertical: true,
    speed: 3500,
    autoplaySpeed: 4000,
    slidesToShow: 1,
    slidesToScroll: 1,
    verticalSwiping: true,
  });
})