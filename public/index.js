import "./js/code-editor.js";
import "./lib/native-shim.js";

export default {
  load: async function (elmLoaded) {
    applyDarkModeClass();

    const elmApp = await elmLoaded;
    elmApp.ports.toggleDarkMode.subscribe(toggleDarkMode);
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

function toggleDarkMode() {
  if (isDarkMode()) {
    localStorage.setItem("theme", "light");
  } else {
    localStorage.setItem("theme", "dark");
  }
  applyDarkModeClass();
}
function applyDarkModeClass() {
  if (isDarkMode()) {
    document.documentElement.classList.add("dark");
    document.documentElement.classList.remove("light");
  } else {
    document.documentElement.classList.add("light");
    document.documentElement.classList.remove("dark");
  }
}
