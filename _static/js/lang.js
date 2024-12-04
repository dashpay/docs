$(document).ready(function() {
	/* Select current language */
	$('#langselect').val(DOCUMENTATION_OPTIONS['LANGUAGE']);

	// Define paths where the language selector should be hidden
	var excludePattern = [
		"/docs/core/"
	];

	// Get the current path of the page
	var pagePath = $(location).attr("pathname");
	console.log(pagePath)
	// Check if the current page path contains the exclude pattern
	var shouldHideLangSelector = pagePath.includes(excludePattern);

	if (shouldHideLangSelector) {
		$('#langselect').hide();
	} else {
		$('#langselect').show(); // Ensure it's shown if not excluded
	}
});

$(function(){
	var siteURL = "https://docs.dash.org/";

	// Function to convert language codes
	function convertLangCode(lang) {
		const langMapping = {
			'zh-CN': 'zh-cn',
			'zh-TW': 'zh-tw'
		};
		return langMapping[lang] || lang;
	}

	$("#langselect").on('change', function() {
		var pageURL = $(location).attr("href");

		// Convert language codes
		var siteLang = DOCUMENTATION_OPTIONS['LANGUAGE'];
		var currentLang = convertLangCode(siteLang);
		var newLang = convertLangCode($('#langselect').val());

		pageURL = pageURL.replace(siteURL + currentLang, "");
		var newFullURL = siteURL + newLang + pageURL;
		// console.log(`pageURL: ${pageURL}`);
		console.log(`Switch to: ${newFullURL}`);
		window.location.href = newFullURL;
	});
});
