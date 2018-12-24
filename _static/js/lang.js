$(document).ready(function() {
	$('#langselect').val(DOCUMENTATION_OPTIONS['LANGUAGE']);
	jQuery('link[rel="alternate"]').remove();
	$.each(DOCUMENTATION_OPTIONS, function(index, value) {
		var link = document.createElement('link');
		var pageURL = $(location).attr("href");
		pageURL = pageURL.replace("https://docs.dash.org/" + value , "");
		link.rel = "alternate";
		link.hreflang = value;
		link.href = "https://docs.dash.org/" + value + pageURL;
		jQuery('head').append();
	});
});

$('#langselect').change(function(){
	var pageURL = $(location).attr("href");
	pageURL = pageURL.replace("https://docs.dash.org/" + DOCUMENTATION_OPTIONS['LANGUAGE'], "");
	window.location.href = "https://docs.dash.org/" + $('#langselect').val() + pageURL;
});
