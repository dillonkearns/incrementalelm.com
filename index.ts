type ElmPagesInit = {
  load: (elmLoaded: Promise<unknown>) => Promise<void>;
  flags: unknown;
};

const config: ElmPagesInit = {
  load: async function (elmLoaded) {
    const app = await elmLoaded as any;
    app.ports?.toggleDarkMode?.subscribe?.(() => {
      const current = document.documentElement.classList.contains("dark")
        ? "dark"
        : "light";
      const next = current === "dark" ? "light" : "dark";
      localStorage.setItem("darkMode", next);
      document.documentElement.classList.remove(current);
      document.documentElement.classList.add(next);
    });
  },
  flags: function () {
    const darkMode =
      localStorage.getItem("darkMode") ||
      (window.matchMedia("(prefers-color-scheme: dark)").matches
        ? "dark"
        : "light");
    // Apply dark/light class immediately to avoid flash
    document.documentElement.classList.add(darkMode);
    return { darkMode };
  },
};

export default config;
