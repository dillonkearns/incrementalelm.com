import { Elm } from "../Main.elm";
import { imageAssets, routes } from "./image-assets";

document.addEventListener("DOMContentLoaded", function() {
  let app = Elm.Main.init({
    node: document.getElementById("app"),
    flags: { imageAssets, routes }
  });

  app.ports.toJsPort.subscribe(stuff => {
    if (navigator.userAgent.indexOf("Headless") >= 0) {
      appendTag();
    }
    console.log("stuff", stuff);
    document.dispatchEvent(new Event("prerender-trigger"));
  });
});

function appendTag() {
  const meta = document.createElement("meta");
  meta.setAttribute("property", "hello");
  meta.setAttribute("name", "world");
  document.getElementsByTagName("head")[0].appendChild(meta);
}
