import { Elm } from "../Main.elm";
import { imageAssets, routes } from "./image-assets";

document.addEventListener("DOMContentLoaded", function() {
  Elm.Main.init({
    node: document.getElementById("app"),
    flags: { imageAssets, routes }
  });

  const elmHeadTagsContainer = document.getElementById("elm-head-tags");
  if (elmHeadTagsContainer) {
    if (navigator.userAgent.indexOf("Headless") >= 0) {
      const firstMetaChild = document.getElementsByTagName("head")[0];
      const headTags = elmHeadTagsContainer.children;
      for (let headTag of headTags) {
        firstMetaChild.appendChild(headTag);
      }
      // document.dispatchEvent(new Event("prerender-trigger"));
    }
    // elmHeadTagsContainer.remove();
  }
});
