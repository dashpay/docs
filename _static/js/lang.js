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
	var siteURL = "https://docs.dash.org/";
	$("#langselect").on('change', function() {
		var pageURL = $(location).attr("href");
		console.log(`pageURL: ${pageURL}`);
		var newLang = $('#langselect').val();
		console.log(`newLang: ${newLang}`);
		if (newLang == "zh-CN") {
			newLang = "zh_CN";
		} else if (newLang == "zh-TW") {
			newLang = "zh_TW";
		}
		console.log(`Adjusted newLang: ${newLang}`)
		
		var currentLang = DOCUMENTATION_OPTIONS['LANGUAGE'];
		console.log(`currentLang: ${currentLang}`);
		if (currentLang == "zh-CN") {
			currentLang = "zh_CN";
		} else if (currentLang == "zh-TW") {
			currentLang = "zh_TW";
		}
		console.log(`Adjusted currentLang: ${currentLang}`);

		pageURL = pageURL.replace(siteURL + currentLang, "");
		console.log(`pageURL: ${pageURL}`);
		console.log(`Switch to: ${siteURL + newLang + pageURL}`);
		window.location.href = siteURL + newLang + pageURL;
	});
});
