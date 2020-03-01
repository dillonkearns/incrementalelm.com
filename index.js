import "./lib/codemirror.css";
import "./src/js/code-editor.js";
import "./lib/native-shim.js";
import "./style.css";

const parts = new Intl.DateTimeFormat(undefined, { timeZoneName: 'long' }).formatToParts(new Date())
const timeZoneName = parts.find(part => part.type === 'timeZoneName').value
const { Elm } = require("./src/Main.elm");
const pagesInit = require("elm-pages");

pagesInit({
  mainElmModule: Elm.Main
}).then(app => {
  app.ports.initialTimeZoneName.send(timeZoneName);
});
