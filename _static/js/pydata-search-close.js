// Script to allow use of readthedocs-sphinx-search extension with the pydata theme
//
// Based in part on:
// https://github.com/pydata/pydata-sphinx-theme/blob/v0.13.3/src/pydata_sphinx_theme/assets/scripts/pydata-sphinx-theme.js#L167-L272

/*******************************************************************************
 * Search
 */
/** Find any search forms on the page and return their input element */
var findSearchInput = () => {
  let forms = document.querySelectorAll("form.bd-search");
  if (!forms.length) {
    // no search form found
    return;
  } else {
    var form;
    if (forms.length == 1) {
      // there is exactly one search form (persistent or hidden)
      form = forms[0];
    } else {
      // must be at least one persistent form, use the first persistent one
      form = document.querySelector(
        "div:not(.search-button__search-container) > form.bd-search"
      );
    }
    return form.querySelector("input");
  }
};

// Hide Pydata theme's search
var hidePydataSearch = () => {
  let input = findSearchInput();
  let searchPopupWrapper = document.querySelector(".search-button__wrapper");
  let hiddenInput = searchPopupWrapper.querySelector("input");
  
  if (input === hiddenInput) {
    searchPopupWrapper.classList.remove("show");
  }
  
  if (document.activeElement === input) {
    input.blur();
  }
};

// Hide the ReadTheDocs search (addon version)
function hideRtdSearch() {
    // Grab the search element from the DOM
    const searchElement = document.querySelector('readthedocs-search');        
    searchElement.closeModal(); 
}

// Hide any open search screens
function hideSearch() {
  hidePydataSearch();
  hideRtdSearch();
}

// Show the ReadTheDocs search (addon version)
function showRtDSearch() {
  const searchElement = document.querySelector('readthedocs-search');
  searchElement.showModal();
  
  // If we're displaying ReadTheDocs search, make sure to hide the Pydata theme's search
  hidePydataSearch();
}

// Add event listeners for key strokes
var addEventListenerForSearchKeyboard = () => {
  window.addEventListener(
    "keydown",
    (event) => {
      // Allow Escape key to hide the search field
      if (event.code == "Escape") {
        hidePydataSearch();
      }

      // Open the ReadTheDocs search modal when Ctrl+K is pressed
      if (event.ctrlKey && event.key === 'k') {
        event.preventDefault(); // Prevent default behavior of Ctrl+K
        showRtDSearch()
      }
    },
    true
  );
};

// Activate callbacks for search button popup
var setupSearchButtons = () => {
  addEventListenerForSearchKeyboard();

  // Add event listeners to elements with class "search-button__button"
  const searchButtons = document.querySelectorAll('.search-button__button');
  searchButtons.forEach(button => {
    button.addEventListener('click', showRtDSearch);
  });
};

// Custom code to manage closing the RtD search dialog properly
$(document).ready(function(){
  $(".search-button__overlay").click(function(){
    // Shouldn't be necessary since it's currently hidden by CSS, but just in case
    console.log("Close by search-button__overlay");
    hidePydataSearch();
  });
});

$(setupSearchButtons);
