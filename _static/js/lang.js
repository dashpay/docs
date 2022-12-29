$(document).ready(function() {
	/* Select current language */
	$('#langselect').val(DOCUMENTATION_OPTIONS['LANGUAGE']);
	
	/* Set alternate links 
	var langs = [ "de", "en", "es", "fr", "pt", "vi", "el", "ru", "ko", "ja", "zh-Hans", "zh-Hant", "ar", "x-default" ];
	var pageURL = $(location).attr("href");
	pageURL = pageURL.replace("https://docs.dash.org/" + DOCUMENTATION_OPTIONS['LANGUAGE'] , "");
	$.each(langs, function(index, value) {
		var link = document.createElement('link');
		link.rel = "alternate";
		link.hreflang = value;
		if (value == "x-default") {
			link.href = "https://docs.dash.org/en" + pageURL;
		} else if (value == "zh-Hans") {
			link.href = "https://docs.dash.org/zh_CN" + pageURL;
		} else if (value == "zh-Hant") {
			link.href = "https://docs.dash.org/zh_TW" + pageURL;
		} else {
			link.href = "https://docs.dash.org/" + value + pageURL;
		}
		jQuery('head').append(link);
	});*/
});

$(function(){
	$("#langselect").on('change', function() {
		var pageURL = $(location).attr("href");
		var newLang = $('#langselect').val();
		if (newLang == "zh-CN") {
			newLang = "zh_CN";
		} else if (newLang == "zh-TW") {
			newLang = "zh_TW";
		}
		
		var currentLang = DOCUMENTATION_OPTIONS['LANGUAGE'];
		if (currentLang == "zh-CN") {
			currentLang = "zh_CN";
		} else if (currentLang == "zh-TW") {
			currentLang = "zh_TW";
		}

		pageURL = pageURL.replace("https://docs.dash.org/" + currentLang, "");
		window.location.href = "https://docs.dash.org/" + newLang + pageURL;
	});
});
