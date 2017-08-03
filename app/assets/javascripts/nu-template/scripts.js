var ready;
ready = function() {

	// expandable mobile elements
	var _time = 100; // transition time
	// menu setup
	$('#mobile-nav a').not('.caret').attr({'role':'menuitem'});

	// open search
	$(".mobile-search-link").click(function (e) {
		// close menu
		$("#mobile-nav").slideUp(_time).attr({
			'aria-expanded': 'false',
			'aria-hidden': 'true'
		});
		$(".mobile-nav-link").removeClass('open').children(":first").attr({'aria-label': 'open menu'});
		var el = $("#mobile-search");
		// open search
		if ($(el).is(":hidden")) {
			$(el).slideDown(_time).attr({
				'aria-expanded': 'true',
				'aria-hidden': 'false'
			});
			$(".mobile-search-link").addClass('open').children(":first").attr({'aria-label': 'close search'});
		// close search
		} else {
			$(el).slideUp(_time).attr({
				'aria-expanded': 'false',
				'aria-hidden': 'true'
			});
			$(".mobile-search-link").removeClass('open').children(":first").attr({'aria-label': 'open search'});
		}
		return false;
	});

	// open menu
	$(".mobile-nav-link").click(function (e) {
		// close search
		$("#mobile-search").slideUp(_time).attr({
			'aria-expanded': 'false',
			'aria-hidden': 'true'
		});
		$(".mobile-search-link").removeClass('open').children(":first").attr({'aria-label': 'open search'});
		var el = $("#mobile-nav");
		// open menu
		if ($(el).is(":hidden")) {
			$(el).slideDown(_time).attr({
				'aria-expanded': 'true',
				'aria-hidden': 'false'
			});
			$(".mobile-nav-link").addClass('open').children(":first").attr({'aria-label': 'close menu'});
		// close menu
		} else {
			$(el).slideUp(_time).attr({
				'aria-expanded': 'false',
				'aria-hidden': 'true'
			});
			$(".mobile-nav-link").removeClass('open').children(":first").attr({'aria-label': 'open menu'});
		}
		return false;
	});

	// close mobile search, nav on window resize
	$(window).on('resize', function () {
		if ($('#mobile-links').is(":hidden")) {
			$("#mobile-search").hide();
			$("#mobile-nav").hide();
			$('.mobile-search-link').removeClass('open');
			$('.mobile-nav-link').removeClass('open');
		}
	});

	// mobile navigation
	$('.caret').click(function (e) {
		e.preventDefault();
		var clicked = $(this);
		// hide all
		var parents = $(clicked).parentsUntil('#m-drill-nav', 'ul');
		$.each($('.caret').next('ul'), (function (index, obj) {
			var _subitems = $(obj).prev().attr('aria-label').match(/\d+/g);
			$(obj).slideUp(_time).prev().removeClass('open').attr('aria-label', 'expand collapsed list with ' + _subitems + ' sub-items.');
		}));
		// open the clicked item
		var item = clicked.next('ul');
		var _n = $(item).prev().attr('aria-label').match(/\d+/g);
		if (item.is(':hidden')) {
			item.slideDown(_time);
			clicked.addClass('open').attr({
							'aria-expanded': 'true',
							'aria-label': 'collapse list with ' + _n + ' sub-items.'
			});
			clicked.next().attr({'aria-hidden':'false'}).find('a').first().focus();
		} else {
			// close clicked item
			item.slideUp(_time);
			clicked.removeClass('open').attr({
				'aria-expanded': 'false',
				'aria-label': 'expand list with ' + _n + ' sub-items.'
			});
			clicked.next().attr({'aria-hidden':'true'});
			clicked.parent().next().find('a').first().focus();
		}
	});

};

$(document).ready(ready);
$(document).on('page:load', ready);
