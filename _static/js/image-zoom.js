// Click-to-zoom for scaled content images, using medium-zoom (pinned and vendored in
// medium-zoom-1.1.0.min.js). Sphinx wraps each image scaled with :width:/:scale: in a link to the
// full-size file; this zooms those images in place instead. The link stays, so:
// - keyboard users can Tab to an image and press Enter to zoom it (Escape closes);
// - Ctrl/Cmd/Shift-click still opens the full-size file;
// - when zooming would not enlarge the image (e.g. a tall image limited by the window height),
//   the link opens the full-size file as before.
// Images linked elsewhere (:target:) are left alone. Add the "no-zoom" class to opt one out.
document.addEventListener("DOMContentLoaded", function () {
  if (typeof mediumZoom !== "function") return;

  var MARGIN = 24;
  var zoom = mediumZoom({ margin: MARGIN, background: "var(--pst-color-background)" });

  // The scale medium-zoom would use: fit the window, never past the image's natural size.
  function zoomGain(img) {
    var r = img.getBoundingClientRect();
    if (!r.width || !r.height || !img.naturalWidth) return 0;
    var vw = document.documentElement.clientWidth - MARGIN * 2;
    var vh = document.documentElement.clientHeight - MARGIN * 2;
    return Math.min(
      Math.min(Math.max(r.width, img.naturalWidth), vw) / r.width,
      Math.min(Math.max(r.height, img.naturalHeight), vh) / r.height
    );
  }

  document.querySelectorAll("article.bd-article a.image-reference").forEach(function (link) {
    var img = link.querySelector("img");
    if (!img || img.classList.contains("no-zoom") || link.href !== img.src) return;
    zoom.attach(img);

    link.addEventListener("click", function (event) {
      if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || zoomGain(img) < 1.1) {
        event.stopPropagation(); // follow the link; keep medium-zoom's click handler out of it
        return;
      }
      event.preventDefault();
      // A mouse click on the image reaches medium-zoom's own handler; Enter on the link does not.
      if (event.target !== img) zoom.toggle({ target: img });
    });
  });
});
