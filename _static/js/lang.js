$(document).ready(function() {
	$('#langselect').val(DOCUMENTATION_OPTIONS['LANGUAGE']);
});

$('#langselect').change(function(){
	window.location.href = "https://docs.dash.org/" + $('#langselect').val() + "/latest/";
});
