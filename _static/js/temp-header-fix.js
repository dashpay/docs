// Will not be necessary after https://github.com/pydata/pydata-sphinx-theme/pull/1331 is released
// Found in https://github.com/pydata/pydata-sphinx-theme/issues/1235#issuecomment-1463932759
$(document).ready(function () {
  var fixalign = document.getElementsByClassName("navbar-header-items__start")
  fixalign[0].classList.add("col-lg-3");
});
