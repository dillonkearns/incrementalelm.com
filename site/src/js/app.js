import { Elm } from "../Main.elm";

const images = {
  "dillon2.jpg": require("../../images/dillon2.jpg"),
  "article-cover/exit.jpg": require("../../images/article-cover/exit.jpg"),
  "article-cover/mountains.jpg": require("../../images/article-cover/mountains.jpg"),
  "article-cover/thinker.jpg": require("../../images/article-cover/thinker.jpg")
};

document.addEventListener("DOMContentLoaded", function() {
  Elm.Main.init({
    node: document.getElementById("app"),
    flags: { images }
  });
});
