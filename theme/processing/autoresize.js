document.addEventListener("DOMContentLoaded", function (event) {
  var canvas = document.getElementById("thecanvas");

  Processing.loadSketchFromSources(
      canvas, ['../theme/processing/lines.pde']
  );
  window.addEventListener("resize", resizeCanvas);
  setTimeout(resizeCanvas, 10);

  var aside = document.getElementsByTagName("aside")[0];
  aside.addEventListener("mouseenter", function () {
    Processing.getInstanceById("thecanvas").animate(true);
  });
  aside.addEventListener("mouseleave", function () {
    Processing.getInstanceById("thecanvas").animate(false);
  });
});

function resizeCanvas()
{
  var aside = document.getElementById("thecanvas").parentElement;
  var canvas = Processing.getInstanceById("thecanvas");

  if (canvas === undefined) {
    console.log("Canvas undefined...");
    setTimeout(function () { resizeCanvas(); }, 30);
  } else {
    // I FUCKING HATE HTML FUCKING SHIT TO HELL WITH THIS
    var div = document.querySelector("aside > div");
    var height = Math.max(div.clientHeight, aside.clientHeight);
    canvas.size(aside.offsetWidth, height);
    canvas.setup();
    aside.style.backgroundColor = "transparent";
  }
}
