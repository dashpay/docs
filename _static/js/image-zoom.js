// Click-to-zoom for content images, using medium-zoom (vendored in medium-zoom.min.js).
// Only images that are shown smaller than their real size get zoom, since medium-zoom never
// enlarges past the natural size. Images inside a link (e.g. a :target:) keep their link.
// Add the "no-zoom" class to an image to opt it out.
document.addEventListener("DOMContentLoaded", function () {
  if (typeof mediumZoom !== "function") return;

  var zoom = mediumZoom({
    margin: 24,
    background: "var(--pst-color-background)",
  });

  function consider(img) {
    if (img.closest("a") || img.classList.contains("no-zoom")) return;
    if (img.naturalWidth > img.clientWidth + 1) zoom.attach(img);
  }

  document.querySelectorAll("article.bd-article img").forEach(function (img) {
    if (img.complete) consider(img);
    else img.addEventListener("load", function () { consider(img); }, { once: true });
  });
});
