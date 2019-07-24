import { Elm } from "../Main.elm";
import { imageAssets } from "./image-assets";

document.addEventListener("DOMContentLoaded", function() {
  Elm.Main.init({
    node: document.getElementById("app"),
    flags: { imageAssets }
  });
});
