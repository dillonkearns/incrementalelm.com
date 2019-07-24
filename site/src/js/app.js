import { Elm } from "../Main.elm";
require("../../../assets/architecture.jpg");

document.addEventListener("DOMContentLoaded", function() {
  Elm.Main.init({
    node: document.getElementById("app")
  });
});
