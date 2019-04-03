$(document).ready(function(){

  $('body').on('mousedown', '#speech_icon, #search_speech_icon', function(){
    toggleRecording(this)
  })

  $('body').on('mouseup', '#speech_icon, #search_speech_icon', function(){
    toggleRecording(this)
  })
$('[data-toggle="tooltip"]').tooltip()
  // Toggle the side navigation
  $(".sidebarToggle").on('click', function(e) {
    e.preventDefault();
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
  });

  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .sidebar').on('mousewheel DOMMouseScroll wheel', function(e) {
    if ($(window).width() > 768) {
      var e0 = e.originalEvent,
        delta = e0.wheelDelta || -e0.detail;
      this.scrollTop += (delta < 0 ? 1 : -1) * 30;
      e.preventDefault();
    }
  });
  $('.sidebar').height($("#content-wrapper").height() + 25);
  $('iframe').height($("#content-wrapper").height() - 22);
  $('.parsley-validate').parsley();

  $('body').on('click', '#sign_up', function(){
    $(this).closest('.hover-effects-login').removeClass('show-overlay-login');
    $('#login_dropdown').removeClass('show-dropdown');

    $('.hover-effects-signup').addClass('show-overlay-signup');
    $('#signup_dropdown').addClass('show-dropdown');
  });

  $('body').on('click', '#login', function(){
    $(this).closest('.hover-effects-signup').removeClass('show-overlay-signup');
    $('#signup_dropdown').removeClass('show-dropdown');

    $('.hover-effects-login').addClass('show-overlay-login');
    $('#login_dropdown').addClass('show-dropdown');
  });

 
	

  $(function(){
		$(".bg-image").jParticle({
		 background: "linear-gradient(50deg, #3577ff 5%, #181e91 85%)",
			color: "#405ec8"
		});
	});
 
	
	
	$(".navigation-footer").find("a").click(function(e) {
    e.preventDefault();
    var section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top - 100
    }, 1000);
  });
 
	$(".home-navigation").find("a").click(function(e) {
    e.preventDefault();
    var section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top - 100
    }, 1000);
  });

	$(".plans-prices a").click(function(e) {
    e.preventDefault();
    var section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top - 100
    }, 1000);
  });
	
  new WOW().init();	
	
  $(".home-navigation li").click(function () {
    $(".home-navigation li").removeClass("active");
    $(this).addClass("active");   
  });	
 
	$(document).on("mouseout", ".plans-queries", function() {
    $(".active-tile").removeClass("active-tile"); 
  });

  $(".plans-queries").hover(function () {
    $(this).toggleClass("active_hover");
    $('.free-trial-tile').toggleClass("result_hover");
  });
 
  $(window).scroll(function () {
    if ($(this).scrollTop() > 100) {
      $('.scroll-top').fadeIn();
    } else {
      $('.scroll-top').fadeOut();
    }
  });

  $('.scroll-top').click(function () {
    $("html, body").animate({
      scrollTop: 0
    }, 1000);
    return false;
  });

  $('.login-buttons #forgot_password').click(function() {
    if ($(".hover-effects-login .dropdown-menu").hasClass("show-dropdown")) {
      $('.hover-effects-login .dropdown-menu').removeClass('show-dropdown');
    }

    $('#forgot_password_dropdown').addClass('show-dropdown');
  })

  $('.login-buttons #forgot_login_btn').click(function() {
    $('#forgot_password_dropdown').removeClass('show-dropdown');

    $('#login_dropdown').addClass('show-dropdown');
  })

  $('.scroll-top').click(function () {
      $("html, body").animate({
          scrollTop: 0
      }, 1000);
      return false;
  });	

  $('.scroll-home').click(function () {
      $("html, body").animate({
          scrollTop: 0
      }, 1000);
      return false;
  }); 
	
	$('.login-buttons .login-button').click(function () {
		$(this).parent().toggleClass('show-overlay-login');
	  if ($(".hover-effects-signup .dropdown-menu").hasClass("show-dropdown")) {
      $('.hover-effects-signup .dropdown-menu').removeClass('show-dropdown');
    }
	  if ($(".login-hover").hasClass("show-overlay-signup")) {
      $('.login-hover').removeClass('show-overlay-signup');
    }
	  });

	  $('.login-buttons .signup-button').click(function () {
		  $(this).parent().toggleClass('show-overlay-signup');
			if ($(".hover-effects-login .dropdown-menu").hasClass("show-dropdown")) {
        $('.hover-effects-login .dropdown-menu').removeClass('show-dropdown');
      }

		  if ($(".login-hover").hasClass("show-overlay-login")) {
        $('.login-hover').removeClass('show-overlay-login'); 
      }		  
	   });
	    
    $('.login-buttons .buttons').click(function () {
		  $(this).next().children('.dropdown-menu').toggleClass('show-dropdown');	  
	  });
	  
	    
    $('.overlay').click(function () {
		  $('.dropdown-menu').removeClass('show-dropdown');
			$(this).parent().removeClass('show-overlay-login');
			$(this).parent().removeClass('show-overlay-signup');
	  });
	  
	  if ($(window).width() < 1400) {
      $(".home-navigation").find("a").click(function(e) {
        e.preventDefault();
        var section = $(this).attr("href");
        $("html, body").animate({
          scrollTop: $(section).offset().top - 74
        }, 1000);
      });

      $(".plans-prices a").click(function(e) {
        e.preventDefault();
        var section = $(this).attr("href");
        $("html, body").animate({
          scrollTop: $(section).offset().top - 74
        }, 1000);
      });
	  }

    $('body').on('click', '.select-site a', function(){
      $('.select-site a.active').removeClass('active');
      $(this).toggleClass('active');
      $('#site_url').val($(this).attr('data-site-url'))
    })
  // Find the 'count this' class on the page and animate it
  $('.count-this').each(function () {

    // Start the counting from a specified number - in this case, 0!
    $(this).prop('Counter',0).animate({
        Counter: $(this).text()
    }, {
        // Speed of counter in ms, default animation style
        duration: 500,
        // Easing function
        easing: 'swing',
        step: function (now) {
          // Round up the number
            $(this).text(Math.round(now*10)/10);
        }
    });
  });
});




$( window ).resize(function() {
	$(function(){
		$(".bg-image").jParticle({
		   background: "linear-gradient(50deg, #3577ff 5%, #181e91 85%)",
      color: "#405ec8"
		});
	});

});


if ($('#home').length > 0) {
  $(window).scroll(function() {
  var scrollPos = $(window).scrollTop();
  var page1Top = $("#home").offset().top;
  var page2Top = $("#about").offset().top;
  var page3Top = $("#features").offset().top - 150;
  var page4Top = $("#pricing").offset().top - 150;
  var page5Top = $("#contact").offset().top - 170;

  if (scrollPos >= page1Top && scrollPos < page2Top) {
    $("#link_1").addClass("active");
    $("#link_2").removeClass("active");
    $("#link_3").removeClass("active");
    $("#link_4").removeClass("active");
    $("#link_5").removeClass("active");
  } else {
    $("#link_1").removeClass("active");
  }

  if (scrollPos >= page2Top && scrollPos < page3Top) {
    $("#link_2").addClass("active");
    $("#link_1").removeClass("active");
    $("#link_3").removeClass("active");
  } else {
    $("#link_2").removeClass("active");
  }
    
  if (scrollPos >= page3Top) {
    $("#link_3").addClass("active");
    $("#link_1").removeClass("active");
    $("#link_2").removeClass("active");
  } else {
    $("#link_3").removeClass("active");
  }
  
  if (scrollPos >= page4Top) {
    $("#link_4").addClass("active");
    $("#link_1").removeClass("active");
    $("#link_2").removeClass("active");
    $("#link_3").removeClass("active");
  } else {
    $("#link_4").removeClass("active");
  }

  if (scrollPos >= page5Top) {
    $("#link_5").addClass("active");
    $("#link_1").removeClass("active");
    $("#link_2").removeClass("active");
    $("#link_4").removeClass("active");
  } else {
    $("#link_5").removeClass("active");
  }
});
}

function myFunction(x) {
  x.classList.toggle("change");
}
 



