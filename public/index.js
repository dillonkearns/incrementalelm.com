import "./js/code-editor.js";
import "./lib/native-shim.js";

export default {
  load: function (elmLoaded) {
    if (isDarkMode()) {
      document.documentElement.classList.add("dark");
      document.documentElement.classList.remove("light");
    } else {
      document.documentElement.classList.add("light");
      document.documentElement.classList.remove("dark");
    }
    document.addEventListener("DOMContentLoaded", function (event) {});
  },
  flags: function () {
    return { darkMode: isDarkMode() };
  },
};

function isDarkMode() {
  return (
    localStorage.theme === "dark" ||
    (!("theme" in localStorage) &&
      window.matchMedia("(prefers-color-scheme: dark)").matches)
  );
}
