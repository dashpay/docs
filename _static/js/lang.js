$(document).ready(function() {
	$('#langselect').val(DOCUMENTATION_OPTIONS['LANGUAGE']);
	jQuery('link[rel="alternate"]').remove();
	var link = document.createElement('link');
	link.rel = "alternate";
	link.hreflang = "x-default";
	link.href = "https://docs.dash.org/en/latest/";
	jQuery('head').append(link);
});

$('#langselect').change(function(){
	var pageURL = $(location).attr("href");
	pageURL = pageURL.replace("https://docs.dash.org/" + DOCUMENTATION_OPTIONS['LANGUAGE'], "")
	window.location.href = "https://docs.dash.org/" + $('#langselect').val() + pageURL;
});
