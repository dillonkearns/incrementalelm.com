import { Elm } from "../Main.elm";
import { imageAssets, routes } from "./image-assets";

document.addEventListener("DOMContentLoaded", function() {
  Elm.Main.init({
    node: document.getElementById("app"),
    flags: { imageAssets, routes }
  });

  if (navigator.userAgent.indexOf("Headless") >= 0) {
    const firstMetaChild = document.getElementsByTagName("head")[0];
    const headTags = document.getElementById("elm-head-tags").children;
    for (let headTag of headTags) {
      firstMetaChild.appendChild(headTag);
    }
    // document.dispatchEvent(new Event("prerender-trigger"));
  }
  document.getElementById("elm-head-tags").remove();
});
