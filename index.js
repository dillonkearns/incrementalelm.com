import "./lib/codemirror.css";
import "./src/js/code-editor.js";
import "./lib/native-shim.js";
import "./style.css";
const { Elm } = require("./src/Main.elm");
const pagesInit = require("elm-pages");

pagesInit({
  mainElmModule: Elm.Main
});
