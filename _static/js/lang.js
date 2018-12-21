$(document).ready(function() {
	$('#langselect').val(DOCUMENTATION_OPTIONS['LANGUAGE']);
	$('link[rel="alternate"]').remove();
});

$('#langselect').change(function(){
	var pageURL = $(location).attr("href");
	pageURL = pageURL.replace("https://docs.dash.org/" + DOCUMENTATION_OPTIONS['LANGUAGE'], "")
	window.location.href = "https://docs.dash.org/" + $('#langselect').val() + pageURL;
});
