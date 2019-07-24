import { Elm } from "../Main.elm";

const assets = {
  "dillon2.jpg": require("../../assets/assets/dillon2.jpg"),
  "article-cover/exit.jpg": require("../../assets/assets/article-cover/exit.jpg"),
  "article-cover/mountains.jpg": require("../../assets/assets/article-cover/mountains.jpg"),
  "article-cover/thinker.jpg": require("../../assets/assets/article-cover/thinker.jpg")
};

console.log(assets);

document.addEventListener("DOMContentLoaded", function() {
  Elm.Main.init({
    node: document.getElementById("app"),
    flags: { assets }
  });
});
